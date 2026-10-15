// The validator is a flat list of one-line guards; braces would triple its size.
// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:convert';

import 'package:uuid/uuid.dart';

import 'ai_client.dart';
import 'errors.dart';
import 'organize.dart';
import 'permissions.dart';
import 'prompts/proposals_prompts.dart';
import 'words_check.dart';

/// A proposal as the AI builds it. The caller stores it as a `proposals` row;
/// the data layer's ProposalEngine applies `changes` on Approve (D-17).
class ProposalDraft {
  const ProposalDraft({
    required this.summary,
    required this.spans,
    required this.changes,
    required this.notes,
  });
  final String summary;
  final List<SummarySpan> spans;

  /// Ops with `id` and `accepted` added. `accepted` is false for ungrounded ops.
  final List<Map<String, dynamic>> changes;

  /// Ops dropped by a permission switch, for the user to see.
  final List<String> notes;
}

class ProjectDraft {
  const ProjectDraft({required this.title, required this.changes});

  /// Only a title the user said; null means ask the user.
  final String? title;
  final List<Map<String, dynamic>> changes;
}

class ProjectMention {
  const ProjectMention(this.projectId, this.confidence, this.phrase);
  final String projectId;
  final double confidence;
  final String? phrase;
}

/// AI_CONTRACT 8 lookup.
const _opGate = {
  'setSummary': AiPermission.autoSummary,
  'addCharacter': AiPermission.characterExtraction,
  'editCharacter': AiPermission.characterExtraction,
  'addBeat': AiPermission.beatGeneration,
  'editBeat': AiPermission.beatGeneration,
  'splitBeat': AiPermission.beatGeneration,
  'mergeBeats': AiPermission.beatGeneration,
  'moveBeat': AiPermission.autoPlacement,
  'placeBeatInSlot': AiPermission.autoPlacement,
  'addScaffold': AiPermission.screenplayScaffold,
};

const _generateOps = {'setSummary', 'addCharacter', 'addBeat', 'addScaffold'};
const _slotKeys = ['slot_seed_id', 'slot_id', 'position'];
const _fieldKeys = [
  'age',
  'role',
  'appearance',
  'background',
  'traits',
  'habits',
  'wants_needs_fears',
  'notes',
];

/// Ops the model may emit, after the switches. Empty = no changes requested.
List<String> allowedOps(
  Map<String, dynamic> perms, {
  bool forGenerate = false,
}) {
  final out = [
    for (final e in _opGate.entries)
      if (aiAllowed(perms, e.value) &&
          (!forGenerate || _generateOps.contains(e.key)))
        e.key,
  ];
  // generateProject: no beats means no scaffolds either (AI_CONTRACT 4.5).
  if (forGenerate && !out.contains('addBeat')) out.remove('addScaffold');
  return out;
}

Map<String, dynamic> _s({bool nullable = false}) => {
  'type': 'STRING',
  if (nullable) 'nullable': true,
};
Map<String, dynamic> _arr(
  Map<String, dynamic> items, {
  bool nullable = false,
}) => {'type': 'ARRAY', if (nullable) 'nullable': true, 'items': items};
Map<String, dynamic> _obj(
  Map<String, dynamic> props,
  List<String> req, {
  bool nullable = false,
}) => {
  'type': 'OBJECT',
  if (nullable) 'nullable': true,
  'properties': props,
  'required': req,
};

