import 'package:flutter/material.dart';

class WeeklyHistoryEventModel {
  WeeklyHistoryEventModel({
    required this.dayIndex,
    required this.startMinutes,
    required this.endMinutes,
    required this.title,
    this.color = const Color(0xFF42A5F5),
  });

  final int dayIndex;
  final int startMinutes;
  final int endMinutes;
  final String title;
  final Color color;
}
