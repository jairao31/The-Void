class IdleThought {
  final int id;
  final String uuid;
  final int sessionId;
  final String content;
  final String? tag;
  final DateTime createdAt;

  const IdleThought({
    required this.id,
    required this.uuid,
    required this.sessionId,
    required this.content,
    this.tag,
    required this.createdAt,
  });
}
