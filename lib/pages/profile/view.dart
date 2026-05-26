import 'package:doflow/pages/profile/index.dart';
import 'package:doflow/routes/index.dart';
import 'package:doflow/theme.dart';
import 'package:doflow/utils/index.dart';
import 'package:doflow/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

/// Renders the personal summary page.
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      init: ProfileController(),
      global: false,
      builder: (ProfileController controller) {
        final profile = controller.profile;
        final List<String> previewTags =
            profile?.tags.take(2).toList() ?? const <String>[];

        return CustomScaffold(
          body: SafeArea(
            bottom: false,
            child: profile == null
                ? const Center(child: CircularProgressIndicator())
                : ListView(
                    padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 28.h),
                    children: [
                      InkWell(
                        onTap: () {
                          context
                              .pushNamed(RouteName.userProfile)
                              .then((_) => controller.loadProfile());
                        },
                        borderRadius: BorderRadius.circular(26.r),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: CustomTheme.profileHeroGradient,
                            borderRadius: BorderRadius.circular(26.r),
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                right: -68.w,
                                top: -56.h,
                                child: Container(
                                  width: 184.w,
                                  height: 184.w,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white.withValues(
                                        alpha: 0.08,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(
                                  16.w,
                                  16.h,
                                  16.w,
                                  16.h,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 60.w,
                                          height: 60.w,
                                          decoration: BoxDecoration(
                                            color: colorFromHex(
                                              profile.avatarBg,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              20.r,
                                            ),
                                            boxShadow: const <BoxShadow>[
                                              BoxShadow(
                                                color: Color(0x336366F1),
                                                blurRadius: 18,
                                                offset: Offset(0, 10),
                                              ),
                                            ],
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            profile.avatar,
                                            style: TextStyle(fontSize: 28.sp),
                                          ),
                                        ),
                                        SizedBox(width: 12.w),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                profile.name,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headlineMedium
                                                    ?.copyWith(
                                                      fontSize: 22.sp,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                    ),
                                              ),
                                              SizedBox(height: 4.h),
                                              Text(
                                                profile.bio,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.copyWith(
                                                      fontSize: 13.sp,
                                                      color: Colors.white
                                                          .withValues(
                                                            alpha: 0.78,
                                                          ),
                                                      height: 1.35,
                                                    ),
                                              ),
                                              if (previewTags
                                                  .isNotEmpty) ...<Widget>[
                                                SizedBox(height: 6.h),
                                                Row(
                                                  children: [
                                                    for (
                                                      int index = 0;
                                                      index <
                                                          previewTags.length;
                                                      index++
                                                    ) ...<Widget>[
                                                      Flexible(
                                                        child: Container(
                                                          padding:
                                                              EdgeInsets.symmetric(
                                                                horizontal:
                                                                    10.w,
                                                                vertical: 5.h,
                                                              ),
                                                          decoration: BoxDecoration(
                                                            color: Colors.white
                                                                .withValues(
                                                                  alpha: 0.10,
                                                                ),
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  999.r,
                                                                ),
                                                          ),
                                                          child: Text(
                                                            previewTags[index],
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: Theme.of(context)
                                                                .textTheme
                                                                .bodyMedium
                                                                ?.copyWith(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize:
                                                                      13.sp,
                                                                ),
                                                          ),
                                                        ),
                                                      ),
                                                      if (index !=
                                                          previewTags.length -
                                                              1)
                                                        SizedBox(width: 8.w),
                                                    ],
                                                  ],
                                                ),
                                              ],
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 12.h),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: _HeroStat(
                                            value: '${controller.planCount}',
                                            label: '任务',
                                          ),
                                        ),
                                        SizedBox(width: 10.w),
                                        Expanded(
                                          child: _HeroStat(
                                            value:
                                                '${controller.completedTaskCount}',
                                            label: '完成',
                                          ),
                                        ),
                                        SizedBox(width: 10.w),
                                        Expanded(
                                          child: _HeroStat(
                                            value:
                                                '${(controller.completionRate * 100).round()}%',
                                            label: '完成率',
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
                      ),
                      SizedBox(height: 18.h),
                      _SectionCard(
                        title: '当前能量水平',
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: _EnergyTile(
                                  emoji: '⬇️',
                                  title: '较低',
                                  subtitle: '轻量',
                                  active: profile.energyLevel == 'calm',
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: _EnergyTile(
                                  emoji: '⚡',
                                  title: '中等',
                                  subtitle: '正常',
                                  active: profile.energyLevel == 'steady',
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: _EnergyTile(
                                  emoji: '🔥',
                                  title: '充沛',
                                  subtitle: '冲刺',
                                  active: profile.energyLevel == 'sprint',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      _SectionCard(
                        title: '执行模式',
                        children: [
                          _ModeTile(
                            emoji: '🌿',
                            title: '轻量',
                            subtitle: '只做最重要的一件事',
                            active: profile.mode == 'balance',
                          ),
                          SizedBox(height: 12.h),
                          _ModeTile(
                            emoji: '⚡',
                            title: '正常',
                            subtitle: '按优先级正常执行',
                            active: profile.mode == 'focus',
                          ),
                          SizedBox(height: 12.h),
                          _ModeTile(
                            emoji: '🚀',
                            title: '专注',
                            subtitle: '高强度冲刺',
                            active: profile.mode == 'explore',
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: <Color>[
                              Color(0xFF1E1B4B),
                              Color(0xFF312E81),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(24.r),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '产品理念',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(color: Colors.white),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              '始终显示“现在应该做什么”，而不是展示所有可能性。先把执行路径变短，再把成就感做出来。',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.78),
                                    height: 1.6,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}

class _HeroStat extends StatelessWidget {
  const _HeroStat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontSize: 22.sp,
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 13.sp,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x0D1E1B4B),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 14.h),
          ...children,
        ],
      ),
    );
  }
}

class _EnergyTile extends StatelessWidget {
  const _EnergyTile({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.active,
  });

  final String emoji;
  final String title;
  final String subtitle;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      decoration: BoxDecoration(
        gradient: active ? CustomTheme.brandGradient : null,
        color: active ? null : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        children: [
          Text(emoji, style: TextStyle(fontSize: 18.sp)),
          SizedBox(height: 6.h),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: active ? Colors.white : CustomTheme.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: active ? Colors.white70 : CustomTheme.textSecondary,
              fontSize: 13.sp,
            ),
          ),
        ],
      ),
    );
  }
}

class _ModeTile extends StatelessWidget {
  const _ModeTile({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.active,
  });

  final String emoji;
  final String title;
  final String subtitle;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: active ? const Color(0xFFF1EEFF) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(20.r),
        border: active
            ? Border.all(color: const Color(0x4D6366F1), width: 1.6)
            : null,
      ),
      child: Row(
        children: [
          Text(emoji, style: TextStyle(fontSize: 18.sp)),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ),
          if (active)
            const Icon(Icons.check_rounded, color: CustomTheme.primary),
        ],
      ),
    );
  }
}
