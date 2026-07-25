import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/app_database.dart';
import '../../domain/providers/database_provider.dart';

class SessionRepository {
  final AppDatabase _db;
  SessionRepository(this._db);

  Future<int> insertSession(SessionsCompanion session) =>
      _db.into(_db.sessions).insert(session);

  Future<void> updateSession(int id, SessionsCompanion data) =>
      (_db.update(_db.sessions)..where((t) => t.id.equals(id))).write(data);

  Future<Session?> getActiveSession() =>
      (_db.select(_db.sessions)..where((t) => t.endedAt.isNull()))
          .getSingleOrNull();

  Future<Session?> getSessionById(int id) =>
      (_db.select(_db.sessions)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<List<Session>> getAllSessions() =>
      (_db.select(_db.sessions)
            ..orderBy([(t) => OrderingTerm.desc(t.startedAt)]))
          .get();

  Future<int> countCompletedSessions() async {
    final count = await (_db.select(_db.sessions)
          ..where((t) => t.wasCompleted.equals(true)))
        .get();
    return count.length;
  }

  Future<int> countSessionsWithQuietMode() async {
    final rows = await (_db.select(_db.sessions)
          ..where((t) => t.quietModeEnabled.equals(true)))
        .get();
    return rows.length;
  }

  Future<Session?> getLongestSession() async {
    final sessions = await getAllSessions();
    if (sessions.isEmpty) return null;
    return sessions.reduce((a, b) =>
        a.actualDurationSeconds > b.actualDurationSeconds ? a : b);
  }
}

final sessionRepositoryProvider = Provider<SessionRepository>((ref) {
  return SessionRepository(ref.read(databaseProvider));
});
