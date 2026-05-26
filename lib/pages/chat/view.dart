import 'package:doflow/models/index.dart';
import 'package:doflow/pages/chat/index.dart';
import 'package:doflow/pages/chat/widgets/chat_input_bar.dart';
import 'package:doflow/pages/chat/widgets/draft_card.dart';
import 'package:doflow/pages/chat/widgets/message_bubble.dart';
import 'package:doflow/routes/index.dart';
import 'package:doflow/services/index.dart';
import 'package:doflow/theme.dart';
import 'package:doflow/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

/// Renders the local chat flow and draft application actions.
class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

/// Stores the input controller for the chat page.
class _ChatPageState extends State<ChatPage> {
  final TextEditingController _inputController = TextEditingController();

  static const List<String> _quickReplies = <String>[
    '我今天有点累 😴',
    '状态很好，想冲一把 🔥',
    '帮我安排今天',
  ];

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(
      init: ChatController(),
      global: false,
      builder: (ChatController controller) {
        return CustomScaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            decoration: const BoxDecoration(
              gradient: CustomTheme.chatBackground,
            ),
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 8.h),
                    child: Row(
                      children: [
                        _TopButton(
                          icon: Icons.arrow_back_ios_new_rounded,
                          onTap: () => context.pop(),
                        ),
                        SizedBox(width: 14.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'AI 执行助手',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontSize: 24.sp,
                                      fontWeight: FontWeight.w800,
                                    ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                'gpt-4o · 在线',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: Colors.white.withValues(
                                        alpha: 0.65,
                                      ),
                                    ),
                              ),
                            ],
                          ),
                        ),
                        _TopButton(
                          icon: Icons.auto_awesome_rounded,
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 10.h),
                      children: controller.messages.isEmpty
                          ? [
                              Padding(
                                padding: EdgeInsets.only(top: 44.h),
                                child: Center(
                                  child: Text(
                                    '把想法说出来，我帮你整理成可执行计划。',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: Colors.white70,
                                          height: 1.5,
                                        ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ]
                          : controller.messages.expand((
                              ChatMessageModel message,
                            ) {
                              final List<Widget> children = [
                                MessageBubble(message: message),
                              ];

                              if (message.draftId != null) {
                                final PlanDraftModel? draft =
                                    Get.find<ChatService>().getDraftById(
                                      message.draftId!,
                                    );
                                if (draft != null) {
                                  children.add(
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 12.h),
                                      child: DraftCard(
                                        draft: draft,
                                        onApply: () {
                                          context
                                              .pushNamed(
                                                RouteName.planEditorCreate,
                                                extra: <String, dynamic>{
                                                  'draftId': draft.id,
                                                  'entry': 'chat',
                                                },
                                              )
                                              .then(
                                                (_) =>
                                                    controller.loadMessages(),
                                              );
                                        },
                                      ),
                                    ),
                                  );
                                }
                              }

                              return children;
                            }).toList(),
                    ),
                  ),
                  SizedBox(
                    height: 42.h,
                    child: ListView.separated(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                        final String text = _quickReplies[index];
                        return ActionChip(
                          backgroundColor: Colors.white.withValues(alpha: 0.08),
                          side: BorderSide(
                            color: Colors.white.withValues(alpha: 0.12),
                          ),
                          label: Text(
                            text,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13.sp,
                            ),
                          ),
                          onPressed: () async {
                            await controller.sendMessage(text);
                          },
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          SizedBox(width: 10.w),
                      itemCount: _quickReplies.length,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  ChatInputBar(
                    controller: _inputController,
                    isSending: controller.isSending,
                    onSend: () async {
                      final String content = _inputController.text;
                      _inputController.clear();
                      await controller.sendMessage(content);
                    },
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

class _TopButton extends StatelessWidget {
  const _TopButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: IconButton(
        constraints: BoxConstraints.tightFor(width: 56.w, height: 56.w),
        onPressed: onTap,
        padding: EdgeInsets.zero,
        iconSize: 22.w,
        icon: Icon(icon, color: Colors.white),
      ),
    );
  }
}
