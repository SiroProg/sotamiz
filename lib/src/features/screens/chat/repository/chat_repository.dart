import '../models/chat_thread.dart';

class ChatListPage {
  const ChatListPage({
    required this.items,
    required this.nextCursor,
  });

  final List<ChatThread> items;
  final String? nextCursor;
}

abstract class ChatRepository {
  Future<ChatListPage> fetchThreads({
    String? cursor,
    int limit = 20,
  });
}


