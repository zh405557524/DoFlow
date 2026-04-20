import 'package:doflow/models/index.dart';
import 'package:doflow/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Renders the generated draft card inside the chat flow.
class DraftCard extends StatelessWidget {
  const DraftCard({super.key, required this.draft, required this.onApply});

  final PlanDraftModel draft;
  final VoidCallback onApply;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(draft.title, style: Theme.of(context).textTheme.titleMedium),
            SizedBox(height: 8.h),
            Text(draft.summary, style: Theme.of(context).textTheme.bodyMedium),
            SizedBox(height: 10.h),
            Text(
              '${draft.phases.length} phases ready to review',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 12.h),
            CustomButton(
              label: 'Apply draft',
              icon: Icons.auto_fix_high_rounded,
              onPressed: onApply,
            ),
          ],
        ),
      ),
    );
  }
}
