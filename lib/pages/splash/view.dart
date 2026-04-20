import 'package:doflow/pages/splash/index.dart';
import 'package:doflow/theme.dart';
import 'package:doflow/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/// Renders the branded splash page before the main shell loads.
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(
      init: SplashController(),
      global: false,
      builder: (SplashController controller) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          controller.start(context);
        });

        return CustomScaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            decoration: const BoxDecoration(gradient: CustomTheme.splashBackground),
            child: SafeArea(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ...List<Widget>.generate(4, (int index) {
                    final double size = 210.w + (index * 56.w);
                    return Container(
                      width: size,
                      height: size,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withValues(
                            alpha: 0.08 - (index * 0.012),
                          ),
                        ),
                      ),
                    );
                  }),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 28.w,
                      vertical: 36.h,
                    ),
                    child: Column(
                      children: [
                        const Spacer(),
                        Container(
                          width: 96.w,
                          height: 96.w,
                          decoration: BoxDecoration(
                            gradient: CustomTheme.brandGradient,
                            borderRadius: BorderRadius.circular(28.r),
                            boxShadow: const <BoxShadow>[
                              BoxShadow(
                                color: Color(0x523730A3),
                                blurRadius: 28,
                                offset: Offset(0, 16),
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '⚡',
                            style: TextStyle(fontSize: 38.sp),
                          ),
                        ),
                        SizedBox(height: 36.h),
                        Text(
                          '执行力',
                          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                            color: Colors.white,
                            fontSize: 36.sp,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          '始终显示现在该做什么',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: const Color(0xCCA5B4FC),
                            height: 1.5,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'AI 驱动的离线优先执行系统',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: const Color(0xB3FFFFFF),
                          ),
                        ),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List<Widget>.generate(3, (int index) {
                            return Container(
                              width: 8.w,
                              height: 8.w,
                              margin: EdgeInsets.symmetric(horizontal: 5.w),
                              decoration: BoxDecoration(
                                color: const Color(0xB3A5B4FC).withValues(
                                  alpha: 0.55 + (index * 0.15),
                                ),
                                shape: BoxShape.circle,
                              ),
                            );
                          }),
                        ),
                        SizedBox(height: 18.h),
                        Text(
                          '正在准备你的今日主线...',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: const Color(0xB3A5B4FC),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
