import 'dart:async';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lynch/core/ai/errors.dart';
import 'package:lynch/core/ai/queue.dart';
import 'package:lynch/core/data/db.dart';

void main() {
  late AppDatabase db;
  late StreamController<bool> net;
  late List<String> ran;
  var clock = 1000000;
  Object? Function(AiJob)? failWith;
  Future<void> Function(AiJob)? during;
  late AiQueueRunner q;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    net = StreamController<bool>();
    ran = [];
    clock = 1000000;
    failWith = null;
    during = null;
    q = AiQueueRunner(
      db: db,
      online: net.stream,
      now: () => clock,
      runJob: (j) async {
        final err = failWith?.call(j);
        if (err != null) throw err;
        await during?.call(j);
        ran.add(j.id);
      },
    );
    await q.start();
  });
  tearDown(() async {
    await q.stop();
    await net.close();
    await db.close();
  });

  Future<void> add(String id, int created) =>
      db.aiQueueDao.enqueue(AiQueueCompanion.insert(
        id: id,
        kind: QueueKind.cleanCapture,
        status: QueueStatus.needsAi,
        payload: {'scope': {'type': 'void'}},
        createdAt: created,
        updatedAt: created,
      ));

  Future<AiJob> row(String id) =>
      (db.select(db.aiQueue)..where((t) => t.id.equals(id))).getSingle();

  Future<void> goOnline() async {
    net.add(true);
    await pumpEventQueue();
    await q.drain();
  }

  test('item queued offline runs when online flips', () async {
    await add('a', 1);
    net.add(false);
    await pumpEventQueue();
    await q.drain();
    expect(ran, isEmpty);
    await goOnline();
    expect(ran, ['a']);
    expect((await row('a')).status, QueueStatus.done);
  });

  test('failing item keeps its row with error count and retry time', () async {
    await add('a', 1);
    await add('b', 2);
    failWith = (j) => j.id == 'a' ? const AiNetworkError('boom') : null;
    await goOnline();
    expect(ran, ['b']);
    final a = await row('a');
    expect(a.status, QueueStatus.needsAi);
    expect(a.attempts, 1);
    expect(a.error, contains('boom'));
    expect(a.nextRetryAt, clock + 30000);
    expect((await row('b')).status, QueueStatus.done);
  });

  test('non-retryable error marks the row failed', () async {
    await add('a', 1);
    failWith = (_) => const AiMalformedResponse('bad');
    await goOnline();
    expect((await row('a')).status, QueueStatus.failed);
  });

  test('items run oldest first', () async {
    await add('late', 30);
    await add('early', 10);
    await add('mid', 20);
    await goOnline();
    expect(ran, ['early', 'mid', 'late']);
  });

  test('item enqueued during a pass runs before drain completes', () async {
    await add('a', 1);
    during = (j) async {
      if (j.id != 'a') return;
      await add('b', 2);
      unawaited(q.drain()); // joins the running pass; must not be dropped
    };
    net.add(true); // only the listener drains; no extra drain() from the test
    await pumpEventQueue();
    expect(ran, ['a', 'b']);
  });
}
