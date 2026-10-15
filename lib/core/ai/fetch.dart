import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../data/db.dart';
import '../data/seed_mapping.dart';
import 'ai_client.dart';
import 'errors.dart';
import 'permissions.dart';
import 'prompts/fetch_prompts.dart';

const _projectTypes = ['short_film', 'long_film', 'youtube', 'short'];
const _categories = [
  'size', 'angle', 'movement', 'composition', 'lens', 'lighting', //
];
const _maxTextPerSource = 6000;

/// One piece of gathered source text (step 1 of fetchConvert, no AI).
class FetchedSource {
  const FetchedSource(
    this.title,
    this.url,
    this.text, {
    this.imageUrls = const [],
  });
  final String title;
  final String url;
  final String text;
  final List<String> imageUrls;
}

class SlotDraft {
  const SlotDraft(this.name, this.description, this.runtimeProportion);
  final String name;
  final String description;
  final double? runtimeProportion;
}

class ImageCandidate {
  const ImageCandidate(this.url, this.sourceUrl);
  final String url;
  final String sourceUrl;
}

/// What fetchConvert produced. Field names follow DATA_MODEL (AI_CONTRACT 4.11).
sealed class FetchOutcome {
  const FetchOutcome();
}

class TemplateDraft extends FetchOutcome {
  const TemplateDraft(
    this.name,
    this.description,
    this.projectTypes,
    this.slots,
    this.sources,
  );
  final String name;
  final String description;
  final List<String> projectTypes;
  final List<SlotDraft> slots;
  final List<Map<String, String>> sources; // [{title,url}], never empty
  String? get sourceUrl => sources.first['url'];
}

class ShotDraft extends FetchOutcome {
  const ShotDraft(
    this.name,
    this.category,
    this.description,
    this.whenToUse,
    this.effect,
    this.tags,
    this.imageCandidates,
    this.sources,
  );
  final String name;
  final String category;
  final String description;
  final String whenToUse;
  final String effect;
  final List<String> tags;
  final List<ImageCandidate> imageCandidates;
  final List<Map<String, String>> sources; // never empty
}

/// The request cannot be a template or a shot entry (or no source was found).
class CannotConvert extends FetchOutcome {
  const CannotConvert(this.reason);
  final String reason;
}

/// Gathers sources (Wikipedia + Commons, optional Brave, pasted URLs) and
/// converts them with ONE Gemini call. See AI_CONTRACT 4.11 / D-21.
class FetchConvert {
  FetchConvert(this.ai, {this.braveKey});
  final AiClient ai;
  final String? braveKey;

