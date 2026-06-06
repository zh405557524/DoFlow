import 'package:doflow/models/index.dart';
import 'package:doflow/pages/chat_home/index.dart';
import 'package:doflow/routes/index.dart';
import 'package:doflow/services/index.dart';
import 'package:doflow/theme.dart';
import 'package:doflow/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

/// Renders the v2 conversation-first app home.
class ChatHomePage extends StatefulWidget {
  const ChatHomePage({super.key});

  @override
  State<ChatHomePage> createState() => _ChatHomePageState();
}

class _ChatHomePageState extends State<ChatHomePage> {
  final TextEditingController _inputController = TextEditingController();

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatHomeController>(
      init: ChatHomeController(),
      global: false,
      builder: (ChatHomeController controller) {
        return CustomScaffold(
          backgroundColor: const Color(0xFFFEFDF9),
          body: SafeArea(
            bottom: false,
            child: Column(
              children: <Widget>[
                _TopBar(
                  onOpenMenu: () => _showSideMenu(context),
                  onOpenProfile: () => context.pushNamed(RouteName.profile),
                ),
                Expanded(
                  child: controller.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : controller.messages.isEmpty
                      ? _EntryState(
                          task: controller.todayTask,
                          onStartToday: () =>
                              _startTodayPlan(context, controller),
                          onSwitch: controller.loadTodaySuggestion,
                          onCreatePlan: () =>
                              context.pushNamed(RouteName.planCreate),
                        )
                      : _ActiveConversation(
                          controller: controller,
                          onStartToday: () =>
                              _startTodayPlan(context, controller),
                        ),
                ),
                _ComposerBar(
                  controller: _inputController,
                  isSending: controller.isSending,
                  onOpenTools: () => _showToolMenu(context, controller),
                  onSend: () async {
                    final String content = _inputController.text;
                    _inputController.clear();
                    await controller.sendMessage(content);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _startTodayPlan(
    BuildContext context,
    ChatHomeController controller,
  ) async {
    final String? result = await context.pushNamed<String>(
      RouteName.todayFocus,
    );
    if (result != null && result.trim().isNotEmpty) {
      await controller.appendFocusResult(result);
    } else {
      await controller.loadTodaySuggestion();
    }
  }

  Future<void> _showToolMenu(
    BuildContext context,
    ChatHomeController controller,
  ) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext sheetContext) {
        return SafeArea(
          top: false,
          child: Container(
            margin: EdgeInsets.fromLTRB(16.w, 0, 16.w, 12.h),
            padding: EdgeInsets.fromLTRB(18.w, 16.h, 18.w, 14.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24.r),
              border: Border.all(color: const Color(0xFFE8E5DE)),
              boxShadow: const <BoxShadow>[
                BoxShadow(
                  color: Color(0x1F0F172A),
                  blurRadius: 30,
                  offset: Offset(0, 16),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _SheetTitle(title: '选择一个动作'),
                _ToolRow(
                  icon: Icons.play_circle_outline_rounded,
                  label: '开启今天计划',
                  onTap: () async {
                    Navigator.of(sheetContext).pop();
                    await _startTodayPlan(context, controller);
                  },
                ),
                _ToolRow(
                  icon: Icons.add_task_rounded,
                  label: '创建计划',
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    context.pushNamed(RouteName.planCreate);
                  },
                ),
                _ToolRow(
                  icon: Icons.note_add_outlined,
                  label: '写笔记',
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    context.pushNamed(RouteName.notes);
                  },
                ),
                _ToolRow(
                  icon: Icons.inventory_2_outlined,
                  label: '查看计划库',
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    context.pushNamed(RouteName.plan);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showSideMenu(BuildContext context) {
    return showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'side-menu',
      barrierColor: Colors.black.withValues(alpha: 0.08),
      transitionDuration: const Duration(milliseconds: 180),
      pageBuilder:
          (
            BuildContext dialogContext,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) {
            return Align(
              alignment: Alignment.centerLeft,
              child: Material(
                color: Colors.transparent,
                child: SafeArea(
                  child: Container(
                    width: 292.w,
                    height: double.infinity,
                    padding: EdgeInsets.fromLTRB(24.w, 28.h, 18.w, 20.h),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        right: BorderSide(color: Color(0xFFE8E5DE)),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '执行力',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                fontSize: 21.sp,
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          '对话、计划与笔记',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: const Color(0xFF8C919E)),
                        ),
                        SizedBox(height: 24.h),
                        _SideAction(
                          icon: Icons.add_comment_outlined,
                          label: '新对话',
                          onTap: () => Navigator.of(dialogContext).pop(),
                        ),
                        SizedBox(height: 26.h),
                        _SideSectionLabel('最近'),
                        _SideText('今天的执行安排'),
                        _SideText('Android 面试准备'),
                        _SideText('整理本周计划'),
                        SizedBox(height: 26.h),
                        _SideSectionLabel('入口'),
                        _SideAction(
                          icon: Icons.inventory_2_outlined,
                          label: '计划库',
                          onTap: () {
                            Navigator.of(dialogContext).pop();
                            context.pushNamed(RouteName.plan);
                          },
                        ),
                        _SideAction(
                          icon: Icons.note_alt_outlined,
                          label: '笔记',
                          onTap: () {
                            Navigator.of(dialogContext).pop();
                            context.pushNamed(RouteName.notes);
                          },
                        ),
                        _SideAction(
                          icon: Icons.settings_outlined,
                          label: '设置',
                          onTap: () {
                            Navigator.of(dialogContext).pop();
                            context.pushNamed(RouteName.profile);
                          },
                        ),
                        const Spacer(),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFBFAF2),
                            borderRadius: BorderRadius.circular(18.r),
                            border: Border.all(color: const Color(0xFFE8E5DE)),
                          ),
                          child: Text(
                            '本地使用中 · 无需登录',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
      transitionBuilder:
          (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(-1, 0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.onOpenMenu, required this.onOpenProfile});

  final VoidCallback onOpenMenu;
  final VoidCallback onOpenProfile;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 4.h),
      child: Row(
        children: <Widget>[
          IconButton(
            onPressed: onOpenMenu,
            icon: const Icon(Icons.menu_rounded),
            color: const Color(0xFF1A1C24),
          ),
          const Spacer(),
          Text(
            '执行力',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontSize: 17.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          InkWell(
            onTap: onOpenProfile,
            borderRadius: BorderRadius.circular(16.r),
            child: Container(
              width: 32.w,
              height: 32.w,
              decoration: const BoxDecoration(
                color: Color(0xFFF0EDE5),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person_outline_rounded,
                size: 18,
                color: Color(0xFF5C616B),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EntryState extends StatelessWidget {
  const _EntryState({
    required this.task,
    required this.onStartToday,
    required this.onSwitch,
    required this.onCreatePlan,
  });

  final TaskInstanceModel? task;
  final VoidCallback onStartToday;
  final VoidCallback onSwitch;
  final VoidCallback onCreatePlan;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            '✦',
            style: TextStyle(
              color: CustomTheme.primary,
              fontSize: 26.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            '要开启今天的计划吗？',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontSize: 23.sp,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF0F121A),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            '我会只挑出现在最值得做的一件事。',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF6B7380),
              height: 1.35,
            ),
          ),
          if (task != null) ...<Widget>[
            SizedBox(height: 40.h),
            _SuggestionPill(task: task!),
          ] else ...<Widget>[SizedBox(height: 40.h), _EmptySuggestion()],
          SizedBox(height: 22.h),
          FilledButton(
            onPressed: onStartToday,
            style: FilledButton.styleFrom(
              minimumSize: Size(164.w, 42.h),
              backgroundColor: CustomTheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22.r),
              ),
            ),
            child: const Text('开启今天计划'),
          ),
          SizedBox(height: 14.h),
          Wrap(
            spacing: 10.w,
            children: <Widget>[
              _SoftChip(label: '换一个', onTap: onSwitch),
              _SoftChip(label: '创建计划', onTap: onCreatePlan),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActiveConversation extends StatelessWidget {
  const _ActiveConversation({
    required this.controller,
    required this.onStartToday,
  });

  final ChatHomeController controller;
  final VoidCallback onStartToday;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.fromLTRB(20.w, 18.h, 20.w, 18.h),
      children: <Widget>[
        if (controller.todayTask != null)
          _TodayActionCard(task: controller.todayTask!, onTap: onStartToday),
        ...controller.messages.expand((ChatMessageModel message) {
          final List<Widget> children = <Widget>[
            _HomeMessageBubble(message: message),
          ];
          if (message.draftId != null) {
            final PlanDraftModel? draft = Get.find<ChatService>().getDraftById(
              message.draftId!,
            );
            if (draft != null) {
              children.add(_DraftPreviewCard(draft: draft));
            }
          }
          return children;
        }),
      ],
    );
  }
}

class _SuggestionPill extends StatelessWidget {
  const _SuggestionPill({required this.task});

  final TaskInstanceModel task;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 15.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: const Color(0xFFE5E3DB)),
      ),
      child: Text(
        '建议先做：${task.taskTitle} · ${task.planTitle}',
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: const Color(0xFF292B33),
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _EmptySuggestion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 15.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: const Color(0xFFE5E3DB)),
      ),
      child: Text(
        '还没有可执行任务。可以先创建一个计划。',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: const Color(0xFF6B7380),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _TodayActionCard extends StatelessWidget {
  const _TodayActionCard({required this.task, required this.onTap});

  final TaskInstanceModel task;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 18.h),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20.r),
        child: Container(
          padding: EdgeInsets.all(18.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: const Color(0xFFE5E3DB)),
          ),
          child: Row(
            children: <Widget>[
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: const Color(0xFFEDEBFF),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: const Icon(
                  Icons.play_arrow_rounded,
                  color: CustomTheme.primary,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '现在只做这一件事',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: CustomTheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      task.taskTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeMessageBubble extends StatelessWidget {
  const _HomeMessageBubble({required this.message});

  final ChatMessageModel message;

  @override
  Widget build(BuildContext context) {
    final bool isUser = message.role == 'user';
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(maxWidth: 286.w),
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isUser ? CustomTheme.primary : Colors.white,
          borderRadius: BorderRadius.circular(18.r),
          border: isUser ? null : Border.all(color: const Color(0xFFE5E3DB)),
        ),
        child: Text(
          message.content,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: isUser ? Colors.white : const Color(0xFF1F2129),
            height: 1.4,
          ),
        ),
      ),
    );
  }
}

class _DraftPreviewCard extends StatelessWidget {
  const _DraftPreviewCard({required this.draft});

  final PlanDraftModel draft;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F6FE),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: const Color(0xFFD1D4F7)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '计划草稿',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF404294),
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 8.h),
          Text(draft.title, style: Theme.of(context).textTheme.titleMedium),
          SizedBox(height: 12.h),
          OutlinedButton(
            onPressed: () {
              context.pushNamed(
                RouteName.planCreate,
                extra: <String, dynamic>{
                  'draftId': draft.id,
                  'entry': 'chat_home',
                },
              );
            },
            child: const Text('打开草稿'),
          ),
        ],
      ),
    );
  }
}

class _ComposerBar extends StatelessWidget {
  const _ComposerBar({
    required this.controller,
    required this.isSending,
    required this.onOpenTools,
    required this.onSend,
  });

  final TextEditingController controller;
  final bool isSending;
  final VoidCallback onOpenTools;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 14.h),
        child: Container(
          constraints: BoxConstraints(minHeight: 52.h),
          padding: EdgeInsets.only(left: 6.w, right: 6.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(26.r),
            border: Border.all(color: const Color(0xFFDBD9D1)),
            boxShadow: const <BoxShadow>[
              BoxShadow(
                color: Color(0x0F0F172A),
                blurRadius: 18,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: <Widget>[
              IconButton(
                onPressed: onOpenTools,
                icon: const Icon(Icons.add_rounded),
                color: const Color(0xFF2E3038),
              ),
              Expanded(
                child: TextField(
                  controller: controller,
                  minLines: 1,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: '告诉我今天的状态...',
                    filled: false,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              IconButton(
                onPressed: isSending ? null : onSend,
                icon: isSending
                    ? SizedBox(
                        width: 18.w,
                        height: 18.w,
                        child: const CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.arrow_upward_rounded),
                style: IconButton.styleFrom(
                  backgroundColor: CustomTheme.primary,
                  foregroundColor: Colors.white,
                  fixedSize: Size(34.w, 34.w),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SoftChip extends StatelessWidget {
  const _SoftChip({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      onPressed: onTap,
      backgroundColor: const Color(0xFFF7F6F0),
      side: const BorderSide(color: Color(0xFFE5E3DB)),
      label: Text(label),
      labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: const Color(0xFF5C616B),
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _SheetTitle extends StatelessWidget {
  const _SheetTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(left: 4.w, bottom: 6.h),
        child: Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: const Color(0xFF7A808C)),
        ),
      ),
    );
  }
}

class _ToolRow extends StatelessWidget {
  const _ToolRow({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: const Color(0xFF171A21)),
      title: Text(
        label,
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
      ),
      onTap: onTap,
    );
  }
}

class _SideSectionLabel extends StatelessWidget {
  const _SideSectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: const Color(0xFF8C919E),
          fontSize: 12.sp,
        ),
      ),
    );
  }
}

class _SideText extends StatelessWidget {
  const _SideText(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: const Color(0xFF1F2129),
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _SideAction extends StatelessWidget {
  const _SideAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 11.h),
        child: Row(
          children: <Widget>[
            Icon(icon, size: 20.w, color: const Color(0xFF171A21)),
            SizedBox(width: 12.w),
            Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
          ],
        ),
      ),
    );
  }
}
