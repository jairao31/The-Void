class DailyScore {
  final int id;
  final String date; // 'YYYY-MM-DD'
  final int score;
  final int sessionsToday;
  final int minutesToday;
  final int longestSessionToday;
  final int pointsEarnedToday;

  const DailyScore({
    required this.id,
    required this.date,
    required this.score,
    required this.sessionsToday,
    required this.minutesToday,
    required this.longestSessionToday,
    required this.pointsEarnedToday,
  });
}
