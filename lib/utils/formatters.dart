import 'package:flutter/material.dart';

/// Formats a friendly greeting based on the current hour.
String buildGreeting(DateTime now) {
  if (now.hour < 12) {
    return '早上好 👋';
  }
  if (now.hour < 18) {
    return '下午好 ☀️';
  }
  return '晚上好 🌙';
}

/// Formats a short time label for the Now page.
String formatClock(DateTime dateTime) {
  final String hour = dateTime.hour.toString().padLeft(2, '0');
  final String minute = dateTime.minute.toString().padLeft(2, '0');
  return '$hour:$minute';
}

/// Formats a compact Chinese date label for headers.
String formatChineseDate(DateTime dateTime) {
  const List<String> weekdays = <String>[
    '周一',
    '周二',
    '周三',
    '周四',
    '周五',
    '周六',
    '周日',
  ];
  return '${dateTime.month}月${dateTime.day}日 ${weekdays[dateTime.weekday - 1]}';
}

/// Formats a short date range for cards and detail pages.
String formatDateRange(DateTime start, DateTime end) {
  return '${start.year}.${start.month.toString().padLeft(2, '0')}.${start.day.toString().padLeft(2, '0')}'
      ' - '
      '${end.year}.${end.month.toString().padLeft(2, '0')}.${end.day.toString().padLeft(2, '0')}';
}

String labelForProfileMode(String value) {
  switch (value) {
    case 'focus':
      return '专注';
    case 'balance':
      return '平衡';
    case 'explore':
      return '探索';
    default:
      return value;
  }
}

String labelForEnergyLevel(String value) {
  switch (value) {
    case 'steady':
      return '能量中等';
    case 'calm':
      return '轻量模式';
    case 'sprint':
      return '高能冲刺';
    default:
      return value;
  }
}

String labelForPlanType(String value) {
  switch (value) {
    case 'Focus':
      return '职业发展';
    case 'Learning':
      return '学习成长';
    case 'Life':
      return '生活目标';
    case 'Project':
      return '创作输出';
    default:
      return value;
  }
}

/// Converts a hex color string to a Flutter color.
Color colorFromHex(String hex) {
  final String normalized = hex.replaceFirst('#', '');
  final String withAlpha = normalized.length == 6
      ? 'FF$normalized'
      : normalized;
  return Color(int.parse(withAlpha, radix: 16));
}