/// AI_CONTRACT 3.1 with a per-call op enum. Slot fields are left out when
/// placement is impossible.
Map<String, dynamic> changesSchema(
  List<String> ops, {
  required bool slots,
  bool withId = false,
}) {
  final nameList = _arr(_s(), nullable: true);
  final props = <String, dynamic>{
    if (withId) 'id': _s(nullable: true),
    'op': {'type': 'STRING', 'enum': ops},
    'ref': _s(nullable: true),
    'beat_id': _s(nullable: true),
    'beat_ref': _s(nullable: true),
    'beat_ids': _arr(_s(), nullable: true),
    'project_character_id': _s(nullable: true),
    'title': _s(nullable: true),
    'description': _s(nullable: true),
    'name': _s(nullable: true),
    'text': _s(nullable: true),
    if (slots) ...{
      'slot_seed_id': _s(nullable: true),
      'slot_id': _s(nullable: true),
      'position': {'type': 'INTEGER', 'nullable': true},
    },
    'character_names': nameList,
    'character_names_add': nameList,
    'character_names_remove': nameList,
    'parts': _arr(
      _obj(
        {'title': _s(), 'description': _s(), 'character_names': _arr(_s())},
        ['title', 'description', 'character_names'],
      ),
      nullable: true,
    ),
    'fields': _obj(
      {for (final k in _fieldKeys) k: _s(nullable: true)},
      [],
      nullable: true,
    ),
    'blocks': _arr(
      _obj(
        {
          'type': {
            'type': 'STRING',
            'enum': ['scene_heading', 'action'],
          },
          'text': _s(),
        },
        ['type', 'text'],
      ),
      nullable: true,
    ),
    'rows': _arr(
      _obj(
        {
          'say': _s(),
          'show': _obj(
            {
              'a_roll': _s(),
              'b_roll': _s(),
              'on_screen_text': _s(),
              'graphics': _s(),
            },
            ['a_roll', 'b_roll', 'on_screen_text', 'graphics'],
          ),
        },
        ['say', 'show'],
      ),
      nullable: true,
    ),
  };
  return _arr(_obj(props, ['op']));
}

final _summaryProp = _arr(
  _obj({'text': _s(), 'source_quotes': _arr(_s())}, ['text', 'source_quotes']),
);

Map<String, dynamic> _proposalSchema(
  List<String> ops, {
  required bool slots,
  bool withId = false,
}) {
  final hasOps = ops.isNotEmpty;
  return {
    ..._obj(
      {
        'summary_sentences': _summaryProp,
        if (hasOps) 'changes': changesSchema(ops, slots: slots, withId: withId),
      },
      ['summary_sentences', if (hasOps) 'changes'],
    ),
    'propertyOrdering': ['summary_sentences', if (hasOps) 'changes'],
  };
}

// ---- validation -----------------------------------------------------------

String _fold(String s) => s
    .toLowerCase()
    .replaceAll(RegExp('[’‘]'), "'")
    .replaceAll(RegExp('[“”]'), '"');

class _Ctx {
  _Ctx(this.perms, this.allowed, Map<String, dynamic> context, this.isFilm) {
    for (final b in (context['beats'] as List? ?? const [])) {
      beats[b['id'] as String] = b['slot_id'] != null;
    }
    for (final c in (context['characters'] as List? ?? const [])) {
      charIds.add(c['project_character_id'] as String);
      charNames.add((c['name'] as String).toLowerCase());
    }
    final slots = (context['template'] as Map?)?['slots'] as List? ?? const [];
    hasTemplate = slots.isNotEmpty;
    for (final s in slots) {
      if (s['seed_id'] != null) seeds.add(s['seed_id'] as String);
      if (s['slot_id'] != null) slotIds.add(s['slot_id'] as String);
    }
  }
  final Map<String, dynamic> perms;
  final List<String> allowed;
  final bool? isFilm;
  final beats = <String, bool>{}; // existing beat id -> placed
  final charIds = <String>{}, charNames = <String>{};
  final seeds = <String>{}, slotIds = <String>{};
  var hasTemplate = false;
}

