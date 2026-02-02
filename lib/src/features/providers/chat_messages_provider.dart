import 'package:flutter/foundation.dart';

import '../screens/chat/models/chat_message.dart';
import '../screens/chat/repository/chat_message_repository.dart';

enum ChatMessagesStatus { idle, loading, loaded, error }

class ChatMessagesProvider extends ChangeNotifier {
  ChatMessagesProvider({required ChatMessageRepository repository})
    : _repository = repository;

  final ChatMessageRepository _repository;

  ChatMessagesStatus status = ChatMessagesStatus.idle;
  String? errorMessage;
  List<ChatMessage> messages = const [];

  String? _cursor;
  bool _isLoadingMore = false;
  bool get canLoadMore => _cursor != null && !_isLoadingMore;
  bool get isLoadingMore => _isLoadingMore;

  Future<void> loadInitial(String threadId) async {
    status = ChatMessagesStatus.loading;
    errorMessage = null;
    notifyListeners();
    try {
      final page = await _repository.fetchMessages(
        threadId: threadId,
        cursor: null,
        limit: 20,
      );
      messages = page.items;
      _cursor = page.nextCursor;
      status = ChatMessagesStatus.loaded;
      notifyListeners();
    } catch (e) {
      status = ChatMessagesStatus.error;
      errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> refresh(String threadId) async {
    try {
      final page = await _repository.fetchMessages(
        threadId: threadId,
        cursor: null,
        limit: 20,
      );
      messages = page.items;
      _cursor = page.nextCursor;
      status = ChatMessagesStatus.loaded;
      errorMessage = null;
      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      if (messages.isEmpty) status = ChatMessagesStatus.error;
      notifyListeners();
    }
  }

  Future<void> loadMore(String threadId) async {
    if (!canLoadMore) return;
    _isLoadingMore = true;
    notifyListeners();
    try {
      final page = await _repository.fetchMessages(
        threadId: threadId,
        cursor: _cursor,
        limit: 20,
      );
      messages = [...messages, ...page.items];
      _cursor = page.nextCursor;
      _isLoadingMore = false;
      notifyListeners();
    } catch (e) {
      _isLoadingMore = false;
      errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> send(String threadId, String text, {String? replyToId}) async {
    if (text.trim().isEmpty) return;
    try {
      final sent = await _repository.sendMessage(
        threadId: threadId,
        text: text.trim(),
        replyToId: replyToId,
      );
      messages = [...messages, sent];
      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> sendImage(String threadId, String imagePath) async {
    try {
      final sent = await _repository.sendImage(
        threadId: threadId,
        imagePath: imagePath,
      );
      messages = [...messages, sent];
      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> sendVoiceMessage(
    String threadId,
    String audioPath, {
    Duration? duration,
  }) async {
    try {
      final sent = await _repository.sendVoiceMessage(
        threadId: threadId,
        audioPath: audioPath,
        duration: duration,
      );
      messages = [...messages, sent];
      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }
}
