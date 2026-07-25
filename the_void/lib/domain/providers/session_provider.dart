import 'package:flutter_riverpod/flutter_riverpod.dart';

// Stores the selected duration when navigating from home/picker to session flow
final selectedDurationProvider = StateProvider<int>((ref) => 300);

// Active session DB id — set when session starts, cleared after post/interrupted
final activeSessionIdProvider = StateProvider<int?>((ref) => null);

// Result passed from VoidSessionScreen → PostSessionScreen / InterruptedScreen
class SessionResult {
  final int sessionId;
  final int actualDurationSeconds;
  final int targetDurationSeconds;
  final int pointsEarned;
  final bool wasCompleted;
  final bool quietModeEnabled;

  const SessionResult({
    required this.sessionId,
    required this.actualDurationSeconds,
    required this.targetDurationSeconds,
    required this.pointsEarned,
    required this.wasCompleted,
    required this.quietModeEnabled,
  });
}

final completedSessionResultProvider = StateProvider<SessionResult?>((ref) => null);
