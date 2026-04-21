import 'package:doflow/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Renders the top date, greeting and energy badge for the Now page.
class TopStatusBar extends StatelessWidget {
  const TopStatusBar({
    super.key,
    required this.greeting,
    required this.statusLabel,
  });

  final String greeting;
  final String statusLabel;

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                formatChineseDate(now),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: const Color(0xFF94A3B8),
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                greeting,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: const Color(0x1A6366F1),
            borderRadius: BorderRadius.circular(999.r),
          ),
          child: Text(
            statusLabel,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: const Color(0xFF6366F1),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
