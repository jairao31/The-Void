import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/score_repository.dart';

class ScoreService {
  final ScoreRepository _repo;
  ScoreService(this._repo);

  // Per spec: 2 pts/min * completion multiplier + quiet bonus
  int calculateRawPoints({
    required int actualDurationSeconds,
    required int targetDurationSeconds,
    required bool wasCompleted,
    required bool quietModeEnabled,
  }) {
    if (actualDurationSeconds < 10) return 0;
    final basePoints = (actualDurationSeconds / 60.0) * 2.0;
    final multiplier = wasCompleted ? 1.5 : 1.0;
    final quietBonus = quietModeEnabled ? 1.0 : 0.0;
    final earned = (basePoints * multiplier) + quietBonus;
    return earned.round().clamp(0, 20);
  }

  // Apply daily cap: max 20 pts/day total
  Future<int> calculatePointsEarned({
    required int actualDurationSeconds,
    required int targetDurationSeconds,
    required bool wasCompleted,
    required bool quietModeEnabled,
  }) async {
    final raw = calculateRawPoints(
      actualDurationSeconds: actualDurationSeconds,
      targetDurationSeconds: targetDurationSeconds,
      wasCompleted: wasCompleted,
      quietModeEnabled: quietModeEnabled,
    );
    final todayPoints = await _repo.getTodayPointsEarned();
    if (todayPoints >= 20) return 0;
    return min(raw, 20 - todayPoints);
  }

  Future<int> getCurrentScore() => _repo.getCurrentScore();

  Future<void> addPoints(int points, int sessionSeconds) =>
      _repo.upsertTodayScore(
        pointsToAdd: points,
        sessionSeconds: sessionSeconds,
      );

  String scoreLabel(int score) {
    if (score <= 10) return 'Just starting';
    if (score <= 25) return 'Finding stillness';
    if (score <= 50) return 'Getting quieter';
    if (score <= 100) return 'Comfortable with silence';
    if (score <= 200) return 'Deep stillness';
    return 'The still mind';
  }
}

final scoreServiceProvider = Provider<ScoreService>((ref) {
  return ScoreService(ref.read(scoreRepositoryProvider));
});
