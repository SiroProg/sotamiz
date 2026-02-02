import '../models/chat_thread.dart';
import 'chat_repository.dart';

class MockChatRepository implements ChatRepository {
  const MockChatRepository();

  @override
  Future<ChatListPage> fetchThreads({String? cursor, int limit = 20}) async {
    // Tiny delay to emulate network.
    await Future<void>.delayed(const Duration(milliseconds: 450));
    return ChatListPage(items: _items, nextCursor: null);
  }
}

final _items = <ChatThread>[
  ChatThread(
    id: 't1',
    peer: ChatUser(
      id: 'u1',
      name: 'Сара Иванова',
      avatarUrl:
          'https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg?auto=compress&cs=tinysrgb&w=200',
    ),
    lastMessage: ChatMessagePreview(text: 'Это еще доступно?'),
    lastMessageAt: DateTime.fromMillisecondsSinceEpoch(0),
    unreadCount: 2,
    listing: ChatListingPreview(
      id: 'l1',
      title: 'Серый диван',
      priceText: '25 000 ₽',
      imageUrl:
          'https://images.pexels.com/photos/1866149/pexels-photo-1866149.jpeg?auto=compress&cs=tinysrgb&w=400',
    ),
    isPeerOnline: true,
  ),
  ChatThread(
    id: 't2',
    peer: ChatUser(
      id: 'u2',
      name: 'Михаил Петров',
      avatarUrl:
          'https://images.pexels.com/photos/614810/pexels-photo-614810.jpeg?auto=compress&cs=tinysrgb&w=200',
    ),
    lastMessage: ChatMessagePreview(text: 'Можем встретиться завтра?'),
    lastMessageAt: DateTime.fromMillisecondsSinceEpoch(0),
    unreadCount: 1,
    listing: ChatListingPreview(
      id: 'l2',
      title: 'Горный велосипед',
      priceText: '18 000 ₽',
      imageUrl:
          'https://images.pexels.com/photos/100582/pexels-photo-100582.jpeg?auto=compress&cs=tinysrgb&w=400',
    ),
    isPeerOnline: true,
  ),
  ChatThread(
    id: 't3',
    peer: ChatUser(
      id: 'u3',
      name: 'Елена Смирнова',
      avatarUrl:
          'https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?auto=compress&cs=tinysrgb&w=200',
    ),
    lastMessage: ChatMessagePreview(text: 'Какое состояние?'),
    lastMessageAt: DateTime.fromMillisecondsSinceEpoch(0),
    unreadCount: 0,
    listing: ChatListingPreview(
      id: 'l3',
      title: 'MacBook Pro 2020',
      priceText: '65 000 ₽',
      imageUrl:
          'https://images.pexels.com/photos/574069/pexels-photo-574069.jpeg?auto=compress&cs=tinysrgb&w=400',
    ),
    isPeerOnline: false,
  ),
  ChatThread(
    id: 't4',
    peer: ChatUser(
      id: 'u4',
      name: 'Иван Козлов',
      avatarUrl:
          'https://images.pexels.com/photos/428333/pexels-photo-428333.jpeg?auto=compress&cs=tinysrgb&w=200',
    ),
    lastMessage: ChatMessagePreview(text: 'Спасибо за сделку!'),
    lastMessageAt: DateTime.fromMillisecondsSinceEpoch(0),
    unreadCount: 0,
    listing: ChatListingPreview(
      id: 'l4',
      title: 'Кожаная куртка',
      priceText: '8 500 ₽',
      imageUrl:
          'https://images.pexels.com/photos/2983464/pexels-photo-2983464.jpeg?auto=compress&cs=tinysrgb&w=400',
    ),
    isPeerOnline: false,
  ),
];
