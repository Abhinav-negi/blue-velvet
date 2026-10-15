import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'errors.dart';
import 'permissions.dart';

/// The one model ID used by the whole app (SPK-03). Aliases move; pin it here.
const geminiModel = 'gemini-3.5-flash';

const _endpoint = 'https://generativelanguage.googleapis.com/v1beta/models';

/// Single gateway to Gemini: permission gate, key lookup, structured JSON
/// output, retry on 429/503.
///
/// Pure Dart (no Flutter imports) so `dart run tool/...` scripts can use it.
/// The app passes `readSecureGeminiKey` from key_store.dart as [readStoredKey].
class AiClient {
  AiClient({
    http.Client? client,
    required this._readStoredKey,
    this._dartDefineKey = const String.fromEnvironment('GEMINI_API_KEY'),
    this.retryStep = const Duration(seconds: 5),
    this.maxTries = 4,
    // Calls take 1-3 min (thinking tokens), so allow well beyond that.
    this.timeout = const Duration(minutes: 5),
  }) : _client = client ?? http.Client();

  final http.Client _client;
  final Future<String?> Function() _readStoredKey;
  final String _dartDefineKey;
  final Duration retryStep;
  final int maxTries;
  final Duration timeout;

  /// Secure storage first, then --dart-define GEMINI_API_KEY.
  Future<String> _key() async {
    String? stored;
    try {
      stored = await _readStoredKey();
    } catch (_) {
      stored = null; // storage unavailable: fall through to dart-define
    }
    if (stored != null && stored.isNotEmpty) return stored;
    if (_dartDefineKey.isNotEmpty) return _dartDefineKey;
    throw const AiNoKey();
  }

  /// Sends [prompt] (plus any [extraParts], e.g. inline audio) and returns the
  /// decoded JSON object the model produced under [schema].
  ///
  /// If [gate] is given, [permissions] (a project's `ai_permissions`) must
  /// allow it, otherwise [AiPermissionDenied] is thrown before any I/O.
  Future<Map<String, dynamic>> generateJson({
    required String prompt,
    required Map<String, dynamic> schema,
    List<Map<String, dynamic>> extraParts = const [],
    AiPermission? gate,
    Map<String, dynamic> permissions = const {},
  }) async {
    if (gate != null && !aiAllowed(permissions, gate)) {
      throw AiPermissionDenied(gate.key);
    }
    final key = await _key();
    final body = jsonEncode({
      'contents': [
        {
          'parts': [
            {'text': prompt},
            ...extraParts,
          ],
        },
      ],
      'generationConfig': {
        'responseMimeType': 'application/json',
        'responseSchema': schema,
      },
    });

    final res = await _send(key, body);
    return _parse(res.body);
  }

  Future<http.Response> _send(String key, String body) async {
    final uri = Uri.parse('$_endpoint/$geminiModel:generateContent');
    for (var attempt = 1;; attempt++) {
      http.Response res;
      try {
        res = await _client.post(uri, headers: {
          'content-type': 'application/json',
          'x-goog-api-key': key, // header only, never the URL
        }, body: body).timeout(timeout);
      } on TimeoutException {
        throw const AiNetworkError('Request timed out');
      } on Exception {
        // Do not echo the exception: it may carry the request URI/headers.
        throw const AiNetworkError('Network request failed');
      }
      if (res.statusCode == 200) return res;
      final retryable = res.statusCode == 429 || res.statusCode == 503;
      if (retryable && attempt < maxTries) {
        await Future<void>.delayed(retryStep * attempt);
        continue;
      }
      throw AiHttpError(res.statusCode, _httpMessage(res.statusCode));
    }
  }

  String _httpMessage(int s) => switch (s) {
        404 => 'Model not found or no longer available ($geminiModel)',
        429 => 'Rate limit or quota exceeded',
        503 => 'Gemini is overloaded, try again',
        400 || 401 || 403 => 'Request rejected (check the API key)',
        _ => 'Gemini returned HTTP $s',
      };

  Map<String, dynamic> _parse(String raw) {
    try {
      final root = jsonDecode(raw) as Map<String, dynamic>;
      final parts = (root['candidates'] as List).first['content']['parts']
          as List;
      final text = parts.map((p) => p['text'] ?? '').join();
      final out = jsonDecode(text);
      if (out is! Map<String, dynamic>) throw const FormatException();
      return out;
    } catch (_) {
      throw const AiMalformedResponse('Model reply was not the expected JSON');
    }
  }
}
