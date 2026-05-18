import '../models/habit_model.dart';
import 'package:intl/intl.dart';

int completionPercentage(List<Habit> habits) {
  if (habits.isEmpty) return 0;

  int completed = habits.where((h) => h.isCompletedToday).length;
  return ((completed / habits.length) * 100).round();
}

//get todays date

String getTodayDate() {
  final now = DateTime.now();
  return DateFormat('EEEE, MMM d').format(now);
}
