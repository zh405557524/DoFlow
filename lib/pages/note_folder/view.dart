import 'package:doflow/models/index.dart';
import 'package:doflow/pages/main/widgets/bottom_nav.dart';
import 'package:doflow/pages/note_folder/index.dart';
import 'package:doflow/pages/notes/widgets/note_create_actions.dart';
import 'package:doflow/pages/notes/widgets/note_empty_state.dart';
import 'package:doflow/pages/notes/widgets/note_entry_card.dart';
import 'package:doflow/routes/index.dart';
import 'package:doflow/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

/// Renders a nested notes folder while keeping the notes nav highlighted.
class NoteFolderPage extends StatelessWidget {
  const NoteFolderPage({super.key, required this.folderId});

  final String folderId;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NoteFolderController>(
      init: NoteFolderController(folderId: folderId),
      global: false,
      builder: (NoteFolderController controller) {
        Future<void> openFolder(NoteFolderModel folder) async {
          await context.pushNamed(
            RouteName.noteFolder,
            pathParameters: <String, String>{'id': folder.id},
          );
          await controller.loadFolder();
        }

        Future<void> openFile(NoteFileModel file) async {
          await context.pushNamed(
            RouteName.noteFile,
            pathParameters: <String, String>{'id': file.id},
          );
          await controller.loadFolder();
        }

        Future<void> createFolder() async {
          final String? name = await _showNameDialog(
            context,
            title: '新建子文件夹',
            hintText: '输入子文件夹名称',
            initialValue: '新子文件夹',
          );
          if (name == null) {
            return;
          }
          await controller.createFolder(name);
        }

        Future<void> createFile() async {
          final String? name = await _showNameDialog(
            context,
            title: '新建笔记',
            hintText: '输入笔记名称',
            initialValue: '新笔记.md',
          );
          if (name == null) {
            return;
          }
          final NoteFileModel? file = await controller.createFile(name);
          if (file == null || !context.mounted) {
            return;
          }
          await openFile(file);
        }

        return CustomScaffold(
          body: SafeArea(
            bottom: false,
            child: controller.isLoading
                ? const Center(child: CircularProgressIndicator())
                : controller.folder == null
                ? Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: NoteEmptyState(
                        icon: Icons.folder_off_outlined,
                        title: '这个文件夹不存在',
                        description: '它可能已经被删除，或者当前路径已经失效。',
                        actionLabel: '返回 Notes',
                        onAction: () => context.goNamed(RouteName.notes),
                      ),
                    ),
                  )
                : ListView(
                    padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 24.h),
                    children: [
                      Text(
                        controller.breadcrumbLabel,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFF64748B),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        controller.folder?.name ?? 'Notes',
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                              color: const Color(0xFF0F172A),
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                      SizedBox(height: 18.h),
                      NoteCreateActions(
                        onCreateFolder: createFolder,
                        onCreateNote: createFile,
                      ),
                      SizedBox(height: 20.h),
                      Divider(
                        height: 1,
                        color: const Color(0xFFE8EDF5),
                        thickness: 1,
                      ),
                      SizedBox(height: 20.h),
                      if (controller.childFolders.isEmpty &&
                          controller.childFiles.isEmpty)
                        NoteEmptyState(
                          icon: Icons.create_new_folder_outlined,
                          title: '这个文件夹还是空的',
                          description: '可以继续创建子文件夹，或者直接写一篇新笔记。',
                        ),
                      ...controller.childFolders.map((NoteFolderModel folder) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 12.h),
                          child: NoteEntryCard(
                            title: folder.name,
                            subtitle: '${controller.itemCountFor(folder)} 项',
                            icon: Icons.folder_outlined,
                            iconColor: const Color(0xFFF59E0B),
                            onTap: () => openFolder(folder),
                          ),
                        );
                      }),
                      ...controller.childFiles.map((NoteFileModel file) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 12.h),
                          child: NoteEntryCard(
                            title: file.title,
                            subtitle: file.isMarkdown ? 'Markdown' : '文档',
                            icon: Icons.description_outlined,
                            iconColor: const Color(0xFF6366F1),
                            onTap: () => openFile(file),
                          ),
                        );
                      }),
                    ],
                  ),
          ),
          bottomNavigationBar: MainBottomNav(
            currentIndex: 3,
            onTap: (int index) => _handleBottomTap(context, index),
          ),
        );
      },
    );
  }
}

Future<String?> _showNameDialog(
  BuildContext context, {
  required String title,
  required String hintText,
  required String initialValue,
}) async {
  final TextEditingController controller = TextEditingController(
    text: initialValue,
  );

  return showDialog<String>(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(hintText: hintText),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(dialogContext).pop(controller.text.trim());
            },
            child: const Text('确认'),
          ),
        ],
      );
    },
  );
}

void _handleBottomTap(BuildContext context, int index) {
  if (index == 1) {
    context.pushNamed(RouteName.chat);
    return;
  }

  switch (index) {
    case 0:
      context.goNamed(RouteName.now);
      return;
    case 2:
      context.goNamed(RouteName.plan);
      return;
    case 3:
      context.goNamed(RouteName.notes);
      return;
    case 4:
      context.goNamed(RouteName.profile);
      return;
  }
}
