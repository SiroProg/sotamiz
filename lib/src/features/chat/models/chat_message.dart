enum ChatMessageType { text, image, voice }

class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.threadId,
    required this.text,
    required this.createdAt,
    required this.isMine,
    this.type = ChatMessageType.text,
    this.audioPath,
    this.imagePath,
    this.duration,
    this.replyToId,
    this.replyTo,
  });

  final String id;
  final String threadId;
  final String text;
  final DateTime createdAt;
  final bool isMine;
  final ChatMessageType type;
  final String? audioPath;
  final String? imagePath;
  final Duration? duration;
  final String? replyToId;
  final ChatMessage? replyTo;

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    final messageType = json['type']?.toString();
    ChatMessageType type = ChatMessageType.text;
    if (messageType == 'voice' || json['audioPath'] != null) {
      type = ChatMessageType.voice;
    } else if (messageType == 'image' || json['imagePath'] != null) {
      type = ChatMessageType.image;
    }

    Duration? duration;
    if (json['duration'] != null) {
      final seconds = (json['duration'] as num?)?.toInt();
      if (seconds != null) {
        duration = Duration(seconds: seconds);
      }
    }

    return ChatMessage(
      id: (json['id'] ?? '').toString(),
      threadId: (json['threadId'] ?? '').toString(),
      text: (json['text'] ?? '').toString(),
      createdAt:
          DateTime.tryParse((json['createdAt'] ?? '').toString()) ??
          DateTime.fromMillisecondsSinceEpoch(0),
      isMine: json['isMine'] == true,
      type: type,
      audioPath: json['audioPath']?.toString(),
      imagePath: json['imagePath']?.toString(),
      duration: duration,
      replyToId: json['replyToId']?.toString(),
      replyTo: json['replyTo'] != null
          ? ChatMessage.fromJson(json['replyTo'] as Map<String, dynamic>)
          : null,
    );
  }
}
