import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/idle_thought.dart';

// Provides the list of thoughts for the harvest screen
final thoughtListProvider = StateProvider<List<IdleThought>>((ref) => []);
