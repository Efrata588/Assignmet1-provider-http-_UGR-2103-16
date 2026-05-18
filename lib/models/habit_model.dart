import '../utils/catagory.dart';

class Habit {
  final String id;
  final String title;
  final Category category;
  final String? message;
  final List<String> repeatDays;
  final String createdAt;
  final DateTime? endDate;
  final bool isCompletedToday;

  Habit({
    required this.id,
    required this.title,
    required this.category,
    required this.repeatDays,
    required this.createdAt,
    this.message,
    this.endDate,
    this.isCompletedToday = false,
  });

  //from json to habit object

  factory Habit.fromJson(Map<String, dynamic> json) {
    return Habit(
      id: json['id'],
      title: json['title'],
      category: CategoryExtension.fromString(json['category']),
      message: json['message'],
      repeatDays: List<String>.from(json['repeatDays'] ?? []),
      createdAt: json['createdAt'],
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      isCompletedToday: json['isCompletedToday'] ?? false,
    );
  }

  //habit object to json

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'category': category.value,
      'repeatDays': repeatDays,
      'createdAt': createdAt,
      'endDate': endDate?.toIso8601String(),
      'isCompletedToday': isCompletedToday,
    };
  }

  //change fields of existing object

  Habit copyWith({
    String? id,
    String? title,
    Category? category,
    String? message,
    List<String>? repeatDays,
    String? createdAt,
    DateTime? endDate,
    bool? isCompletedToday,
  }) {
    return Habit(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      message: message ?? this.message,
      repeatDays: repeatDays ?? this.repeatDays,
      createdAt: createdAt ?? this.createdAt,
      endDate: endDate ?? this.endDate,
      isCompletedToday: isCompletedToday ?? this.isCompletedToday,
    );
  }
}
