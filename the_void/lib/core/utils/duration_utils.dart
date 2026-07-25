String formatDuration(int seconds) {
  final m = seconds ~/ 60;
  final s = seconds % 60;
  if (m == 0) return '$s sec';
  if (s == 0) return '$m min';
  return '$m min $s sec';
}

String formatMinutes(int seconds) {
  final m = (seconds / 60).round();
  return '$m min';
}
