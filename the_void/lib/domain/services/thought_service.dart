import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart';
import '../../data/repositories/thought_repository.dart';
import '../../data/database/app_database.dart';

class ThoughtService {
  final ThoughtRepository _repo;
  ThoughtService(this._repo);

  // Per spec — runs locally, no network call
  String? autoTag(String thought) {
    final lower = thought.toLowerCase();

    if (lower.contains(RegExp(
      r'\b(mum|dad|mom|friend|family|call|someone|they|her|him|people|talk|miss|relationship|person)\b',
    ))) return 'people';

    if (lower.contains(RegExp(
      r'\b(idea|build|make|could|should|project|app|what if|maybe|start|create|design|solution|invent)\b',
    ))) return 'idea';

    if (lower.contains(RegExp(
      r'\b(remember|used to|when i|back when|years ago|childhood|once|always|never|before|past|old)\b',
    ))) return 'memory';

    if (lower.contains(RegExp(
      r'\b(why|how|what|wonder|curious|question|does|is it|are we|should i|could it)\b',
    ))) return 'question';

    return null;
  }

  Future<void> saveThought(int sessionId, String content) async {
    final trimmed = content.trim();
    if (trimmed.isEmpty) return;

    final tag = autoTag(trimmed);
    await _repo.insertThought(ThoughtsCompanion.insert(
      uuid: const Uuid().v4(),
      sessionId: sessionId,
      content: trimmed,
      tag: Value(tag),
      createdAt: DateTime.now(),
    ));
  }
}

final thoughtServiceProvider = Provider<ThoughtService>((ref) {
  return ThoughtService(ref.read(thoughtRepositoryProvider));
});
