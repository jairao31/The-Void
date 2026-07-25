class VoidSession {
  final int id;
  final String uuid;
  final DateTime startedAt;
  final DateTime? endedAt;
  final int targetDurationSeconds;
  final int actualDurationSeconds;
  final bool wasCompleted;
  final bool quietModeEnabled;
  final bool wasInterrupted;
  final String? interruptReason;
  final int pointsEarned;

  const VoidSession({
    required this.id,
    required this.uuid,
    required this.startedAt,
    this.endedAt,
    required this.targetDurationSeconds,
    required this.actualDurationSeconds,
    required this.wasCompleted,
    required this.quietModeEnabled,
    required this.wasInterrupted,
    this.interruptReason,
    required this.pointsEarned,
  });
}
