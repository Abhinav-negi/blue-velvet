// SPK-03 smoke test. Run from spikes/gemini: dart run bin/smoke.dart [model]
// Key is read from ../../.env.json and only sent in the x-goog-api-key header.
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

const defaultModel = 'gemini-3.8-flash';
const base = 'https://generativelanguage.googleapis.com/v1beta/models';

Future<Map<String, dynamic>> call(String key, String model, Map body) async {
  for (var i = 1;; i++) {
    final r = await http.post(Uri.parse('$base/$model:generateContent'),
        headers: {'x-goog-api-key': key, 'Content-Type': 'application/json'},
        body: jsonEncode(body));
    final j = jsonDecode(r.body) as Map<String, dynamic>;
    if (r.statusCode == 200) return j;
    // Retry transient overload (seen on 3.x flash models) a few times.
    if ((r.statusCode == 503 || r.statusCode == 429) && i < 5) {
      print('HTTP ${r.statusCode}, retry $i');
      await Future.delayed(Duration(seconds: 5 * i));
      continue;
    }
    throw 'HTTP ${r.statusCode}: ${jsonEncode(j['error'])}';
  }
}

String text(Map<String, dynamic> j) =>
    (j['candidates'][0]['content']['parts'] as List)
        .map((p) => p['text'] ?? '')
        .join();

Future<void> main(List<String> args) async {
  final model = args.isNotEmpty ? args[0] : defaultModel;
  final key = (jsonDecode(File('../../.env.json').readAsStringSync())
      as Map)['GEMINI_API_KEY'] as String;
  final audio = base64Encode(File('samples/idea.m4a').readAsBytesSync());
  print('model: $model');

  // 1. Transcript, plain.
  final t = await call(key, model, {
    'contents': [
      {'parts': [
        {'text': 'Transcribe this audio verbatim. Output only the transcript.'},
        {'inline_data': {'mime_type': 'audio/mp4', 'data': audio}},
      ]}
    ]
  });
  print('\n--- transcript ---\n${text(t)}');

  // 2. Transcript + structured JSON via responseSchema.
  final s = await call(key, model, {
    'contents': [
      {'parts': [
        {'text': 'Transcribe this audio verbatim and extract the story idea. In summary, start and end are 0-based character offsets into your own transcript string marking the span each summary sentence came from.'},
        {'inline_data': {'mime_type': 'audio/mp4', 'data': audio}},
      ]}
    ],
    'generationConfig': {
      'responseMimeType': 'application/json',
      'responseSchema': {
        'type': 'OBJECT',
        'properties': {
          'transcript': {'type': 'STRING'},
          'title': {'type': 'STRING'},
          'characters': {'type': 'ARRAY', 'items': {'type': 'STRING'}},
          'setting': {'type': 'STRING'},
          'summary': {
            'type': 'ARRAY',
            'items': {
              'type': 'OBJECT',
              'properties': {
                'sentence': {'type': 'STRING'},
                'start': {'type': 'INTEGER'},
                'end': {'type': 'INTEGER'},
              },
              'required': ['sentence', 'start', 'end'],
            },
          },
        },
        'required': ['transcript', 'title', 'characters', 'setting', 'summary'],
      },
    },
  });
  final obj = jsonDecode(text(s)) as Map<String, dynamic>;
  print('\n--- structured JSON ---\n${const JsonEncoder.withIndent('  ').convert(obj)}');
  final tr = obj['transcript'] as String;
  for (final x in obj['summary'] as List) {
    final ok = x['start'] >= 0 && x['end'] <= tr.length && x['start'] < x['end'];
    print('offset span valid: $ok  "${ok ? tr.substring(x['start'], x['end']) : '?'}"');
  }
  print('usage: ${jsonEncode(s['usageMetadata'])}');

  // 3. Search grounding.
  try {
    final g = await call(key, model, {
      'contents': [
        {'parts': [{'text': 'What is the Vizhinjam lighthouse in Kerala? One sentence.'}]}
      ],
      'tools': [{'google_search': {}}],
    });
    print('\n--- grounded ---\n${text(g)}');
    print('groundingMetadata: ${jsonEncode(g['candidates'][0]['groundingMetadata'])}');
  } catch (e) {
    print('\n--- grounded ---\nERROR: $e');
  }
}
