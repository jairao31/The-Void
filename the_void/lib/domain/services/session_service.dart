import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart';
import '../../data/repositories/session_repository.dart';
import '../../data/database/app_database.dart';
import 'score_service.dart';

class SessionService {
  final SessionRepository _sessionRepo;
  final ScoreService _scoreService;

  SessionService(this._sessionRepo, this._scoreService);

  // Creates an in-progress session record — ended_at left null
  Future<int> startSession({
    required int targetDurationSeconds,
    required bool quietModeEnabled,
  }) async {
    return _sessionRepo.insertSession(SessionsCompanion.insert(
      uuid: const Uuid().v4(),
      startedAt: DateTime.now(),
      targetDurationSeconds: targetDurationSeconds,
      quietModeEnabled: Value(quietModeEnabled),
    ));
  }

  Future<int> completeSession({
    required int sessionId,
    required int actualDurationSeconds,
    required int targetDurationSeconds,
    required bool quietModeEnabled,
  }) async {
    final points = await _scoreService.calculatePointsEarned(
      actualDurationSeconds: actualDurationSeconds,
      targetDurationSeconds: targetDurationSeconds,
      wasCompleted: true,
      quietModeEnabled: quietModeEnabled,
    );

    await _sessionRepo.updateSession(
      sessionId,
      SessionsCompanion(
        endedAt: Value(DateTime.now()),
        actualDurationSeconds: Value(actualDurationSeconds),
        wasCompleted: const Value(true),
        wasInterrupted: const Value(false),
        pointsEarned: Value(points),
      ),
    );

    await _scoreService.addPoints(points, actualDurationSeconds);
    return points;
  }

  Future<int> interruptSession({
    required int sessionId,
    required int actualDurationSeconds,
    required int targetDurationSeconds,
    required bool quietModeEnabled,
    String? reason,
  }) async {
    // Guard: < 10 seconds = abandoned, don't write
    if (actualDurationSeconds < 10) {
      await _sessionRepo.updateSession(
        sessionId,
        SessionsCompanion(
          endedAt: Value(DateTime.now()),
          actualDurationSeconds: const Value(0),
          wasCompleted: const Value(false),
          wasInterrupted: const Value(true),
          pointsEarned: const Value(0),
        ),
      );
      return 0;
    }

    final points = await _scoreService.calculatePointsEarned(
      actualDurationSeconds: actualDurationSeconds,
      targetDurationSeconds: targetDurationSeconds,
      wasCompleted: false,
      quietModeEnabled: quietModeEnabled,
    );

    await _sessionRepo.updateSession(
      sessionId,
      SessionsCompanion(
        endedAt: Value(DateTime.now()),
        actualDurationSeconds: Value(actualDurationSeconds),
        wasCompleted: const Value(false),
        wasInterrupted: const Value(true),
        interruptReason: Value(reason),
        pointsEarned: Value(points),
      ),
    );

    await _scoreService.addPoints(points, actualDurationSeconds);
    return points;
  }

  // Called on app launch — detects sessions killed mid-flight
  Future<Session?> getIncompleteSession() =>
      _sessionRepo.getActiveSession();
}

final sessionServiceProvider = Provider<SessionService>((ref) {
  return SessionService(
    ref.read(sessionRepositoryProvider),
    ref.read(scoreServiceProvider),
  );
});
