import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../chat/models/chat_message.dart';
import '../../chat/models/chat_thread.dart';
import '../../providers/chat_messages_provider.dart';

class ChatDetailScreen extends StatefulWidget {
  const ChatDetailScreen({
    super.key,
    required this.threadId,
    this.initialThread,
  });

  final String threadId;
  final ChatThread? initialThread;

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatMessagesProvider>().loadInitial(widget.threadId);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ChatMessagesProvider>();
    final thread = widget.initialThread;

    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0C),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B0B0C),
        foregroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 0,
        title: Row(
          children: [
            if (thread != null)
              CircleAvatar(
                backgroundImage:
                    thread.peer.avatarUrl != null ? NetworkImage(thread.peer.avatarUrl!) : null,
                backgroundColor: const Color(0xFF1A1A1D),
              ),
            if (thread != null) const SizedBox(width: 10),
            Text(
              thread?.peer.name ?? 'Чат',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.call_outlined, color: Colors.white),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert, color: Colors.white),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Builder(
              builder: (context) {
                if (provider.status == ChatMessagesStatus.loading) {
                  return const _Loading();
                }
                if (provider.status == ChatMessagesStatus.error) {
                  return _ErrorState(
                    message: provider.errorMessage ?? 'Ошибка',
                    onRetry: () => provider.loadInitial(widget.threadId),
                  );
                }
                return NotificationListener<ScrollNotification>(
                  onNotification: (n) {
                    if (n.metrics.maxScrollExtent <= 0) return false;
                    final nearBottom = n.metrics.pixels < 180; // top since reversed
                    if (nearBottom) {
                      provider.loadMore(widget.threadId);
                    }
                    return false;
                  },
                  child: ListView.builder(
                    controller: _scrollController,
                    reverse: true,
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                    itemCount: provider.messages.length,
                    itemBuilder: (context, index) {
                      final message =
                          provider.messages.reversed.toList()[index]; // reversed for bottom-to-top
                      return _Bubble(message: message);
                    },
                  ),
                );
              },
            ),
          ),
          if (provider.isLoadingMore)
            const Padding(
              padding: EdgeInsets.only(bottom: 6),
              child: SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(strokeWidth: 2.3, color: Colors.white70),
              ),
            ),
          _InputBar(
            controller: _controller,
            onSend: () async {
              final text = _controller.text.trim();
              if (text.isEmpty) return;
              await provider.send(widget.threadId, text);
              _controller.clear();
              _scrollController.animateTo(
                0,
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOut,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.message});
  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final isMine = message.isMine;
    final bg = isMine ? const Color(0xFF5E17EB) : const Color(0xFF16161A);
    final align = isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final radius = BorderRadius.only(
      topLeft: const Radius.circular(18),
      topRight: const Radius.circular(18),
      bottomLeft: isMine ? const Radius.circular(18) : const Radius.circular(6),
      bottomRight: isMine ? const Radius.circular(6) : const Radius.circular(18),
    );

    return Padding(
      padding: EdgeInsets.fromLTRB(isMine ? 60 : 12, 8, isMine ? 12 : 60, 8),
      child: Column(
        crossAxisAlignment: align,
        children: [
          Container(
            decoration: BoxDecoration(
              color: bg,
              borderRadius: radius,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Text(
              message.text,
              style: const TextStyle(color: Colors.white, fontSize: 16, height: 1.35),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _formatTime(message.createdAt),
            style: TextStyle(
              color: Colors.white.withOpacity(0.55),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _InputBar extends StatelessWidget {
  const _InputBar({required this.controller, required this.onSend});
  final TextEditingController controller;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
        child: Row(
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.emoji_emotions_outlined, color: Colors.white70),
            ),
            Expanded(
              child: TextField(
                controller: controller,
                minLines: 1,
                maxLines: 4,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Сообщение',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                  filled: true,
                  fillColor: const Color(0xFF16161A),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: Colors.white.withOpacity(0.08)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: Colors.white.withOpacity(0.08)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xFF5E17EB)),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filled(
              style: IconButton.styleFrom(
                backgroundColor: const Color(0xFF5E17EB),
              ),
              onPressed: onSend,
              icon: const Icon(Icons.send, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(color: Colors.white70),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off, color: Colors.white.withOpacity(0.8), size: 44),
            const SizedBox(height: 12),
            Text(
              'Не удалось загрузить сообщения',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
              ),
              onPressed: onRetry,
              child: const Text('Повторить'),
            ),
          ],
        ),
      ),
    );
  }
}

String _formatTime(DateTime dt) {
  final now = DateTime.now();
  if (dt.day == now.day && dt.month == now.month && dt.year == now.year) {
    final hh = dt.hour.toString().padLeft(2, '0');
    final mm = dt.minute.toString().padLeft(2, '0');
    return '$hh:$mm';
  }
  return '${dt.day}.${dt.month}.${dt.year}';
}

