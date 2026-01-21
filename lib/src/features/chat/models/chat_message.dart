class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.threadId,
    required this.text,
    required this.createdAt,
    required this.isMine,
  });

  final String id;
  final String threadId;
  final String text;
  final DateTime createdAt;
  final bool isMine;

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: (json['id'] ?? '').toString(),
      threadId: (json['threadId'] ?? '').toString(),
      text: (json['text'] ?? '').toString(),
      createdAt:
          DateTime.tryParse((json['createdAt'] ?? '').toString()) ??
          DateTime.fromMillisecondsSinceEpoch(0),
      isMine: json['isMine'] == true,
    );
  }
}