/// Hard checks (AI_CONTRACT 9.1) + permission filter. Throws [FormatException]
/// naming the broken rule; returns kept ops (nulls stripped) and drop notes.
({List<Map<String, dynamic>> ops, List<String> notes}) _validateChanges(
  List raw,
  _Ctx x,
  String input,
) {
  final out = <Map<String, dynamic>>[];
  final notes = <String>[];
  final refs = <String, bool>{}; // addBeat ref -> placed
  final droppedRefs = <String>{};
  final nin = _fold(input);
  Never bad(String m) => throw FormatException(m);

  bool quotesOk(String t) {
    for (final m in RegExp('["“]([^"”]+)["”]').allMatches(t)) {
      if (!nin.contains(_fold(m[1]!))) return false;
    }
    return true;
  }

  for (final r in raw) {
    if (r is! Map) bad('rule 2: a change is not an object');
    final o = <String, dynamic>{
      for (final e in r.entries)
        if (e.value != null) e.key as String: e.value,
    };
    final op = o['op'];
    final gate = _opGate[op];
    if (gate == null) bad('rule 2: unknown op "$op"');
    final isAdd = op == 'addBeat';
    if (!x.allowed.contains(op)) {
      notes.add('Dropped $op: ${gate.key} is off.');
      if (isAdd && o['ref'] != null) droppedRefs.add(o['ref'] as String);
      continue;
    }
    // Ops hanging off a dropped beat go with it.
    if (droppedRefs.contains(o['beat_ref'])) continue;
    if (op != 'addScaffold' &&
        (o.containsKey('blocks') || o.containsKey('rows'))) {
      bad('rule 5: only addScaffold carries blocks/rows');
    }
    // Permission filter on fields.
    if (isAdd &&
        (!aiAllowed(x.perms, AiPermission.autoPlacement) || !x.hasTemplate)) {
      for (final k in _slotKeys) {
        o.remove(k);
      }
    }
    if (!aiAllowed(x.perms, AiPermission.characterExtraction)) {
      // Names only for characters that already exist.
      for (final k in ['character_names', 'character_names_add']) {
        if (o[k] is List) {
          o[k] = [
            for (final n in o[k] as List)
              if (x.charNames.contains((n as String).toLowerCase())) n,
          ];
        }
      }
    }

    String need(String k) {
      final v = o[k];
      if (v is! String || v.trim().isEmpty) bad('rule 2: $op needs "$k"');
      return v;
    }

    // Beat target: beat_id xor beat_ref, which must resolve.
    bool? beatTarget() {
      final id = o['beat_id'], ref = o['beat_ref'];
      if ((id == null) == (ref == null)) {
        bad('rule 2: $op needs exactly one of beat_id / beat_ref');
      }
      if (id != null) {
        if (!x.beats.containsKey(id))
          bad('rule 3: beat_id "$id" is not in the project');
        return x.beats[id];
      }
      if (!refs.containsKey(ref))
        bad('rule 3: beat_ref "$ref" has no earlier addBeat');
      return refs[ref];
    }

    void slotCheck({required bool required}) {
      final seed = o['slot_seed_id'], id = o['slot_id'];
      if (seed != null && id != null)
        bad('rule 2: $op has both slot_seed_id and slot_id');
      if (required && seed == null && id == null)
        bad('rule 2: $op needs a slot');
      if (seed != null && !x.seeds.contains(seed))
        bad('rule 3: slot_seed_id "$seed" is not in the template');
      if (id != null && !x.slotIds.contains(id))
        bad('rule 3: slot_id "$id" is not in the template');
    }

    switch (op) {
      case 'addBeat':
        need('title');
        slotCheck(required: false);
        final ref = o['ref'];
        if (ref != null) {
          if (refs.containsKey(ref)) bad('rule 2: duplicate ref "$ref"');
          refs[ref as String] =
              o['slot_seed_id'] != null || o['slot_id'] != null;
        }
      case 'editBeat':
        beatTarget();
      case 'splitBeat':
        final id = need('beat_id');
        if (!x.beats.containsKey(id))
          bad('rule 3: splitBeat beat_id is not in the project');
        if (o['parts'] is! List || (o['parts'] as List).length < 2)
          bad('rule 2: splitBeat needs 2 or more parts');
      case 'mergeBeats':
        final ids = o['beat_ids'];
        if (ids is! List || ids.length < 2)
          bad('rule 2: mergeBeats needs 2 or more beat_ids');
        for (final id in ids) {
          if (!x.beats.containsKey(id))
            bad('rule 3: mergeBeats id "$id" is not in the project');
        }
        need('title');
      case 'moveBeat':
        beatTarget();
        slotCheck(required: false);
      case 'placeBeatInSlot':
        if (beatTarget() == true)
          bad('rule 2: placeBeatInSlot targets an already placed beat');
        slotCheck(required: true);
      case 'addCharacter':
        need('name');
        if (o['fields'] != null && o['fields'] is! Map)
          bad('rule 2: addCharacter fields is not an object');
      case 'editCharacter':
        final id = need('project_character_id');
        if (!x.charIds.contains(id))
          bad('rule 3: project_character_id "$id" is not in the project');
        if (o['fields'] is! Map || (o['fields'] as Map).isEmpty)
          bad('rule 2: editCharacter needs fields');
      case 'setSummary':
        need('text');
      case 'addScaffold':
        beatTarget();
        final blocks = o['blocks'], rows = o['rows'];
        if ((blocks == null) == (rows == null))
          bad('rule 2: addScaffold needs exactly one of blocks / rows');
        if (blocks != null) {
          if (blocks is! List || blocks.isEmpty)
            bad('rule 2: addScaffold blocks is empty');
          for (final b in blocks) {
            if (b is! Map ||
                (b['type'] != 'scene_heading' && b['type'] != 'action')) {
              bad(
                'rule 5: scaffold block type "${b is Map ? b['type'] : b}" is not allowed (no dialogue)',
              );
            }
          }
        } else {
          if (rows is! List || rows.isEmpty)
            bad('rule 2: addScaffold rows is empty');
          for (final w in rows) {
            if (w is! Map || w['say'] != '')
              bad('rule 5: scaffold row "say" must be empty');
          }
        }
        if (x.isFilm != null && x.isFilm != (blocks != null)) {
          bad(
            'rule 2: ${x.isFilm! ? 'film projects take blocks' : 'video projects take rows'}',
          );
        }
    }

    if (o['fields'] is Map) {
      o['fields'] = {
        for (final e in (o['fields'] as Map).entries)
          if (e.value != null) e.key: e.value,
      };
    }
    // Rule 5: no quotation-wrapped text the user did not say.
    final prose = [
      if (o['description'] is String) o['description'] as String,
      ...?(o['fields'] as Map?)?.values.whereType<String>(),
    ];
    if (!prose.every(quotesOk))
      bad('rule 5: quoted text that is not in what the user said');
    out.add(o);
  }
  return (ops: out, notes: notes);
}

