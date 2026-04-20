import 'package:doflow/pages/foundation_placeholder/index.dart';
import 'package:doflow/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class FoundationPlaceholderPage extends StatelessWidget {
  const FoundationPlaceholderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FoundationPlaceholderController>(
      init: FoundationPlaceholderController(),
      global: false,
      builder: (controller) {
        return CustomScaffold(
          appBar: AppBar(title: const Text('DoFlow')),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'App Foundation Ready',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    controller.isReady
                        ? 'Global.init completed successfully.'
                        : 'Initialization is not ready yet.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  SizedBox(height: 24.h),
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(20.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            controller.appName,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            'Version ${controller.version} (${controller.buildNumber})',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            'Installation ID',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          SizedBox(height: 8.h),
                          SelectableText(
                            controller.installationId,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    'Opened Hive Boxes',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(height: 12.h),
                  Expanded(
                    child: ListView.separated(
                      itemCount: controller.openedBoxes.length,
                      separatorBuilder: (_, _) => SizedBox(height: 8.h),
                      itemBuilder: (context, index) {
                        final String boxName = controller.openedBoxes[index];
                        return Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 14.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18.r),
                          ),
                          child: Text(
                            boxName,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        );
                      },
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
