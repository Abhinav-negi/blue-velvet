import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Secure-storage entry holding the user's Gemini key.
const geminiKeyStorageKey = 'gemini_api_key';

/// The app's `AiClient.readStoredKey`. Kept out of ai_client.dart because this
/// plugin pulls in Flutter, which `dart run` scripts can't compile.
Future<String?> readSecureGeminiKey() =>
    const FlutterSecureStorage().read(key: geminiKeyStorageKey);

/// Saves (or, with null/empty, deletes) the user's Gemini key.
Future<void> writeSecureGeminiKey(String? key) => key == null || key.isEmpty
    ? const FlutterSecureStorage().delete(key: geminiKeyStorageKey)
    : const FlutterSecureStorage().write(key: geminiKeyStorageKey, value: key);
