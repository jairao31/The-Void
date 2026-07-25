import 'package:drift/drift.dart';

class Sessions extends Table {
  IntColumn get id               => integer().autoIncrement()();
  TextColumn get uuid            => text().withLength(min: 36, max: 36).unique()();
  DateTimeColumn get startedAt   => dateTime()();
  DateTimeColumn get endedAt     => dateTime().nullable()();
  IntColumn get targetDurationSeconds => integer()();
  IntColumn get actualDurationSeconds => integer().withDefault(const Constant(0))();
  BoolColumn get wasCompleted    => boolean().withDefault(const Constant(false))();
  BoolColumn get quietModeEnabled => boolean().withDefault(const Constant(false))();
  BoolColumn get wasInterrupted  => boolean().withDefault(const Constant(false))();
  TextColumn get interruptReason => text().nullable()();
  IntColumn get pointsEarned     => integer().withDefault(const Constant(0))();
}
