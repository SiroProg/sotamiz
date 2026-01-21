import 'dart:convert';

import '../../../core/service/api_service.dart';
import '../models/chat_message.dart';
import 'chat_message_repository.dart';

class ApiChatMessageRepository implements ChatMessageRepository {
  const ApiChatMessageRepository();

  @override
  Future<ChatMessagesPage> fetchMessages({
    required String threadId,
    String? cursor,
    int limit = 20,
  }) async {
    final raw = await ApiService.request(
      '/chats/$threadId/messages',
      method: Method.get,
      queryParameters: {
        'limit': limit,
        if (cursor != null) 'cursor': cursor,
      },
    );

    final decoded = jsonDecode(raw);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Unexpected messages response');
    }

    final items = (decoded['items'] as List? ?? [])
        .whereType<Map>()
        .map((e) => ChatMessage.fromJson(e.cast<String, dynamic>()))
        .toList();
    final nextCursor = decoded['nextCursor']?.toString();

    return ChatMessagesPage(
      items: items,
      nextCursor: nextCursor?.isEmpty == true ? null : nextCursor,
    );
  }

  @override
  Future<ChatMessage> sendMessage({
    required String threadId,
    required String text,
  }) async {
    final raw = await ApiService.request(
      '/chats/$threadId/messages',
      method: Method.post,
      body: {'text': text},
    );

    final decoded = jsonDecode(raw);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Unexpected send response');
    }

    return ChatMessage.fromJson(decoded);
  }
}

