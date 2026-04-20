import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Renders the AI suggestion card at the top of the Now page.
class AiSuggestionCard extends StatelessWidget {
  const AiSuggestionCard({super.key, required this.suggestion});

  final String suggestion;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(18.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'AI suggestion',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 10.h),
            Text(suggestion, style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }
}
