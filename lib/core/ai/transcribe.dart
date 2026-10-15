import 'dart:convert';
import 'dart:typed_data';

import 'ai_client.dart';
import 'errors.dart';

/// SPK-03: 20 MB total inline request, base64 adds 33%, so 14 MB of raw audio
/// per call leaves room for the prompt.
const maxInlineAudioBytes = 14 * 1000 * 1000;

const transcribeInstruction =
    'Transcribe exactly what is said, in English (Indian-accented English '
    'expected; proper nouns as spoken). Do NOT clean up, summarise, translate '
    'or correct. Keep fillers and repeats. Hindi words: write them as spoken '
    'in Latin letters. If a stretch is unintelligible write [inaudible]. '
    'Return only the transcript in the "transcript" field. LOCALE: en-IN';

const _schema = {
  'type': 'object',
  'properties': {
    'transcript': {'type': 'string'},
  },
  'required': ['transcript'],
};

/// Voice to raw text (AI_CONTRACT 4.1). [mimeType] is `audio/mp4` (m4a) or
/// `audio/wav`. Audio over [maxChunkBytes] is sent as several calls and the
/// transcripts joined in order.
///
/// ponytail: AiClient only offers JSON output, so the text comes back in a
/// one-field schema instead of plain text. Chunks are raw byte slices: fine
/// for the size path, but m4a (moov atom) and WAV (header) slices after the
/// first are not standalone files; split on a container boundary (or use the
/// Files API) if recordings past ~14 MB must work.
///
/// Throws [AiMalformedResponse] with "nothing heard" if the result is empty.
Future<String> transcribe(
  AiClient ai,
  Uint8List audio, {
  String mimeType = 'audio/mp4',
  int maxChunkBytes = maxInlineAudioBytes,
}) async {
  final parts = <String>[];
  for (var i = 0; i < audio.length; i += maxChunkBytes) {
    final end = i + maxChunkBytes < audio.length
        ? i + maxChunkBytes
        : audio.length;
    final out = await ai.generateJson(
      prompt: transcribeInstruction,
      schema: _schema,
      extraParts: [
        {
          'inlineData': {
            'mimeType': mimeType,
            'data': base64Encode(Uint8List.sublistView(audio, i, end)),
          },
        },
      ],
    );
    final t = out['transcript'];
    if (t is! String) {
      throw const AiMalformedResponse('Model reply had no transcript');
    }
    parts.add(t.trim());
  }
  final text = parts.where((p) => p.isNotEmpty).join(' ');
  if (text.isEmpty) throw const AiMalformedResponse('Nothing heard');
  return text;
}