  /// [kind]: `template` | `shot` | `auto`.
  Future<FetchOutcome> run(
    String request, {
    String kind = 'auto',
    List<String> projectTypes = const [],
    List<Uri> pastedUrls = const [],
    Map<String, dynamic> permissions = const {},
  }) async {
    if (!aiAllowed(permissions, AiPermission.internetFetch)) {
      throw AiPermissionDenied(AiPermission.internetFetch.key);
    }
    final sources = await gather(request, pastedUrls);
    if (sources.isEmpty) {
      return const CannotConvert('No source text found for this request');
    }
    final urls = {for (final s in sources) s.url};
    final images = {for (final s in sources) ...s.imageUrls};
    final prompt =
        '$fetchSharedRules\n$fetchConvertInstruction\n'
        'GRAMMAR_CLEANUP: false\nLOCALE: en-IN\n'
        'REQUEST: $request\nKIND: $kind\nPROJECT_TYPES: ${projectTypes.join(', ')}\n'
        'SOURCES:\n${[for (final s in sources) '--- URL: ${s.url}\nTITLE: ${s.title}\n'
              '${s.imageUrls.map((u) => 'IMAGE: $u\n').join()}${s.text}'].join('\n')}';
    final j = await ai.generateJson(
      prompt: prompt,
      schema: fetchSchema,
      gate: AiPermission.internetFetch,
      permissions: permissions,
    );
    return parseFetchResult(j, urls, images);
  }

  /// Step 1: Wikipedia + Commons always; Brave only with a key; pasted URLs.
  /// A source that fails to load is skipped.
  Future<List<FetchedSource>> gather(String request, List<Uri> pasted) async {
    final out = <FetchedSource>[];
    Future<void> tryAdd(Future<List<FetchedSource>> f) async {
      try {
        out.addAll(await f);
      } on AiException {
        // skip this source
      } on FormatException {
        // skip malformed API reply
      }
    }

    await tryAdd(_wiki('en.wikipedia.org', request, commons: false));
    await tryAdd(_wiki('commons.wikimedia.org', request, commons: true));
    if (braveKey != null && braveKey!.isNotEmpty) await tryAdd(_brave(request));
    for (final u in pasted) {
      await tryAdd(_page(u));
    }
    final seen = <String>{};
    return [
      for (final s in out)
        if (seen.add(s.url)) s,
    ];
  }

  Future<List<FetchedSource>> _wiki(
    String host,
    String q, {
    required bool commons,
  }) async {
    final uri = Uri.https(host, '/w/api.php', {
      'action': 'query',
      'format': 'json',
      'generator': 'search',
      'gsrsearch': q,
      'gsrlimit': '2',
      if (commons) 'gsrnamespace': '6',
      'prop': commons ? 'imageinfo|info' : 'extracts|info',
      if (commons) 'iiprop': 'url',
      if (!commons) ...{'explaintext': '1', 'exlimit': '2'},
      'inprop': 'url',
    });
    final pages =
        (jsonDecode(await ai.getText(uri))['query']?['pages']
            as Map<String, dynamic>?) ??
        {};
    return [
      for (final p in pages.values.cast<Map<String, dynamic>>())
        FetchedSource(
          p['title'] as String,
          p['fullurl'] as String,
          _cap(
            commons
                ? 'Wikimedia Commons file: ${p['title']}'
                : (p['extract'] as String? ?? ''),
          ),
          imageUrls: [
            if (commons)
              for (final i in (p['imageinfo'] as List? ?? []))
                (i as Map)['url'] as String,
          ],
        ),
    ];
  }

  Future<List<FetchedSource>> _brave(String q) async {
    final raw = await ai.getText(
      Uri.https('api.search.brave.com', '/res/v1/web/search', {
        'q': q,
        'count': '3',
      }),
      headers: {
        'x-subscription-token': braveKey!,
        'accept': 'application/json',
      },
    );
    final results = (jsonDecode(raw)['web']?['results'] as List?) ?? [];
    return [
      for (final r in results.cast<Map<String, dynamic>>())
        FetchedSource(
          r['title'] as String,
          r['url'] as String,
          _cap(_strip(r['description'] as String? ?? '')),
        ),
    ];
  }

  Future<List<FetchedSource>> _page(Uri u) async {
    final html = await ai.getText(u);
    final title =
        RegExp(
          r'<title[^>]*>(.*?)</title>',
          dotAll: true,
        ).firstMatch(html)?.group(1) ??
        u.host;
    final body = html.replaceAll(
      RegExp(r'<(script|style)[^>]*>.*?</\1>', dotAll: true),
      ' ',
    );
    return [FetchedSource(_strip(title), u.toString(), _cap(_strip(body)))];
  }

  static String _strip(String s) => s
      .replaceAll(RegExp(r'<[^>]*>'), ' ')
      .replaceAll('&amp;', '&')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();

  static String _cap(String s) =>
      s.length > _maxTextPerSource ? s.substring(0, _maxTextPerSource) : s;
}

