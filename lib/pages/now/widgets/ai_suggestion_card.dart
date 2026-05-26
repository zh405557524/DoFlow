import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Renders the small AI suggestion label above the main recommendation.
class AiSuggestionCard extends StatelessWidget {
  const AiSuggestionCard({super.key, required this.suggestion});

  final String suggestion;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '🤖 AI 建议你现在做：',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: const Color(0xFF94A3B8),
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          suggestion,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: const Color(0xFF94A3B8),
            height: 1.4,
          ),
        ),
      ],
    );
  }
}
