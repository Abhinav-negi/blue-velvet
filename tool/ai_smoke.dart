// Live smoke: dart run tool/ai_smoke.dart organize <transcript-file>
// Key comes from the gitignored .env.json (GEMINI_API_KEY). Path: env
// AI_SMOKE_ENV or the main repo's file. The key is never printed.
import 'dart:convert';
import 'dart:io';

import 'package:lynch/core/ai/ai_client.dart';
import 'package:lynch/core/ai/organize.dart';
import 'package:lynch/core/ai/words_check.dart';

Future<void> main(List<String> args) async {
  if (args.length != 2 || args[0] != 'organize') {
    stderr.writeln('usage: dart run tool/ai_smoke.dart organize <file>');
    exit(64);
  }
  final envPath = Platform.environment['AI_SMOKE_ENV'] ??
      '/home/abhinav/Projects/blue velvet/.env.json';
  final key =
      (jsonDecode(File(envPath).readAsStringSync()) as Map)['GEMINI_API_KEY']
          as String;
  final raw = File(args[1]).readAsStringSync().trim();

  final draft = await organize(AiClient(readStoredKey: () async => key), raw);
  stdout.writeln(draftToJson(draft));
  for (final s in draft.spans) {
    stdout.writeln('span ${s.sentenceIndex}: "${raw.substring(s.start, s.end)}"');
  }
  final bad = wordsCheck(draft.summary, raw);
  stdout.writeln('wordsCheck: ${bad.isEmpty ? 'clean' : 'ungrounded $bad'}');
}
