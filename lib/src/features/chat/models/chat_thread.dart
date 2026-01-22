class ChatThread {
  const ChatThread({
    required this.id,
    required this.peer,
    required this.lastMessage,
    required this.lastMessageAt,
    required this.unreadCount,
    required this.listing,
    required this.isPeerOnline,
  });

  final String id;
  final ChatUser peer;
  final ChatMessagePreview lastMessage;
  final DateTime lastMessageAt;
  final int unreadCount;
  final ChatListingPreview? listing;
  final bool isPeerOnline;

  factory ChatThread.fromJson(Map<String, dynamic> json) {
    return ChatThread(
      id: (json['id'] ?? '').toString(),
      peer: ChatUser.fromJson((json['peer'] as Map?)?.cast<String, dynamic>() ?? const {}),
      lastMessage: ChatMessagePreview.fromJson(
        (json['lastMessage'] as Map?)?.cast<String, dynamic>() ?? const {},
      ),
      lastMessageAt: DateTime.tryParse((json['lastMessageAt'] ?? '').toString()) ??
          DateTime.fromMillisecondsSinceEpoch(0),
      unreadCount: (json['unreadCount'] is num) ? (json['unreadCount'] as num).toInt() : 0,
      listing: json['listing'] is Map
          ? ChatListingPreview.fromJson((json['listing'] as Map).cast<String, dynamic>())
          : null,
      isPeerOnline: json['isPeerOnline'] == true,
    );
  }
}

class ChatUser {
  const ChatUser({
    required this.id,
    required this.name,
    required this.avatarUrl,
    this.phoneNumber,
  });

  final String id;
  final String name;
  final String? avatarUrl;
  final String? phoneNumber;

  factory ChatUser.fromJson(Map<String, dynamic> json) {
    return ChatUser(
      id: (json['id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      avatarUrl: (json['avatarUrl'] as String?)?.trim().isEmpty == true
          ? null
          : (json['avatarUrl'] as String?),
      phoneNumber: (json['phoneNumber'] as String?)?.trim().isEmpty == true
          ? null
          : (json['phoneNumber'] as String?),
    );
  }
}

class ChatMessagePreview {
  const ChatMessagePreview({
    required this.text,
  });

  final String text;

  factory ChatMessagePreview.fromJson(Map<String, dynamic> json) {
    return ChatMessagePreview(
      text: (json['text'] ?? '').toString(),
    );
  }
}

class ChatListingPreview {
  const ChatListingPreview({
    required this.id,
    required this.title,
    required this.priceText,
    required this.imageUrl,
  });

  final String id;
  final String title;
  final String priceText;
  final String? imageUrl;

  factory ChatListingPreview.fromJson(Map<String, dynamic> json) {
    return ChatListingPreview(
      id: (json['id'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      priceText: (json['priceText'] ?? '').toString(),
      imageUrl: (json['imageUrl'] as String?)?.trim().isEmpty == true
          ? null
          : (json['imageUrl'] as String?),
    );
  }
}


