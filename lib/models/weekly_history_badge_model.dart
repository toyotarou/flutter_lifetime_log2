import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WeeklyHistoryBadgeModel {
  const WeeklyHistoryBadgeModel({
    required this.dayIndex,
    required this.minutesOfDay,
    required this.icon,
    this.color = const Color(0xFF1565C0),
    this.tooltip,
  });

  final int dayIndex;
  final int minutesOfDay;
  final FaIconData icon;
  final Color color;
  final String? tooltip;
}
