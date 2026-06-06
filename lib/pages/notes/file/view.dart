import 'package:doflow/pages/notes/file/index.dart';
import 'package:doflow/pages/notes/widgets/note_empty_state.dart';
import 'package:doflow/theme.dart';
import 'package:doflow/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

/// Renders a single note file with edit and preview modes.
class NoteFilePage extends StatelessWidget {
  const NoteFilePage({super.key, required this.fileId});

  final String fileId;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NoteFileController>(
      init: NoteFileController(fileId: fileId),
      global: false,
      builder: (NoteFileController controller) {
        final file = controller.file;

        return CustomScaffold(
          resizeToAvoidBottomInset: true,
          body: SafeArea(
            child: controller.isLoading
                ? const Center(child: CircularProgressIndicator())
                : file == null
                ? Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: NoteEmptyState(
                        icon: Icons.description_outlined,
                        title: '未找到笔记文件',
                        description: '它可能已经被删除，或者当前路径已经失效。',
                        actionLabel: '返回 Notes',
                        onAction: () => context.pop(),
                      ),
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(12.w, 10.h, 20.w, 0),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () async {
                                await controller.saveChanges();
                                if (context.mounted) {
                                  context.pop();
                                }
                              },
                              icon: const Icon(Icons.arrow_back_rounded),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    file.title,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(
                                          color: const Color(0xFF0F172A),
                                          fontWeight: FontWeight.w800,
                                        ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    controller.pathLabel,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: const Color(0xFF94A3B8),
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Row(
                          children: [
                            _ModeButton(
                              label: '编辑',
                              icon: Icons.edit_outlined,
                              isActive: !controller.isPreview,
                              onTap: () => controller.setPreviewMode(false),
                            ),
                            SizedBox(width: 10.w),
                            _ModeButton(
                              label: '预览',
                              icon: Icons.visibility_outlined,
                              isActive: controller.isPreview,
                              onTap: () => controller.setPreviewMode(true),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16.h),
                      const Divider(height: 1, color: Color(0xFFE8EDF5)),
                      Expanded(
                        child: controller.isPreview
                            ? SingleChildScrollView(
                                padding: EdgeInsets.fromLTRB(
                                  20.w,
                                  20.h,
                                  20.w,
                                  28.h,
                                ),
                                child: file.isMarkdown
                                    ? controller.contentController.text
                                              .trim()
                                              .isEmpty
                                          ? const NoteEmptyState(
                                              icon: Icons.edit_note_outlined,
                                              title: '这篇笔记还没有内容',
                                              description:
                                                  '切到编辑模式写下第一段内容，再回来预览排版效果。',
                                            )
                                          : MarkdownBody(
                                              data: controller
                                                  .contentController
                                                  .text,
                                              styleSheet: MarkdownStyleSheet(
                                                h1: Theme.of(context)
                                                    .textTheme
                                                    .headlineMedium
                                                    ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      color: const Color(
                                                        0xFF0F172A,
                                                      ),
                                                    ),
                                                h2: Theme.of(context)
                                                    .textTheme
                                                    .titleLarge
                                                    ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: const Color(
                                                        0xFF0F172A,
                                                      ),
                                                    ),
                                                p: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge
                                                    ?.copyWith(
                                                      height: 1.75,
                                                      color: const Color(
                                                        0xFF111827,
                                                      ),
                                                    ),
                                                listBullet: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge
                                                    ?.copyWith(
                                                      color: const Color(
                                                        0xFF111827,
                                                      ),
                                                    ),
                                              ),
                                            )
                                    : SelectableText(
                                        controller.contentController.text,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.copyWith(height: 1.75),
                                      ),
                              )
                            : Padding(
                                padding: EdgeInsets.fromLTRB(
                                  20.w,
                                  20.h,
                                  20.w,
                                  20.h,
                                ),
                                child: TextField(
                                  controller: controller.contentController,
                                  expands: true,
                                  maxLines: null,
                                  minLines: null,
                                  textAlignVertical: TextAlignVertical.top,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodyLarge?.copyWith(height: 1.75),
                                  decoration: const InputDecoration(
                                    hintText: '开始记录你的笔记内容...',
                                  ),
                                ),
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

class _ModeButton extends StatelessWidget {
  const _ModeButton({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color foreground = isActive ? Colors.white : const Color(0xFF334155);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14.r),
      child: Ink(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isActive ? null : const Color(0xFFF8FAFC),
          gradient: isActive ? CustomTheme.brandGradient : null,
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: foreground, size: 18.w),
            SizedBox(width: 6.w),
            Text(
              label,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: foreground,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
