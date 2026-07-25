import 'package:drift/drift.dart';
import 'sessions_table.dart';

class Thoughts extends Table {
  IntColumn get id          => integer().autoIncrement()();
  TextColumn get uuid       => text().withLength(min: 36, max: 36).unique()();
  IntColumn get sessionId   => integer().references(Sessions, #id)();
  TextColumn get content    => text().withLength(max: 500)();
  TextColumn get tag        => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
}
