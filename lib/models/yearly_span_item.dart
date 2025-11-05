import 'package:flutter/material.dart';

class YearlySpanItem {
  YearlySpanItem({
    required this.startMonth,
    required this.endMonth,
    required this.color,
    required this.agentName,
    required this.genbaName,
  });

  final int startMonth;
  final int endMonth;
  final Color color;
  final String agentName;
  final String genbaName;
}
