import '../models/chat_message.dart';

class ChatMessagesPage {
  const ChatMessagesPage({required this.items, required this.nextCursor});

  final List<ChatMessage> items;
  final String? nextCursor;
}

abstract class ChatMessageRepository {
  Future<ChatMessagesPage> fetchMessages({
    required String threadId,
    String? cursor,
    int limit,
  });

  Future<ChatMessage> sendMessage({
    required String threadId,
    required String text,
  });
}