/// All prose in an op, for the grounding check (9.2).
String _opText(Map<String, dynamic> o) {
  final parts = <String>[];
  void add(Object? v) {
    if (v is String && v.trim().isNotEmpty) {
      parts.add(RegExp(r'[.!?]$').hasMatch(v.trim()) ? v : '$v.');
    }
  }

  for (final k in ['title', 'description', 'text']) {
    add(o[k]);
  }
  for (final p in (o['parts'] as List? ?? const [])) {
    add(p['title']);
    add(p['description']);
  }
  (o['fields'] as Map?)?.values.forEach(add);
  for (final b in (o['blocks'] as List? ?? const [])) {
    add(b['text']);
  }
  for (final r in (o['rows'] as List? ?? const [])) {
    (r['show'] as Map).values.forEach(add);
  }
  return parts.join(' ');
}

/// True when [o] says something not in [input]. Names are checked on their own
/// so a one-word name is not exempted as a sentence start.
bool _ungrounded(Map<String, dynamic> o, String input) {
  final names = [
    if (o['name'] is String) o['name'] as String,
    if (o['title'] is String) o['title'] as String,
  ];
  return wordsCheck(_opText(o), input).isNotEmpty ||
      names.any((n) => wordsCheck('x $n', input).isNotEmpty);
}

