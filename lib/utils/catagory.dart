import 'package:flutter/material.dart';

enum Category { study, health, fitness, spiritual, productivity, others }

extension CategoryExtension on Category {
  String get value {
    return name; // "study", "health", etc.
  }

  static Category fromString(String value) {
    return Category.values.firstWhere(
      (e) => e.name == value,
      orElse: () => Category.others,
    );
  }
}

Color getCategoryColor(Category category) {
  switch (category) {
    case Category.study:
      return Colors.blue;
    case Category.health:
      return Colors.green;
    case Category.fitness:
      return Colors.orange;
    case Category.spiritual:
      return Colors.purple;
    case Category.productivity:
      return Colors.amber;
    case Category.others:
      return Colors.grey;
  }
}
