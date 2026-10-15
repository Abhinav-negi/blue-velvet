import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:drift/drift.dart';

import '../data/db.dart';
import 'errors.dart';

/// Runs one queued job; throws on failure (an [AiException] where possible).
typedef JobRunner = Future<void> Function(AiJob job);

/// Online/offline as a stream of booleans (true = online).
Stream<bool> connectivityStream([Connectivity? c]) => (c ?? Connectivity())
    .onConnectivityChanged
    .map((r) => r.any((e) => e != ConnectivityResult.none));

/// Network, 429 and 5xx failures are worth retrying; everything else is final.
bool isRetryable(Object e) =>
    e is AiNetworkError ||
    (e is AiHttpError && (e.status == 429 || e.status >= 500));

/// Drains `ai_queue` oldest first whenever the phone is online.
/// A failing job keeps its row (attempts, error, next_retry_at) and never
/// blocks the jobs behind it.
class AiQueueRunner {
  AiQueueRunner({
    required this.db,
    required this.online,
    required this.runJob,
    int Function()? now,
    this.maxAttempts = 5,
    this.baseBackoff = const Duration(seconds: 30),
  }) : _now = now ?? (() => DateTime.now().millisecondsSinceEpoch);

  final AppDatabase db;
  final Stream<bool> online;
  final JobRunner runJob;
  final int maxAttempts;
  final Duration baseBackoff;
  final int Function() _now;

  StreamSubscription<bool>? _sub;
  Timer? _timer;
  bool _isOnline = false;
  Future<void>? _draining;
  bool _again = false;

  /// Starts listening. Rows left `processing` by a killed app go back to waiting.
  Future<void> start() async {
    await (db.update(db.aiQueue)
          ..where((t) => t.status.equalsValue(QueueStatus.processing)))
        .write(AiQueueCompanion(status: Value(QueueStatus.needsAi)));
    _sub = online.listen((v) {
      _isOnline = v;
      if (v) drain();
    });
  }

  Future<void> stop() async {
    _timer?.cancel();
    await _sub?.cancel();
    await _draining;
  }

  /// Runs every due job. A call during a pass triggers one more pass, so a
  /// job enqueued mid-drain is not left waiting for the next timer.
  Future<void> drain() {
    if (_draining != null) {
      _again = true;
      return _draining!;
    }
    return _draining = _drainLoop().whenComplete(() => _draining = null);
  }

  Future<void> _drainLoop() async {
    do {
      _again = false;
      await _drain();
    } while (_again);
  }

  Future<void> _drain() async {
    if (!_isOnline) return;
    for (final job in await db.aiQueueDao.due(_now())) {
      if (!_isOnline) break;
      await _set(job.id, status: QueueStatus.processing);
      try {
        await runJob(job);
        await _set(job.id, status: QueueStatus.done, error: null);
      } catch (e) {
        final attempts = job.attempts + 1;
        final giveUp = !isRetryable(e) || attempts >= maxAttempts;
        await _set(job.id,
            status: giveUp ? QueueStatus.failed : QueueStatus.needsAi,
            attempts: attempts,
            error: e.toString(),
            nextRetryAt:
                giveUp ? null : _now() + (baseBackoff * (1 << (attempts - 1))).inMilliseconds);
      }
    }
    await _scheduleNext();
  }

  Future<void> _set(String id,
      {required QueueStatus status,
      int? attempts,
      Object? error = _keep,
      int? nextRetryAt}) {
    return (db.update(db.aiQueue)..where((t) => t.id.equals(id))).write(
        AiQueueCompanion(
      status: Value(status),
      attempts: attempts == null ? const Value.absent() : Value(attempts),
      error: identical(error, _keep)
          ? const Value.absent()
          : Value(error as String?),
      nextRetryAt: Value(nextRetryAt),
      updatedAt: Value(_now()),
    ));
  }

  static const _keep = Object();

  /// Wake up when the earliest backed-off job becomes due.
  Future<void> _scheduleNext() async {
    _timer?.cancel();
    final next = await (db.selectOnly(db.aiQueue)
          ..addColumns([db.aiQueue.nextRetryAt.min()])
          ..where(db.aiQueue.status.equalsValue(QueueStatus.needsAi) &
              db.aiQueue.nextRetryAt.isNotNull()))
        .map((r) => r.read(db.aiQueue.nextRetryAt.min()))
        .getSingleOrNull();
    if (next == null) return;
    final wait = next - _now();
    _timer = Timer(Duration(milliseconds: wait < 0 ? 0 : wait), drain);
  }
}
