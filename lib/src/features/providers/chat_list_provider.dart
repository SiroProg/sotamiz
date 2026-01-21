import 'package:flutter/foundation.dart';

import '../chat/models/chat_thread.dart';
import '../chat/repository/chat_repository.dart';

enum LoadStatus { idle, loading, loaded, error }

class ChatListProvider extends ChangeNotifier {
  ChatListProvider({required ChatRepository repository}) : _repository = repository;

  final ChatRepository _repository;

  LoadStatus status = LoadStatus.idle;
  String? errorMessage;
  List<ChatThread> threads = const [];

  String? _cursor;
  bool _isLoadingMore = false;
  bool get canLoadMore => _cursor != null && !_isLoadingMore;
  bool get isLoadingMore => _isLoadingMore;

  Future<void> loadInitial() async {
    status = LoadStatus.loading;
    errorMessage = null;
    notifyListeners();

    try {
      final page = await _repository.fetchThreads(cursor: null, limit: 20);
      threads = page.items;
      _cursor = page.nextCursor;
      status = LoadStatus.loaded;
      notifyListeners();
    } catch (e) {
      status = LoadStatus.error;
      errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    try {
      final page = await _repository.fetchThreads(cursor: null, limit: 20);
      threads = page.items;
      _cursor = page.nextCursor;
      status = LoadStatus.loaded;
      errorMessage = null;
      notifyListeners();
    } catch (e) {
      // Keep old data but show error state if nothing loaded yet.
      errorMessage = e.toString();
      if (threads.isEmpty) {
        status = LoadStatus.error;
      }
      notifyListeners();
    }
  }

  Future<void> loadMore() async {
    if (!canLoadMore) return;
    _isLoadingMore = true;
    notifyListeners();
    try {
      final page = await _repository.fetchThreads(cursor: _cursor, limit: 20);
      threads = [...threads, ...page.items];
      _cursor = page.nextCursor;
      _isLoadingMore = false;
      notifyListeners();
    } catch (e) {
      _isLoadingMore = false;
      errorMessage = e.toString();
      notifyListeners();
    }
  }
}


