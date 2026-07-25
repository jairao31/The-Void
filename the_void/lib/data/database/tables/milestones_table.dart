import 'package:drift/drift.dart';

class Milestones extends Table {
  IntColumn get id               => integer().autoIncrement()();
  TextColumn get milestoneKey    => text().unique()();
  DateTimeColumn get unlockedAt  => dateTime()();
}
