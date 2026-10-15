// Live smoke: dart run tool/ai_smoke.dart organize <transcript-file>
//             dart run tool/ai_smoke.dart transcribe <audio-file>
//             dart run tool/ai_smoke.dart proposals <transcript-file>
// Key comes from the gitignored .env.json (GEMINI_API_KEY). Path: env
// AI_SMOKE_ENV or the main repo's file. The key is never printed.
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:lynch/core/ai/ai_client.dart';
import 'package:lynch/core/ai/organize.dart';
import 'package:lynch/core/ai/proposals.dart';
import 'package:lynch/core/ai/transcribe.dart';
import 'package:lynch/core/ai/words_check.dart';

Future<void> main(List<String> args) async {
  if (args.length != 2 ||
      !const ['organize', 'transcribe', 'proposals'].contains(args[0])) {
    stderr.writeln(
      'usage: dart run tool/ai_smoke.dart organize|transcribe|proposals <file>',
    );
    exit(64);
  }
  final envPath =
      Platform.environment['AI_SMOKE_ENV'] ??
      '/home/abhinav/Projects/blue velvet/.env.json';
  final key =
      (jsonDecode(File(envPath).readAsStringSync()) as Map)['GEMINI_API_KEY']
          as String;
  if (args[0] == 'transcribe') {
    final f = File(args[1]);
    final mime = f.path.toLowerCase().endsWith('.wav')
        ? 'audio/wav'
        : 'audio/mp4';
    final ai = AiClient(readStoredKey: () async => key);
    stdout.writeln(
      await transcribe(
        ai,
        Uint8List.fromList(f.readAsBytesSync()),
        mimeType: mime,
      ),
    );
    return;
  }
  final raw = File(args[1]).readAsStringSync().trim();
  if (args[0] == 'proposals') {
    const perms = {
      'auto_summary': true,
      'character_extraction': true,
      'beat_generation': true,
      'auto_placement': true,
      'screenplay_scaffold': true,
    };
    const slots = [
      {'slot_id': 's1', 'seed_id': 'five-point/opening', 'name': 'Opening'},
      {
        'slot_id': 's2',
        'seed_id': 'five-point/inciting-moment',
        'name': 'Inciting moment',
      },
    ];
    final ai = AiClient(readStoredKey: () async => key);
    const enc = JsonEncoder.withIndent('  ');
    final g = await generateProject(
      ai,
      summary: raw,
      rawTranscript: raw,
      projectType: 'short_film',
      template: {'id': 't', 'name': 'Five-point', 'slots': slots},
      permissions: perms,
    );
    stdout.writeln(
      'generateProject title=${g.title}\n${enc.convert(g.changes)}',
    );
    stdout.writeln(
      'wordsCheck: ${[for (final o in g.changes) ...wordsCheck(jsonEncode(o), raw)]}',
    );
    final b = await buildProposal(
      ai,
      rawTranscript: raw,
      context: {
        'project': {'title': 'The Key', 'type': 'short_film', 'summary': ''},
        'template': {'id': 't', 'name': 'Five-point', 'slots': slots},
        'beats': <Object>[],
        'characters': <Object>[],
      },
      permissions: perms,
    );
    stdout.writeln(
      'buildProposal summary=${b.summary}\n${enc.convert(b.changes)}',
    );
    stdout.writeln(
      'spans: ${[for (final s in b.spans) raw.substring(s.start, s.end)]}',
    );
    stdout.writeln(
      'wordsCheck: summary ${wordsCheck(b.summary, raw)}, ungrounded ops '
      '${[for (final o in b.changes)
        if (o['accepted'] == false) o['op']]}',
    );
    return;
  }

  final draft = await organize(AiClient(readStoredKey: () async => key), raw);
  stdout.writeln(draftToJson(draft));
  for (final s in draft.spans) {
    stdout.writeln(
      'span ${s.sentenceIndex}: "${raw.substring(s.start, s.end)}"',
    );
  }
  final bad = wordsCheck(draft.summary, raw);
  stdout.writeln('wordsCheck: ${bad.isEmpty ? 'clean' : 'ungrounded $bad'}');
}
