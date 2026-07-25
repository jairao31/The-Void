import 'package:drift/drift.dart';

class DailyScores extends Table {
  IntColumn get id                  => integer().autoIncrement()();
  TextColumn get date               => text().unique()(); // 'YYYY-MM-DD'
  IntColumn get score               => integer()();
  IntColumn get sessionsToday       => integer().withDefault(const Constant(0))();
  IntColumn get minutesToday        => integer().withDefault(const Constant(0))();
  IntColumn get longestSessionToday => integer().withDefault(const Constant(0))();
  IntColumn get pointsEarnedToday   => integer().withDefault(const Constant(0))();
}