/// Validates the model's reply (AI_CONTRACT 9.1 item 8). [urls] are the step-1
/// source URLs; sources outside them are dropped. Bad shape throws.
FetchOutcome parseFetchResult(
  Map<String, dynamic> j,
  Set<String> urls,
  Set<String> imageUrls,
) {
  try {
    final result = j['result'] as String;
    if (result == 'cannot_convert') {
      return CannotConvert((j['reason'] as String?) ?? 'Cannot be converted');
    }
    final sources = [
      for (final s in (j['sources'] as List).cast<Map<String, dynamic>>())
        if (urls.contains(s['url']))
          {'title': s['title'] as String, 'url': s['url'] as String},
    ];
    if (sources.isEmpty) {
      return const CannotConvert('The model cited no fetched source');
    }
    if (result == 'template') {
      final t = j['template'] as Map<String, dynamic>;
      final types = (t['project_types'] as List).cast<String>();
      final slots = [
        for (final s in (t['slots'] as List).cast<Map<String, dynamic>>())
          SlotDraft(
            s['name'] as String,
            s['description'] as String,
            (s['runtime_proportion'] as num?)?.toDouble(),
          ),
      ];
      final sum = slots.fold<double>(
        0,
        (a, s) => a + (s.runtimeProportion ?? 0),
      );
      if (slots.isEmpty ||
          sum > 1.0001 ||
          types.any((p) => !_projectTypes.contains(p))) {
        throw const FormatException();
      }
      return TemplateDraft(
        t['name'] as String,
        t['description'] as String,
        types,
        slots,
        sources,
      );
    }
    if (result == 'shot') {
      final s = j['shot'] as Map<String, dynamic>;
      if (!_categories.contains(s['category'])) throw const FormatException();
      return ShotDraft(
        s['name'] as String,
        s['category'] as String,
        s['description'] as String,
        s['when_to_use'] as String,
        s['effect'] as String,
        (s['tags'] as List).cast<String>(),
        [
          for (final c
              in (s['image_candidates'] as List).cast<Map<String, dynamic>>())
            if (imageUrls.contains(c['url']) && urls.contains(c['source_url']))
              ImageCandidate(c['url'] as String, c['source_url'] as String),
        ],
        sources,
      );
    }
    throw const FormatException();
  } on FormatException {
    throw const AiMalformedResponse('Fetch result failed validation');
  } on TypeError {
    throw const AiMalformedResponse('Fetch result failed validation');
  }
}

/// Saves an approved draft into the same rows the seed loader writes, via
/// seed_mapping.dart, then flips them to user rows (builtin 0, seed_id NULL).
/// Returns the new template/shot id.
Future<String> saveFetchDraft(
  AppDatabase db,
  FetchOutcome draft, {
  int? now,
}) async {
  final t = now ?? DateTime.now().millisecondsSinceEpoch;
  final id = const Uuid().v4();
  const user = Value<bool>(false);
  const noSeed = Value<String?>(null);
  switch (draft) {
    case TemplateDraft():
      final m = mapSeedTemplate({
        'id': id,
        'name': draft.name,
        'description': draft.description,
        'source_urls': [for (final s in draft.sources) s['url']],
        'project_types': <String>[],
        'slots': [
          for (final (i, s) in draft.slots.indexed)
            {
              'id': '$i',
              'name': s.name,
              'description': s.description,
              'proportion': s.runtimeProportion,
            },
        ],
      }, t);
      await db.transaction(() async {
        await db
            .into(db.templates)
            .insert(
              m.template.copyWith(
                projectTypes: Value(draft.projectTypes),
                builtin: user,
                seedId: noSeed,
              ),
            );
        for (final s in m.slots) {
          await db
              .into(db.slots)
              .insert(
                s.copyWith(
                  id: Value('$id/${const Uuid().v4()}'),
                  builtin: user,
                  seedId: noSeed,
                ),
              );
        }
      });
    case ShotDraft():
      final m = mapSeedShot({
        'id': id,
        'name': draft.name,
        'category': draft.category == 'size' ? 'shot_size' : draft.category,
        'description': draft.description,
        'when_to_use': draft.whenToUse,
        'effect': draft.effect,
        'tags': draft.tags,
        'sources': [for (final s in draft.sources) s['url']],
        'images': <Map<String, dynamic>>[],
      }, t);
      await db
          .into(db.shots)
          .insert(
            m.shot.copyWith(
              sources: Value(draft.sources),
              builtin: user,
              seedId: noSeed,
            ),
          );
    case CannotConvert():
      throw ArgumentError('Nothing to save');
  }
  return id;
}

/// One LIBRARY row for shotOptions. Fetched drafts are passed in with their
/// own temporary id (e.g. `draft-1`) so the model can pick them too.
class LibraryShot {
  const LibraryShot(this.id, this.name, this.category, this.description);
  final String id;
  final String name;
  final String category;
  final String description;
}

class ShotOption {
  const ShotOption(this.shotId, this.why);
  final String shotId;
  final String why;
}

