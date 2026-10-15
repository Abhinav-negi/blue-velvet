/// Typed failures of the AI gateway. Messages never contain the API key.
sealed class AiException implements Exception {
  const AiException(this.message);
  final String message;
  @override
  String toString() => '$runtimeType: $message';
}

/// The project's switch for this operation is off; no network call was made.
class AiPermissionDenied extends AiException {
  const AiPermissionDenied(String permission)
      : super('AI permission "$permission" is off');
}

/// No key in secure storage and none passed via --dart-define.
class AiNoKey extends AiException {
  const AiNoKey() : super('No Gemini API key configured');
}

/// Non-success HTTP status (after retries for 429/503).
class AiHttpError extends AiException {
  const AiHttpError(this.status, String message) : super(message);
  final int status;
}

/// Timeout or socket failure.
class AiNetworkError extends AiException {
  const AiNetworkError(super.message);
}

/// Response was not the JSON we asked for.
class AiMalformedResponse extends AiException {
  const AiMalformedResponse(super.message);
}
