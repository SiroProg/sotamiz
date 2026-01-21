import 'dart:convert';

import '../../../core/service/api_service.dart';
import '../models/chat_thread.dart';
import 'chat_repository.dart';

/// Реализация репозитория, готовая к бэкенду.
/// Ожидаемый ответ: {"items":[...], "nextCursor":"..."}.
class ApiChatRepository implements ChatRepository {
  const ApiChatRepository();

  static const _endpoint = '/chats/threads';

  @override
  Future<ChatListPage> fetchThreads({String? cursor, int limit = 20}) async {
    final raw = await ApiService.request(
      _endpoint,
      method: Method.get,
      queryParameters: {'limit': limit, if (cursor != null) 'cursor': cursor},
    );

    final decoded = jsonDecode(raw);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Unexpected chats response');
    }

    final items = (decoded['items'] as List? ?? [])
        .whereType<Map>()
        .map((e) => ChatThread.fromJson(e.cast<String, dynamic>()))
        .toList();

    final nextCursor = decoded['nextCursor']?.toString();

    return ChatListPage(
      items: items,
      nextCursor: nextCursor?.isEmpty == true ? null : nextCursor,
    );
  }
}