const _uuid = Uuid();

/// Adds id/accepted. [existing] maps old op id -> old op (reviseProposal).
List<Map<String, dynamic>> _finish(
  List<Map<String, dynamic>> ops,
  String input, {
  Map<String, Map<String, dynamic>> existing = const {},
}) => [
  for (final o in ops)
    () {
      final old = existing[o['id']];
      return {
        ...o,
        'id': old != null ? old['id'] : _uuid.v4(),
        'accepted':
            (old?['accepted'] as bool? ?? true) && !_ungrounded(o, input),
      };
    }(),
];

({String summary, List<SummarySpan> spans}) _parseSummary(
  Map<String, dynamic> j,
  String raw,
) {
  final sents = <String>[];
  final quotes = <List<String>>[];
  try {
    for (final s in j['summary_sentences'] as List) {
      sents.add(s['text'] as String);
      quotes.add([for (final q in s['source_quotes'] as List) q as String]);
    }
  } catch (_) {
    throw const FormatException('rule 8: summary_sentences is malformed');
  }
  final summary = sents.join(' ');
  // Sentence count mismatch: keep summary, drop spans (as organize does).
  final spans = splitSentences(summary).length == sents.length
      ? computeSpans(raw, quotes)
      : const <SummarySpan>[];
  return (summary: summary, spans: spans);
}

/// Validation failure retries once with a note (9.3), then AiMalformedResponse.
Future<T> _retry<T>(
  Future<Map<String, dynamic>> Function(String note) call,
  T Function(Map<String, dynamic>) parse,
) async {
  var note = '';
  for (var attempt = 0; ; attempt++) {
    final j = await call(note);
    try {
      return parse(j);
    } on FormatException catch (e) {
      if (attempt == 1) throw AiMalformedResponse(e.message);
      note = '\n\nYour last output broke ${e.message}. Fix it.';
    }
  }
}

bool? _film(Map<String, dynamic> context) {
  final t = (context['project'] as Map?)?['type'];
  return t == null ? null : (t == 'short_film' || t == 'long_film');
}

/// AI_CONTRACT 4.6: input inside a project -> proposal. Per-op permission
/// gating; the proposal summary itself is ungated.
Future<ProposalDraft> buildProposal(
  AiClient ai, {
  required String rawTranscript,
  required Map<String, dynamic> context,
  required Map<String, dynamic> permissions,
}) {
  final ops = allowedOps(permissions);
  final x = _Ctx(permissions, ops, context, _film(context));
  final input = '$rawTranscript ${jsonEncode(context)}';
  return _retry(
    (note) => ai.generateJson(
      prompt:
          buildProposalPrompt(
            rawTranscript,
            context,
            permissions,
            ops,
            aiAllowed(permissions, AiPermission.grammarCleanup),
          ) +
          note,
      schema: _proposalSchema(ops, slots: x.hasTemplate),
    ),
    (j) {
      final s = _parseSummary(j, rawTranscript);
      final v = _validateChanges(j['changes'] as List? ?? const [], x, input);
      return ProposalDraft(
        summary: s.summary,
        spans: s.spans,
        changes: _finish(v.ops, input),
        notes: v.notes,
      );
    },
  );
}

