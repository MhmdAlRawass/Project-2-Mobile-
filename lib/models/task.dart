import 'package:flutter/material.dart';

class Task {
  const Task({
    required this.id,
    required this.desc,
    required this.date,
    this.isImportant = false,
    required this.categoryId,
    required this.startTime,
    this.isDone = false,
  });
  final int id;
  final String desc;
  final DateTime date;
  final TimeOfDay startTime;
  final bool isImportant;
  final int categoryId;
  final bool isDone;
}
