// ignore_for_file: avoid_print
// Live smoke for AI-07: dart run tool/ai_smoke_fetch.dart
// Reads GEMINI_API_KEY from the gitignored main-repo .env.json. Never prints it.
import 'dart:convert';
import 'dart:io';

import 'package:lynch/core/ai/ai_client.dart';
import 'package:lynch/core/ai/fetch.dart';

Future<void> main() async {
  final env = jsonDecode(
          File('/home/abhinav/Projects/blue velvet/.env.json').readAsStringSync())
      as Map<String, dynamic>;
  final key = env['GEMINI_API_KEY'] as String;
  final ai = AiClient(readStoredKey: () async => key);
  final out = await FetchConvert(ai).run('Kishōtenketsu',
      kind: 'template', permissions: {'internet_fetch': true});
  switch (out) {
    case TemplateDraft():
      print('TEMPLATE ${out.name} types=${out.projectTypes}');
      for (final s in out.slots) {
        print('  slot ${s.name} (${s.runtimeProportion}): ${s.description}');
      }
      print('  sources: ${out.sources}');
    case ShotDraft():
      print('SHOT ${out.name}');
    case CannotConvert():
      print('CANNOT CONVERT: ${out.reason}');
  }
}
