import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'ai_client.dart';
import 'key_store.dart';

/// The one app-wide [AiClient] (shared so the "flash quota spent" memory is too).
final aiClientProvider = Provider<AiClient>(
  (ref) => AiClient(readStoredKey: readSecureGeminiKey),
);
