import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provides the current cumulative stillness score
final currentScoreProvider = StateProvider<int>((ref) => 0);