/// AI_CONTRACT 4.7: [proposal] is `{raw_transcript, summary_sentences:[text],
/// changes:[{id, op, accepted, ...}]}`. Output is the full replacement list;
/// kept ids keep their `accepted` flag.
Future<ProposalDraft> reviseProposal(
  AiClient ai, {
  required Map<String, dynamic> proposal,
  required String instruction,
  required Map<String, dynamic> context,
  required Map<String, dynamic> permissions,
}) {
  final raw = proposal['raw_transcript'] as String;
  final existing = {
    for (final c in (proposal['changes'] as List).cast<Map<String, dynamic>>())
      c['id'] as String: c,
  };
  // The model sees ops without the app's accepted flag.
  final shown = {
    ...proposal,
    'changes': [
      for (final c in existing.values)
        {
          for (final e in c.entries)
            if (e.key != 'accepted') e.key: e.value,
        },
    ],
  };
  final ops = allowedOps(permissions);
  final x = _Ctx(permissions, ops, context, _film(context));
  final input = '$raw $instruction ${jsonEncode(context)}';
  return _retry(
    (note) => ai.generateJson(
      prompt:
          reviseProposalPrompt(
            shown,
            instruction,
            context,
            permissions,
            ops,
            aiAllowed(permissions, AiPermission.grammarCleanup),
          ) +
          note,
      schema: _proposalSchema(ops, slots: x.hasTemplate, withId: true),
    ),
    (j) {
      final s = _parseSummary(j, raw);
      final v = _validateChanges(j['changes'] as List? ?? const [], x, input);
      return ProposalDraft(
        summary: s.summary,
        spans: s.spans,
        changes: _finish(v.ops, input, existing: existing),
        notes: v.notes,
      );
    },
  );
}

/// AI_CONTRACT 4.5: Void item -> first project content (no proposal; the user
/// already approved creating the project). [template] is `{id, name, slots}`
/// or null.
Future<ProjectDraft> generateProject(
  AiClient ai, {
  required String summary,
  required String rawTranscript,
  required String projectType,
  required Map<String, dynamic>? template,
  required Map<String, dynamic> permissions,
}) {
  final ops = allowedOps(permissions, forGenerate: true);
  final ctx = {
    'project': {'type': projectType},
    'template': template,
  };
  final x = _Ctx(permissions, ops, ctx, _film(ctx));
  final input = '$summary $rawTranscript ${jsonEncode(template)}';
  final schema = {
    ..._obj(
      {
        'title': _s(nullable: true),
        if (ops.isNotEmpty) 'changes': changesSchema(ops, slots: x.hasTemplate),
      },
      [if (ops.isNotEmpty) 'changes'],
    ),
    'propertyOrdering': ['title', if (ops.isNotEmpty) 'changes'],
  };
  return _retry(
    (note) => ai.generateJson(
      prompt:
          generateProjectPrompt(
            summary,
            rawTranscript,
            projectType,
            template,
            permissions,
            ops,
            aiAllowed(permissions, AiPermission.grammarCleanup),
          ) +
          note,
      schema: schema,
    ),
    (j) {
      final t = j['title'];
      final v = _validateChanges(j['changes'] as List? ?? const [], x, input);
      return ProjectDraft(
        title: t is String && t.trim().isNotEmpty ? t.trim() : null,
        changes: _finish(v.ops, input),
      );
    },
  );
}

/// AI_CONTRACT 4.4. [projects]: `[{id, title, summary_first_200_chars,
/// character_names}]`. Returns a match only for a listed id at confidence
/// >= 0.6; the user still confirms. Ungated.
Future<ProjectMention?> detectProjectMention(
  AiClient ai, {
  required String rawTranscript,
  required List<Map<String, dynamic>> projects,
}) async {
  if (projects.isEmpty) return null;
  final j = await ai.generateJson(
    prompt: detectMentionPrompt(rawTranscript, projects),
    schema: {
      ..._obj(
        {
          'project_id': _s(nullable: true),
          'confidence': {'type': 'NUMBER'},
          'matched_phrase': _s(nullable: true),
        },
        ['project_id', 'confidence', 'matched_phrase'],
      ),
      'propertyOrdering': ['project_id', 'confidence', 'matched_phrase'],
    },
  );
  final id = j['project_id'];
  final conf = j['confidence'];
  if (id is! String || conf is! num || conf < 0.6) return null;
  if (!projects.any((p) => p['id'] == id)) return null;
  return ProjectMention(id, conf.toDouble(), j['matched_phrase'] as String?);
}
