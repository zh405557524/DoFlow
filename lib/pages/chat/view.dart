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
          backgroundColor: CustomTheme.darkSurface,
          appBar: AppBar(
            title: const Text('Chat'),
            foregroundColor: Colors.white,
            backgroundColor: CustomTheme.darkSurface,
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 12.h),
                    children: controller.messages.isEmpty
                        ? [
                            Padding(
                              padding: EdgeInsets.only(top: 80.h),
                              child: Center(
                                child: Text(
                                  'Send an idea and I will turn it into a draft plan.',
                                  style: Theme.of(context).textTheme.bodyLarge
                                      ?.copyWith(color: Colors.white70),
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
                                              (_) => controller.loadMessages(),
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
        );
      },
    );
  }
}
