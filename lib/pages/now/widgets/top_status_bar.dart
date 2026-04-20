import 'package:doflow/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Renders the top time and state row for the Now page.
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
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                formatClock(now),
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              SizedBox(height: 4.h),
              Text(greeting, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F0FF),
            borderRadius: BorderRadius.circular(999.r),
          ),
          child: Text(
            statusLabel,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF2563EB),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
