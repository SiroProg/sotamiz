import 'dart:convert';

import '../../../../core/service/api_service.dart';
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
      queryParameters: {'limit': limit, if (cursor != null) 'cursor': cursor},
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
    String? replyToId,
  }) async {
    final raw = await ApiService.request(
      '/chats/$threadId/messages',
      method: Method.post,
      body: {'text': text, if (replyToId != null) 'replyToId': replyToId},
    );

    final decoded = jsonDecode(raw);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Unexpected send response');
    }

    return ChatMessage.fromJson(decoded);
  }

  @override
  Future<ChatMessage> sendImage({
    required String threadId,
    required String imagePath,
  }) async {
    // TODO: Реализовать отправку изображения через multipart/form-data
    // Пока используем заглушку - отправляем как текстовое сообщение с путем
    final raw = await ApiService.request(
      '/chats/$threadId/messages',
      method: Method.post,
      body: {'text': '[Фото]', 'imagePath': imagePath, 'type': 'image'},
    );

    final decoded = jsonDecode(raw);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Unexpected send image response');
    }

    return ChatMessage.fromJson(decoded);
  }

  @override
  Future<ChatMessage> sendVoiceMessage({
    required String threadId,
    required String audioPath,
    Duration? duration,
  }) async {
    // TODO: Реализовать отправку голосового сообщения через multipart/form-data
    // Пока используем заглушку - отправляем как текстовое сообщение с путем
    final raw = await ApiService.request(
      '/chats/$threadId/messages',
      method: Method.post,
      body: {
        'text': '[Голосовое сообщение]',
        'audioPath': audioPath,
        'type': 'voice',
        if (duration != null) 'duration': duration.inSeconds,
      },
    );

    final decoded = jsonDecode(raw);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Unexpected send voice response');
    }

    return ChatMessage.fromJson(decoded);
  }
}
