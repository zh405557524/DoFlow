import 'package:doflow/models/index.dart';
import 'package:doflow/services/index.dart';
import 'package:get/get.dart';

/// Owns chat history, input state, and draft actions.
class ChatController extends GetxController {
  bool isSending = false;
  List<ChatMessageModel> messages = const <ChatMessageModel>[];

  @override
  void onInit() {
    super.onInit();
    loadMessages();
  }

  /// Reloads local chat messages from Hive.
  Future<void> loadMessages() async {
    messages = await Get.find<ChatService>().fetchMessages();
    update();
  }

  /// Sends a message, creates a mock draft, and reloads the message list.
  Future<void> sendMessage(String content) async {
    if (content.trim().isEmpty || isSending) {
      return;
    }

    isSending = true;
    update();
    await Get.find<ChatService>().sendMessage(content);
    await loadMessages();
    isSending = false;
    update();
  }
}
