import '../models/chat_message.dart';
import 'chat_message_repository.dart';

class MockChatMessageRepository implements ChatMessageRepository {
  const MockChatMessageRepository();

  @override
  Future<ChatMessagesPage> fetchMessages({
    required String threadId,
    String? cursor,
    int limit = 20,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    return ChatMessagesPage(items: _messages, nextCursor: null);
  }

  @override
  Future<ChatMessage> sendMessage({
    required String threadId,
    required String text,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return ChatMessage(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      threadId: threadId,
      text: text,
      createdAt: DateTime.now(),
      isMine: true,
    );
  }
}

final _messages = <ChatMessage>[
  ChatMessage(
    id: 'm1',
    threadId: 't1',
    text: 'Это еще доступно?',
    createdAt: DateTime.fromMillisecondsSinceEpoch(0),
    isMine: false,
  ),
  ChatMessage(
    id: 'm2',
    threadId: 't1',
    text: 'Да, в наличии. Могу отдать сегодня.',
    createdAt: DateTime.fromMillisecondsSinceEpoch(0),
    isMine: true,
  ),
  ChatMessage(
    id: 'm3',
    threadId: 't1',
    text: 'Отлично, когда удобно встретиться?',
    createdAt: DateTime.fromMillisecondsSinceEpoch(0),
    isMine: false,
  ),
];