class ShotOptionsResult {
  const ShotOptionsResult(this.options, this.wantsFetch);
  final List<ShotOption> options;
  final List<String> wantsFetch;
}

/// "What shots work for ...?" (AI_CONTRACT 4.12). Gate: shot_suggestions;
/// `wants_fetch` is dropped unless internet_fetch is also on.
Future<ShotOptionsResult> shotOptions(
  AiClient ai,
  String question,
  List<LibraryShot> library, {
  String frameContext = '',
  Map<String, dynamic> permissions = const {},
}) async {
  final canFetch = aiAllowed(permissions, AiPermission.internetFetch);
  final lib = library.take(60).toList();
  final prompt =
      '$fetchSharedRules\n$shotOptionsInstruction\n'
      'GRAMMAR_CLEANUP: false\nLOCALE: en-IN\nWANTS_FETCH_ALLOWED: $canFetch\n'
      'QUESTION: $question\nFRAME_CONTEXT: $frameContext\nLIBRARY:\n'
      '${jsonEncode([
        for (final s in lib) {'shot_id': s.id, 'name': s.name, 'category': s.category, 'description': s.description.length > 120 ? s.description.substring(0, 120) : s.description},
      ])}';
  final j = await ai.generateJson(
    prompt: prompt,
    schema: shotOptionsSchema,
    gate: AiPermission.shotSuggestions,
    permissions: permissions,
  );
  final ids = {for (final s in lib) s.id};
  try {
    return ShotOptionsResult(
      [
        for (final o in (j['options'] as List).cast<Map<String, dynamic>>())
          if (ids.contains(o['shot_id']))
            ShotOption(o['shot_id'] as String, o['why'] as String),
      ],
      [if (canFetch) ...((j['wants_fetch'] as List?)?.cast<String>() ?? [])],
    );
  } on TypeError {
    throw const AiMalformedResponse('shotOptions result failed validation');
  }
}

const _str = {'type': 'STRING'};
const _nstr = {'type': 'STRING', 'nullable': true};

const fetchSchema = <String, dynamic>{
  'type': 'OBJECT',
  'required': ['result', 'sources'],
  'properties': {
    'result': {
      'type': 'STRING',
      'enum': ['template', 'shot', 'cannot_convert'],
    },
    'template': {
      'type': 'OBJECT',
      'nullable': true,
      'required': ['name', 'description', 'project_types', 'slots'],
      'properties': {
        'name': _str,
        'description': _str,
        'source_url': _nstr,
        'project_types': {
          'type': 'ARRAY',
          'items': {'type': 'STRING', 'enum': _projectTypes},
        },
        'slots': {
          'type': 'ARRAY',
          'items': {
            'type': 'OBJECT',
            'required': ['name', 'description'],
            'properties': {
              'name': _str,
              'description': _str,
              'runtime_proportion': {'type': 'NUMBER', 'nullable': true},
            },
          },
        },
      },
    },
    'shot': {
      'type': 'OBJECT',
      'nullable': true,
      'required': [
        'name', 'category', 'description', 'when_to_use', 'effect', 'tags',
        'image_candidates', //
      ],
      'properties': {
        'name': _str,
        'category': {'type': 'STRING', 'enum': _categories},
        'description': _str,
        'when_to_use': _str,
        'effect': _str,
        'tags': {'type': 'ARRAY', 'items': _str},
        'image_candidates': {
          'type': 'ARRAY',
          'items': {
            'type': 'OBJECT',
            'required': ['url', 'source_url'],
            'properties': {'url': _str, 'source_url': _str},
          },
        },
      },
    },
    'sources': {
      'type': 'ARRAY',
      'items': {
        'type': 'OBJECT',
        'required': ['title', 'url'],
        'properties': {'title': _str, 'url': _str},
      },
    },
    'reason': _nstr,
  },
};

const shotOptionsSchema = <String, dynamic>{
  'type': 'OBJECT',
  'required': ['options'],
  'properties': {
    'options': {
      'type': 'ARRAY',
      'items': {
        'type': 'OBJECT',
        'required': ['shot_id', 'why'],
        'properties': {'shot_id': _str, 'why': _str},
      },
    },
    'wants_fetch': {'type': 'ARRAY', 'nullable': true, 'items': _str},
  },
};
