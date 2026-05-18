import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/habit_model.dart';

class HabitApi {
  final String baseUrl =
      "https://6a06c5ddc83ba8ad9b3dd41e.mockapi.io/api/ht/habits";

  //get all habits

  Future<List<Habit>> getHabits(String? query) async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);

      List<Habit> habits = data.map((json) {
        return Habit.fromJson(json);
      }).toList();

      if (query != null) {
        return habits.where((habit) {
          return habit.title.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }

      return habits;
    } else {
      throw Exception('Faild to load habits');
    }
  }

  //post habits
  Future<Habit> createHabit(Habit habit) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(habit.toJson()),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return Habit.fromJson(json);
    } else {
      throw Exception("Failed to create habit");
    }
  }
  //update habit

  Future<Habit> updateHabit(Habit habit) async {
    final response = await http.put(
      Uri.parse("$baseUrl/${habit.id}"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "id": habit.id,
        "title": habit.title,
        "category": habit.category.name,
        "message": habit.message,
        "repeatDays": habit.repeatDays,
        "createdAt": habit.createdAt,
        "endDate": habit.endDate?.toIso8601String(),
        "isCompletedToday": habit.isCompletedToday,
      }),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);

      return Habit.fromJson(json);
    } else {
      throw Exception("Failed to update habit");
    }
  }

  //delete habit by id

  Future<void> deleteHabit(String id) async {
    await http.delete(Uri.parse("$baseUrl/$id"));
  }
}
