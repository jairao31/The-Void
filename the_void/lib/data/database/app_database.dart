import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'tables/sessions_table.dart';
import 'tables/thoughts_table.dart';
import 'tables/daily_scores_table.dart';
import 'tables/milestones_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Sessions, Thoughts, DailyScores, Milestones])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_sessions_started_at ON sessions (started_at DESC)',
      );
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_sessions_uuid ON sessions (uuid)',
      );
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_thoughts_session_id ON thoughts (session_id)',
      );
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_thoughts_created_at ON thoughts (created_at DESC)',
      );
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_thoughts_tag ON thoughts (tag)',
      );
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_daily_scores_date ON daily_scores (date DESC)',
      );
    },
  );
}

QueryExecutor _openConnection() {
  return driftDatabase(name: 'the_void');
}
