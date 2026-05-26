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
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF94A3B8),
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                greeting,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontSize: 30.sp,
                  fontWeight: FontWeight.w800,
                  height: 1.1,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: const Color(0x1A6366F1),
            borderRadius: BorderRadius.circular(999.r),
          ),
          child: Text(
            statusLabel,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF6366F1),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
