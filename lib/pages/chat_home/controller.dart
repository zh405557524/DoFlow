import 'package:doflow/models/index.dart';
import 'package:doflow/services/index.dart';
import 'package:get/get.dart';

/// Owns the v2 conversation-first home state.
class ChatHomeController extends GetxController {
  bool isLoading = true;
  bool isSending = false;
  List<ChatMessageModel> messages = const <ChatMessageModel>[];
  TaskInstanceModel? todayTask;
  String todaySuggestion = '';

  @override
  void onInit() {
    super.onInit();
    loadHome();
  }

  /// Loads local chat history and the lightweight today recommendation.
  Future<void> loadHome() async {
    isLoading = true;
    update();
    await Future.wait(<Future<void>>[loadMessages(), loadTodaySuggestion()]);
    isLoading = false;
    update();
  }

  /// Reloads the local chat messages.
  Future<void> loadMessages() async {
    messages = await Get.find<ChatService>().fetchMessages();
    update();
  }

  /// Reloads the current task recommendation without exposing the old Now UI.
  Future<void> loadTodaySuggestion() async {
    final NowSnapshotModel snapshot = await Get.find<NowService>()
        .buildSnapshot();
    todayTask = snapshot.recommendedTask;
    todaySuggestion = snapshot.suggestionText;
    update();
  }

  /// Sends a user message through the existing local chat service.
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

  /// Records a short assistant feedback message after returning from focus.
  Future<void> appendFocusResult(String message) async {
    if (message.trim().isEmpty) {
      return;
    }
    await Get.find<ChatService>().addAssistantMessage(message.trim());
    await Future.wait(<Future<void>>[loadMessages(), loadTodaySuggestion()]);
  }
}
