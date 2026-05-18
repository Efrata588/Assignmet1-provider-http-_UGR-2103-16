import 'package:flutter/material.dart';
import '../models/habit_model.dart';
import '../services/habit_api.dart';
import '../utils/catagory.dart';

class HabitProvider extends ChangeNotifier {
  final HabitApi _api = HabitApi();

  List<Habit> _habits = [];
  bool _isLoading = false;

  Category? _selectedCategory;

  List<Habit> get habits => _habits;
  bool get isLoading => _isLoading;
  Category? get selectedCategory => _selectedCategory;

  // LOAD

  Future<void> loadHabits({String? query}) async {
    _isLoading = true;
    notifyListeners();

    _habits = await _api.getHabits(query);

    _isLoading = false;
    notifyListeners();
  }

  // CATEGORY

  void setCategory(Category? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  List<Habit> get filteredAllHabits {
    if (_selectedCategory == null) return _habits;

    return _habits.where((h) => h.category == _selectedCategory).toList();
  }

  // TODAY FILTER + CATEGORY

  List<Habit> get todayHabits {
    final today = DateTime.now();

    const days = [
      "Sunday",
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
    ];

    String todayName = days[today.weekday % 7];

    final todayList = _habits
        .where((h) => h.repeatDays.contains(todayName))
        .toList();

    if (_selectedCategory == null) return todayList;

    return todayList.where((h) => h.category == _selectedCategory).toList();
  }

  // ADD NEW HABIT

  Future<void> addHabit(Habit habit) async {
    final newHabit = await _api.createHabit(habit);
    _habits.add(newHabit);
    notifyListeners();
  }

  // UPDATE

  Future<void> updateHabit(Habit habit) async {
    final updated = await _api.updateHabit(habit);

    final index = _habits.indexWhere((h) => h.id == habit.id);

    if (index != -1) {
      _habits[index] = updated;
    }

    notifyListeners();
  }

  // PROGRESS

  int get todayProgress {
    if (todayHabits.isEmpty) return 0;

    final completed = todayHabits.where((h) => h.isCompletedToday).length;

    return ((completed / todayHabits.length) * 100).round();
  }

  // TOGGLE

  Future<void> toggleHabit(Habit habit) async {
    final updatedHabit = habit.copyWith(
      isCompletedToday: !habit.isCompletedToday,
    );

    try {
      final result = await _api.updateHabit(updatedHabit);

      final index = _habits.indexWhere((h) => h.id == habit.id);

      if (index != -1) {
        _habits[index] = result;
      }

      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  // EDIT
  //
  //

  // DELETE

  Future<void> deleteHabit(String id) async {
    await _api.deleteHabit(id);
    _habits.removeWhere((h) => h.id == id);
    notifyListeners();
  }
}
