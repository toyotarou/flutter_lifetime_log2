import 'package:flutter/material.dart';

class YearlyHistoryEvent {
  YearlyHistoryEvent({
    required this.start,
    required this.end,
    required this.color,
    required this.agentName,
    required this.genbaName,
  });

  final DateTime start;
  final DateTime end;
  final Color color;
  final String agentName;
  final String genbaName;
}
