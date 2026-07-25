import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/app_database.dart';
import '../../domain/providers/database_provider.dart';
import '../../core/utils/date_utils.dart' as date_utils;

class ScoreRepository {
  final AppDatabase _db;
  ScoreRepository(this._db);

  Future<DailyScore?> getTodayRecord() =>
      (_db.select(_db.dailyScores)
            ..where((t) => t.date.equals(date_utils.todayKey())))
          .getSingleOrNull();

  Future<int> getCurrentScore() async {
    final rows = await (_db.select(_db.dailyScores)
          ..orderBy([(t) => OrderingTerm.desc(t.date)])
          ..limit(1))
        .get();
    return rows.isEmpty ? 0 : rows.first.score;
  }

  Future<int> getTodayPointsEarned() async {
    final today = await getTodayRecord();
    return today?.pointsEarnedToday ?? 0;
  }

  Future<void> upsertTodayScore({
    required int pointsToAdd,
    required int sessionSeconds,
  }) async {
    final today = await getTodayRecord();
    final currentScore = await getCurrentScore();
    final newScore = currentScore + pointsToAdd;
    final dateKey = date_utils.todayKey();

    if (today == null) {
      await _db.into(_db.dailyScores).insert(DailyScoresCompanion.insert(
            date: dateKey,
            score: newScore,
            sessionsToday: const Value(1),
            minutesToday: Value((sessionSeconds / 60).round()),
            longestSessionToday: Value(sessionSeconds),
            pointsEarnedToday: Value(pointsToAdd),
          ));
    } else {
      final newMinutes = today.minutesToday + (sessionSeconds / 60).round();
      final newLongest = sessionSeconds > today.longestSessionToday
          ? sessionSeconds
          : today.longestSessionToday;
      await (_db.update(_db.dailyScores)
            ..where((t) => t.date.equals(dateKey)))
          .write(DailyScoresCompanion(
            score: Value(newScore),
            sessionsToday: Value(today.sessionsToday + 1),
            minutesToday: Value(newMinutes),
            longestSessionToday: Value(newLongest),
            pointsEarnedToday: Value(today.pointsEarnedToday + pointsToAdd),
          ));
    }
  }

  Future<List<DailyScore>> getLast7Days() async {
    final rows = await (_db.select(_db.dailyScores)
          ..orderBy([(t) => OrderingTerm.desc(t.date)])
          ..limit(7))
        .get();
    return rows;
  }
}

final scoreRepositoryProvider = Provider<ScoreRepository>((ref) {
  return ScoreRepository(ref.read(databaseProvider));
});
