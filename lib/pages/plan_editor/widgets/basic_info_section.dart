import 'package:doflow/theme.dart';
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
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28.r),
        border: Border.all(color: const Color(0xFF94A3B8), width: 1.4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const _SectionDot(),
              SizedBox(width: 10.w),
              Text('基础信息', style: Theme.of(context).textTheme.titleLarge),
              const Spacer(),
              _SectionBadge(label: '01'),
            ],
          ),
          SizedBox(height: 24.h),
          TextField(
            controller: titleController,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
            decoration: InputDecoration(
              hintText: '给你的计划起个名字...',
              errorText: titleError,
              filled: false,
              contentPadding: EdgeInsets.only(bottom: 16.h),
              border: const UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFE2E8F0)),
              ),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFE2E8F0)),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: CustomTheme.primary, width: 1.4),
              ),
            ),
          ),
          SizedBox(height: 18.h),
          Text(
            '计划类型',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: const Color(0xFF64748B),
            ),
          ),
          SizedBox(height: 10.h),
          Wrap(
            spacing: 10.w,
            runSpacing: 10.h,
            children: PlanTypes.all.map((String type) {
              final bool active = type == selectedPlanType;
              return GestureDetector(
                onTap: () => onTypeChanged(type),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    gradient: active ? CustomTheme.brandGradient : null,
                    color: active ? null : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(16.r),
                    boxShadow: active
                        ? const <BoxShadow>[
                            BoxShadow(
                              color: Color(0x296366F1),
                              blurRadius: 16,
                              offset: Offset(0, 10),
                            ),
                          ]
                        : null,
                  ),
                  child: Text(
                    labelForPlanType(type),
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: active ? Colors.white : CustomTheme.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 18.h),
          Text(
            '主线颜色',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: const Color(0xFF64748B),
            ),
          ),
          SizedBox(height: 10.h),
          Wrap(
            spacing: 12.w,
            runSpacing: 12.h,
            children: AppPlanColors.all.map((String color) {
              final bool active = color == selectedColor;
              return GestureDetector(
                onTap: () => onColorChanged(color),
                child: Container(
                  width: 32.w,
                  height: 32.w,
                  decoration: BoxDecoration(
                    color: colorFromHex(color),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: active
                          ? const Color(0xFF1E1B4B)
                          : Colors.white,
                      width: active ? 2 : 1,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 18.h),
          TextField(
            controller: summaryController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: '一句话描述',
              hintText: '这条主线希望推进什么，为什么现在要开始？',
            ),
          ),
          SizedBox(height: 18.h),
          Container(
            padding: EdgeInsets.all(18.w),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(24.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('时间规划', style: Theme.of(context).textTheme.titleLarge),
                    const Spacer(),
                    _SectionBadge(label: '02'),
                  ],
                ),
                SizedBox(height: 14.h),
                Row(
                  children: [
                    Expanded(
                      child: _DateButton(
                        label: '开始时间',
                        value:
                            '${startAt.year}/${startAt.month}/${startAt.day}',
                        onTap: onPickStart,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: _DateButton(
                        label: '结束时间',
                        value: '${endAt.year}/${endAt.month}/${endAt.day}',
                        onTap: onPickEnd,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionDot extends StatelessWidget {
  const _SectionDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10.w,
      height: 10.w,
      decoration: const BoxDecoration(
        color: Color(0xFF6366F1),
        shape: BoxShape.circle,
      ),
    );
  }
}

class _SectionBadge extends StatelessWidget {
  const _SectionBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: const Color(0xFF64748B),
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _DateButton extends StatelessWidget {
  const _DateButton({
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF94A3B8),
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              value,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
