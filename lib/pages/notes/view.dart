import 'package:doflow/models/index.dart';
import 'package:doflow/pages/notes/index.dart';
import 'package:doflow/pages/notes/widgets/note_create_actions.dart';
import 'package:doflow/pages/notes/widgets/note_empty_state.dart';
import 'package:doflow/pages/notes/widgets/note_entry_card.dart';
import 'package:doflow/routes/index.dart';
import 'package:doflow/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

/// Renders the root notes page inside the main shell.
class NotesPage extends StatelessWidget {
  const NotesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NotesController>(
      init: NotesController(),
      global: false,
      builder: (NotesController controller) {
        Future<void> openFolder(NoteFolderModel folder) async {
          await context.pushNamed(
            RouteName.noteFolder,
            pathParameters: <String, String>{'id': folder.id},
          );
          await controller.loadRoot();
        }

        Future<void> openFile(NoteFileModel file) async {
          await context.pushNamed(
            RouteName.noteFile,
            pathParameters: <String, String>{'id': file.id},
          );
          await controller.loadRoot();
        }

        Future<void> createFolder() async {
          final String? name = await _showNameDialog(
            context,
            title: '新建文件夹',
            hintText: '输入文件夹名称',
            initialValue: '新文件夹',
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
                : ListView(
                    padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 24.h),
                    children: [
                      Text(
                        'Notes',
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                              fontSize: 24.sp,
                              color: const Color(0xFF0F172A),
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                      SizedBox(height: 16.h),
                      NoteCreateActions(
                        onCreateFolder: createFolder,
                        onCreateNote: createFile,
                      ),
                      SizedBox(height: 18.h),
                      Divider(
                        height: 1,
                        color: const Color(0xFFE8EDF5),
                        thickness: 1,
                      ),
                      SizedBox(height: 18.h),
                      if (controller.rootFolders.isEmpty &&
                          controller.rootFiles.isEmpty)
                        NoteEmptyState(
                          icon: Icons.note_add_outlined,
                          title: '还没有笔记内容',
                          description: '先创建一个文件夹或新建一篇笔记，资料就会从这里开始沉淀。',
                        ),
                      ...controller.rootFolders.map((NoteFolderModel folder) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 10.h),
                          child: NoteEntryCard(
                            title: folder.name,
                            subtitle: '${controller.itemCountFor(folder)} 项',
                            icon: Icons.folder_outlined,
                            iconColor: const Color(0xFFF59E0B),
                            onTap: () => openFolder(folder),
                          ),
                        );
                      }),
                      if (controller.rootFiles.isNotEmpty) ...[
                        SizedBox(height: 10.h),
                        Text(
                          '根目录文件',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        SizedBox(height: 10.h),
                        ...controller.rootFiles.map((NoteFileModel file) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: 10.h),
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
                    ],
                  ),
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
