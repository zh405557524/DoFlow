import 'package:doflow/pages/debug_tools/index.dart';
import 'package:doflow/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/// Renders internal development actions for local seed import and inspection.
class DebugToolsPage extends StatelessWidget {
  const DebugToolsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DebugToolsController>(
      init: DebugToolsController(),
      global: false,
      builder: (DebugToolsController controller) {
        return CustomScaffold(
          body: SafeArea(
            bottom: false,
            child: ListView(
              padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 28.h),
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    ),
                    Expanded(
                      child: Text(
                        '调试工具',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: controller.isBusy
                          ? null
                          : () => controller.refreshSnapshot(),
                      icon: const Icon(Icons.refresh_rounded),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  '内部页面：导入可复用的本地测试数据。',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF94A3B8),
                  ),
                ),
                SizedBox(height: 18.h),
                _InfoCard(
                  title: controller.appName,
                  lines: <String>[
                    'Version ${controller.version} (${controller.buildNumber})',
                    'Installation ID',
                    controller.installationId,
                  ],
                ),
                SizedBox(height: 14.h),
                _InfoCard(
                  title: 'full_demo',
                  lines: <String>[
                    '3 条主线 · 21 个任务实例',
                    '2 份草稿 · 4 条聊天消息',
                    '完整 Notes 目录树与同步记录',
                  ],
                ),
                SizedBox(height: 14.h),
                CustomButton(
                  label: controller.isBusy ? '导入中...' : '重置并导入 full_demo',
                  icon: Icons.science_outlined,
                  onPressed: controller.isBusy
                      ? null
                      : () => controller.importFullDemo(),
                ),
                SizedBox(height: 12.h),
                Text(
                  controller.lastResult,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF64748B),
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 18.h),
                Text(
                  '当前本地数据',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 12.h),
                Wrap(
                  spacing: 10.w,
                  runSpacing: 10.h,
                  children: [
                    _StatChip(label: 'Plans', value: '${controller.planCount}'),
                    _StatChip(
                      label: 'Tasks',
                      value: '${controller.taskInstanceCount}',
                    ),
                    _StatChip(
                      label: 'Drafts',
                      value: '${controller.draftCount}',
                    ),
                    _StatChip(
                      label: 'Folders',
                      value: '${controller.noteFolderCount}',
                    ),
                    _StatChip(
                      label: 'Files',
                      value: '${controller.noteFileCount}',
                    ),
                    _StatChip(
                      label: 'Sync',
                      value: '${controller.syncRecordCount}',
                    ),
                  ],
                ),
                SizedBox(height: 18.h),
                Text(
                  'Opened Hive Boxes',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 12.h),
                ...controller.openedBoxes.map((String boxName) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 8.h),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 12.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Text(
                        boxName,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.title, required this.lines});

  final String title;
  final List<String> lines;

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
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 10.h),
          ...lines.map((String line) {
            return Padding(
              padding: EdgeInsets.only(bottom: 6.h),
              child: Text(
                line,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF64748B),
                  height: 1.5,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF94A3B8),
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
