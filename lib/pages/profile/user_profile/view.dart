import 'package:doflow/pages/profile/user_profile/index.dart';
import 'package:doflow/routes/index.dart';
import 'package:doflow/store/index.dart';
import 'package:doflow/theme.dart';
import 'package:doflow/utils/index.dart';
import 'package:doflow/widgets/index.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

/// Renders the editable profile screen.
class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserProfileController>(
      init: UserProfileController(),
      global: false,
      builder: (UserProfileController controller) {
        final int planCount = PlanStore.to.plans.length;
        final int completedTaskCount = PlanStore.to.plans.fold<int>(
          0,
          (int total, plan) => total + plan.phaseCount,
        );
        final int totalTaskCount = PlanStore.to.plans.fold<int>(
          0,
          (int total, plan) => total + plan.taskCount,
        );
        final double completionRate = totalTaskCount == 0
            ? 0
            : completedTaskCount / totalTaskCount;

        return CustomScaffold(
          body: SafeArea(
            bottom: false,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 10.h),
                  child: Row(
                    children: [
                      _TopIconButton(
                        icon: Icons.arrow_back_ios_new_rounded,
                        onTap: () => Navigator.of(context).pop(),
                      ),
                      Expanded(
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onLongPress: kReleaseMode
                              ? null
                              : () => context.pushNamed(RouteName.debugTools),
                          child: Text(
                            '个人信息',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: controller.isSaving
                            ? null
                            : () async {
                                await controller.saveProfile();
                                if (context.mounted) {
                                  Navigator.of(context).pop();
                                }
                              },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 18.w,
                            vertical: 10.h,
                          ),
                          decoration: BoxDecoration(
                            gradient: CustomTheme.brandGradient,
                            borderRadius: BorderRadius.circular(18.r),
                          ),
                          child: Text(
                            '保存',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 24.h),
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(20.w, 22.h, 20.w, 22.h),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(28.r),
                          boxShadow: const <BoxShadow>[
                            BoxShadow(
                              color: Color(0x0D1E1B4B),
                              blurRadius: 20,
                              offset: Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  width: 112.w,
                                  height: 112.w,
                                  decoration: BoxDecoration(
                                    color: colorFromHex(
                                      controller.selectedAvatarBg,
                                    ),
                                    borderRadius: BorderRadius.circular(32.r),
                                    boxShadow: const <BoxShadow>[
                                      BoxShadow(
                                        color: Color(0x336366F1),
                                        blurRadius: 22,
                                        offset: Offset(0, 12),
                                      ),
                                    ],
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    controller.selectedAvatar,
                                    style: TextStyle(fontSize: 46.sp),
                                  ),
                                ),
                                Positioned(
                                  right: -6.w,
                                  bottom: -6.h,
                                  child: Container(
                                    width: 36.w,
                                    height: 36.w,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      boxShadow: const <BoxShadow>[
                                        BoxShadow(
                                          color: Color(0x14000000),
                                          blurRadius: 10,
                                          offset: Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    alignment: Alignment.center,
                                    child: const Icon(
                                      Icons.edit_rounded,
                                      size: 18,
                                      color: Color(0xFFEF4444),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12.h),
                            Text(
                              '点击更换头像',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            SizedBox(height: 22.h),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '头像表情',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                            SizedBox(height: 12.h),
                            Wrap(
                              spacing: 10.w,
                              runSpacing: 10.h,
                              children: UserProfileController.avatarOptions.map((
                                String avatar,
                              ) {
                                final bool active =
                                    controller.selectedAvatar == avatar;
                                return GestureDetector(
                                  onTap: () {
                                    controller.selectedAvatar = avatar;
                                    controller.update();
                                  },
                                  child: Container(
                                    width: 48.w,
                                    height: 48.w,
                                    decoration: BoxDecoration(
                                      color: active
                                          ? const Color(0xFFEDE9FE)
                                          : const Color(0xFFF8FAFC),
                                      borderRadius: BorderRadius.circular(16.r),
                                      border: Border.all(
                                        color: active
                                            ? CustomTheme.primary
                                            : Colors.transparent,
                                      ),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      avatar,
                                      style: TextStyle(fontSize: 22.sp),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                            SizedBox(height: 18.h),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '背景颜色',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                            SizedBox(height: 12.h),
                            Wrap(
                              spacing: 12.w,
                              runSpacing: 12.h,
                              children: UserProfileController.avatarBgOptions.map((
                                String color,
                              ) {
                                final bool active =
                                    controller.selectedAvatarBg == color;
                                return GestureDetector(
                                  onTap: () {
                                    controller.selectedAvatarBg = color;
                                    controller.update();
                                  },
                                  child: Container(
                                    width: 28.w,
                                    height: 28.w,
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
                            SizedBox(height: 22.h),
                            _LabeledField(
                              label: '昵称',
                              child: TextField(
                                controller: controller.nameController,
                                decoration: const InputDecoration(
                                  hintText: '你叫什么名字？',
                                ),
                              ),
                            ),
                            SizedBox(height: 16.h),
                            _LabeledField(
                              label: '座右铭 / 一句话介绍',
                              child: TextField(
                                controller: controller.bioController,
                                maxLines: 2,
                                decoration: const InputDecoration(
                                  hintText: '你想对自己说什么？',
                                ),
                              ),
                            ),
                            SizedBox(height: 16.h),
                            _LabeledField(
                              label: '城市',
                              child: TextField(
                                controller: controller.cityController,
                                decoration: const InputDecoration(
                                  hintText: '你在哪个城市？',
                                ),
                              ),
                            ),
                            SizedBox(height: 16.h),
                            _LabeledField(
                              label: '标签',
                              child: TextField(
                                controller: controller.tagsController,
                                decoration: const InputDecoration(
                                  hintText: '例如：执行力, 长期主义, 创作',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Container(
                        padding: EdgeInsets.all(20.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(28.r),
                          border: Border.all(
                            color: const Color(0x4D6366F1),
                            width: 1.4,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '⚡ 执行数据',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            SizedBox(height: 18.h),
                            Row(
                              children: [
                                Expanded(
                                  child: _StatTile(
                                    label: '总任务',
                                    value: '$planCount',
                                    valueColor: CustomTheme.textPrimary,
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                Expanded(
                                  child: _StatTile(
                                    label: '已完成',
                                    value: '$completedTaskCount',
                                    valueColor: CustomTheme.primary,
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                Expanded(
                                  child: _StatTile(
                                    label: '完成率',
                                    value:
                                        '${(completionRate * 100).round()}%',
                                    valueColor: const Color(0xFF10B981),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              '整体完成进度',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            SizedBox(height: 8.h),
                            Row(
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(999.r),
                                    child: LinearProgressIndicator(
                                      value: completionRate.clamp(0.0, 1.0),
                                      minHeight: 8.h,
                                      backgroundColor: const Color(0xFFE5E7EB),
                                      valueColor:
                                          const AlwaysStoppedAnimation<Color>(
                                        CustomTheme.primary,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                Text(
                                  '${(completionRate * 100).round()}%',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        color: CustomTheme.primary,
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: SafeArea(
            minimum: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 20.h),
            child: CustomButton(
              label: controller.isSaving ? '保存中...' : '保存个人信息',
              icon: Icons.check_rounded,
              onPressed: controller.isSaving
                  ? null
                  : () async {
                      await controller.saveProfile();
                      if (context.mounted) {
                        Navigator.of(context).pop();
                      }
                    },
            ),
          ),
        );
      },
    );
  }
}

class _TopIconButton extends StatelessWidget {
  const _TopIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48.w,
        height: 48.w,
        decoration: BoxDecoration(
          color: const Color(0xFFEDE9FE),
          borderRadius: BorderRadius.circular(16.r),
        ),
        alignment: Alignment.center,
        child: Icon(icon, color: CustomTheme.primary, size: 18),
      ),
    );
  }
}

class _LabeledField extends StatelessWidget {
  const _LabeledField({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleMedium),
        SizedBox(height: 10.h),
        child,
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: valueColor,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF94A3B8),
            ),
          ),
        ],
      ),
    );
  }
}
