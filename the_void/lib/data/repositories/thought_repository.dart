import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/app_database.dart';
import '../../domain/providers/database_provider.dart';

class ThoughtRepository {
  final AppDatabase _db;
  ThoughtRepository(this._db);

  Future<int> insertThought(ThoughtsCompanion thought) =>
      _db.into(_db.thoughts).insert(thought);

  Future<List<Thought>> getAllThoughts() =>
      (_db.select(_db.thoughts)
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .get();

  Future<List<Thought>> getThoughtsByTag(String tag) =>
      (_db.select(_db.thoughts)
            ..where((t) => t.tag.equals(tag))
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .get();

  Future<List<Thought>> searchThoughts(String query) =>
      (_db.select(_db.thoughts)
            ..where((t) => t.content.like('%$query%'))
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .get();

  Future<List<Thought>> getThoughtsByTagAndSearch(
          String tag, String query) =>
      (_db.select(_db.thoughts)
            ..where((t) => t.tag.equals(tag) & t.content.like('%$query%'))
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .get();

  Future<List<Thought>> getRecentThoughts(int limit) =>
      (_db.select(_db.thoughts)
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
            ..limit(limit))
          .get();

  Future<int> countThoughts() async {
    final all = await getAllThoughts();
    return all.length;
  }

  Future<List<Thought>> getThoughtsThisWeek() async {
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));
    return (_db.select(_db.thoughts)
          ..where((t) => t.createdAt.isBiggerThanValue(weekAgo))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
  }
}

final thoughtRepositoryProvider = Provider<ThoughtRepository>((ref) {
  return ThoughtRepository(ref.read(databaseProvider));
});
