import 'package:doflow/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Renders the top-level plan metadata fields.
class BasicInfoSection extends StatelessWidget {
  const BasicInfoSection({
    super.key,
    required this.titleController,
    required this.summaryController,
    required this.selectedPlanType,
    required this.selectedColor,
    required this.startAt,
    required this.endAt,
    required this.onTypeChanged,
    required this.onColorChanged,
    required this.onPickStart,
    required this.onPickEnd,
    required this.titleError,
  });

  final TextEditingController titleController;
  final TextEditingController summaryController;
  final String selectedPlanType;
  final String selectedColor;
  final DateTime startAt;
  final DateTime endAt;
  final ValueChanged<String?> onTypeChanged;
  final ValueChanged<String> onColorChanged;
  final VoidCallback onPickStart;
  final VoidCallback onPickEnd;
  final String? titleError;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(18.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Basic info', style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 14.h),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Plan title',
                errorText: titleError,
              ),
            ),
            SizedBox(height: 12.h),
            TextField(
              controller: summaryController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Summary',
                hintText: 'What is this plan trying to move forward?',
              ),
            ),
            SizedBox(height: 12.h),
            DropdownButtonFormField<String>(
              initialValue: selectedPlanType,
              decoration: const InputDecoration(labelText: 'Plan type'),
              items: PlanTypes.all
                  .map(
                    (String type) => DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    ),
                  )
                  .toList(),
              onChanged: onTypeChanged,
            ),
            SizedBox(height: 14.h),
            Text('Plan color', style: Theme.of(context).textTheme.titleMedium),
            SizedBox(height: 10.h),
            Wrap(
              spacing: 10.w,
              runSpacing: 10.h,
              children: AppPlanColors.all.map((String color) {
                final bool selected = color == selectedColor;
                return InkWell(
                  onTap: () => onColorChanged(color),
                  borderRadius: BorderRadius.circular(999.r),
                  child: Container(
                    width: 34.w,
                    height: 34.w,
                    decoration: BoxDecoration(
                      color: colorFromHex(color),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: selected ? Colors.black : Colors.transparent,
                        width: 2,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 14.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onPickStart,
                    child: Text(
                      'Start: ${startAt.year}-${startAt.month.toString().padLeft(2, '0')}-${startAt.day.toString().padLeft(2, '0')}',
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: OutlinedButton(
                    onPressed: onPickEnd,
                    child: Text(
                      'End: ${endAt.year}-${endAt.month.toString().padLeft(2, '0')}-${endAt.day.toString().padLeft(2, '0')}',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
