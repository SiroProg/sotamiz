import 'dart:io';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:record/record.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

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
  final AudioRecorder _audioRecorder = AudioRecorder();
  final FocusNode _focusNode = FocusNode();
  bool _isRecording = false;
  bool _hasText = false;
  Duration _recordingDuration = Duration.zero;
  ChatMessage? _replyingTo;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _hasText = _controller.text.trim().isNotEmpty;
      });
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatMessagesProvider>().loadInitial(widget.threadId);
    });
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    await [
      Permission.camera,
      Permission.photos,
      Permission.microphone,
    ].request();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _audioRecorder.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _makePhoneCall(String? phoneNumber) async {
    if (phoneNumber == null || phoneNumber.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Номер телефона не указан')));
      return;
    }

    final uri = Uri.parse('tel:$phoneNumber');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Не удалось совершить звонок')),
        );
      }
    }
  }

  void _showMessageActions(BuildContext context, ChatMessage message) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF16161A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _MessageActionsSheet(
        message: message,
        onReply: () {
          Navigator.pop(context);
          setState(() {
            _replyingTo = message;
          });
          // Открываем клавиатуру при ответе
          Future.delayed(const Duration(milliseconds: 300), () {
            _focusNode.requestFocus();
          });
        },
        onCopy: () {
          Navigator.pop(context);
          _copyMessage(message);
        },
        onDelete: () {
          Navigator.pop(context);
          _deleteMessage(message);
        },
      ),
    );
  }

  void _copyMessage(ChatMessage message) {
    String textToCopy = '';
    if (message.type == ChatMessageType.text) {
      textToCopy = message.text;
    } else if (message.type == ChatMessageType.image) {
      textToCopy = '[Фото]';
    } else if (message.type == ChatMessageType.voice) {
      textToCopy = '[Голосовое сообщение]';
    }
    Clipboard.setData(ClipboardData(text: textToCopy));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Скопировано'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _deleteMessage(ChatMessage message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF16161A),
        title: const Text(
          'Удалить сообщение?',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Это действие нельзя отменить.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Отмена',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement delete message in provider
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Сообщение удалено')),
              );
            },
            child: const Text('Удалить', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);
    if (image != null) {
      try {
        await context.read<ChatMessagesProvider>().sendImage(
          widget.threadId,
          image.path,
        );
        if (mounted) {
          _scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Ошибка отправки фото: $e')));
        }
      }
    }
  }

  Future<void> _showImageSourceDialog() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF16161A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.white),
              title: const Text(
                'Сделать фото',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.white),
              title: const Text(
                'Выбрать из галереи',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _startRecording() async {
    if (await _audioRecorder.hasPermission()) {
      final path = await _getRecordingPath();
      await _audioRecorder.start(const RecordConfig(), path: path);
      setState(() {
        _isRecording = true;
        _recordingDuration = Duration.zero;
      });
      _startRecordingTimer();
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Нет разрешения на запись')),
        );
      }
    }
  }

  Future<void> _stopRecording({bool send = true}) async {
    final path = await _audioRecorder.stop();
    final duration = _recordingDuration;
    setState(() {
      _isRecording = false;
      _recordingDuration = Duration.zero;
    });
    if (send && path != null) {
      try {
        await context.read<ChatMessagesProvider>().sendVoiceMessage(
          widget.threadId,
          path,
          duration: duration,
        );
        if (mounted) {
          _scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Ошибка отправки голосового сообщения: $e')),
          );
        }
      }
    }
  }

  Future<String> _getRecordingPath() async {
    final directory = Directory.systemTemp;
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return '${directory.path}/audio_$timestamp.m4a';
  }

  void _startRecordingTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (_isRecording && mounted) {
        setState(() {
          _recordingDuration = Duration(
            seconds: _recordingDuration.inSeconds + 1,
          );
        });
        _startRecordingTimer();
      }
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
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
            IconButton(
              onPressed: () => context.go('/chats'),
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            const SizedBox(width: 8),
            if (thread != null)
              CircleAvatar(
                backgroundImage: thread.peer.avatarUrl != null
                    ? NetworkImage(thread.peer.avatarUrl!)
                    : null,
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
            onPressed: () => _makePhoneCall(thread?.peer.phoneNumber),
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
                    final nearBottom =
                        n.metrics.pixels < 180; // top since reversed
                    if (nearBottom) {
                      provider.loadMore(widget.threadId);
                    }
                    // Скрываем клавиатуру при скролле
                    if (n is ScrollUpdateNotification) {
                      _focusNode.unfocus();
                    }
                    return false;
                  },
                  child: ListView.builder(
                    controller: _scrollController,
                    reverse: true,
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                    itemCount: provider.messages.length,
                    itemBuilder: (context, index) {
                      final message = provider.messages.reversed
                          .toList()[index]; // reversed for bottom-to-top
                      return _Bubble(
                        message: message,
                        allMessages: provider.messages,
                        peerName: thread?.peer.name ?? 'Пользователь',
                        onLongPress: () =>
                            _showMessageActions(context, message),
                      );
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
                child: CircularProgressIndicator(
                  strokeWidth: 2.3,
                  color: Colors.white70,
                ),
              ),
            ),
          _QuickReplies(
            onTap: (text) {
              _controller.text = text;
              _controller.selection = TextSelection.fromPosition(
                TextPosition(offset: text.length),
              );
            },
          ),
          if (_replyingTo != null)
            _ReplyPreview(
              message: _replyingTo!,
              onCancel: () {
                setState(() {
                  _replyingTo = null;
                });
              },
            ),
          _InputBar(
            controller: _controller,
            focusNode: _focusNode,
            isRecording: _isRecording,
            hasText: _hasText,
            recordingDuration: _recordingDuration,
            onSend: () async {
              final text = _controller.text.trim();
              if (text.isEmpty) return;
              await provider.send(
                widget.threadId,
                text,
                replyToId: _replyingTo?.id,
              );
              _controller.clear();
              setState(() {
                _replyingTo = null;
              });
              _scrollController.animateTo(
                0,
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOut,
              );
            },
            onImageTap: _showImageSourceDialog,
            onVoiceStart: _startRecording,
            onVoiceStop: _stopRecording,
            formatDuration: _formatDuration,
          ),
        ],
      ),
    );
  }
}

class _QuickReplies extends StatelessWidget {
  const _QuickReplies({required this.onTap});

  final ValueChanged<String> onTap;

  final List<String> _quickReplies = const [
    'Да, доступно',
    'Лучшая цена?',
    'Встретимся сегодня',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _quickReplies.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => onTap(_quickReplies[index]),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF16161A),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: Text(
                _quickReplies[index],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({
    required this.message,
    required this.allMessages,
    required this.peerName,
    required this.onLongPress,
  });
  final ChatMessage message;
  final List<ChatMessage> allMessages;
  final String peerName;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context) {
    final isMine = message.isMine;
    final bg = isMine ? const Color(0xFF5E17EB) : const Color(0xFF16161A);
    final align = isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final radius = BorderRadius.only(
      topLeft: const Radius.circular(18),
      topRight: const Radius.circular(18),
      bottomLeft: isMine ? const Radius.circular(18) : const Radius.circular(6),
      bottomRight: isMine
          ? const Radius.circular(6)
          : const Radius.circular(18),
    );

    return GestureDetector(
      onLongPress: onLongPress,
      child: Padding(
        padding: EdgeInsets.fromLTRB(isMine ? 60 : 12, 8, isMine ? 12 : 60, 8),
        child: Column(
          crossAxisAlignment: align,
          children: [
            Container(
              decoration: BoxDecoration(color: bg, borderRadius: radius),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (message.replyToId != null) ...[
                    _ReplyQuote(
                      replyToId: message.replyToId!,
                      allMessages: allMessages,
                      peerName: peerName,
                      isMine: isMine,
                    ),
                    const SizedBox(height: 8),
                  ],
                  message.type == ChatMessageType.voice
                      ? _VoiceMessagePlayer(message: message, isMine: isMine)
                      : message.type == ChatMessageType.image
                      ? _ImageMessage(imagePath: message.imagePath ?? '')
                      : Text(
                          message.text,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            height: 1.35,
                          ),
                        ),
                ],
              ),
            ),
            if (message.type != ChatMessageType.voice) ...[
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _formatTime(message.createdAt),
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.55),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (isMine) ...[
                    const SizedBox(width: 4),
                    const Icon(Icons.done_all, size: 14, color: Colors.white70),
                  ],
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _VoiceMessagePlayer extends StatefulWidget {
  const _VoiceMessagePlayer({required this.message, required this.isMine});

  final ChatMessage message;
  final bool isMine;

  @override
  State<_VoiceMessagePlayer> createState() => _VoiceMessagePlayerState();
}

class _VoiceMessagePlayerState extends State<_VoiceMessagePlayer> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _totalDuration = widget.message.duration ?? const Duration(seconds: 0);
    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          _isPlaying = state == PlayerState.playing;
          if (state == PlayerState.completed) {
            _currentPosition = Duration.zero;
            _isPlaying = false;
          }
        });
      }
    });
    _audioPlayer.onDurationChanged.listen((duration) {
      if (mounted) {
        setState(() {
          if (duration.inSeconds > 0) {
            _totalDuration = duration;
          }
        });
      }
    });
    _audioPlayer.onPositionChanged.listen((position) {
      if (mounted) {
        setState(() {
          _currentPosition = position;
        });
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _togglePlay() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      if (widget.message.audioPath != null) {
        if (_currentPosition >= _totalDuration ||
            _currentPosition == Duration.zero) {
          _currentPosition = Duration.zero;
          await _audioPlayer.play(DeviceFileSource(widget.message.audioPath!));
        } else {
          await _audioPlayer.resume();
        }
      }
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final progress = _totalDuration.inSeconds > 0
        ? _currentPosition.inSeconds / _totalDuration.inSeconds
        : 0.0;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: _togglePlay,
          child: Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(
              _isPlaying ? Icons.pause : Icons.play_arrow,
              color: widget.isMine
                  ? const Color(0xFF5E17EB)
                  : const Color(0xFF16161A),
              size: 20,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Waveform(progress: progress, isMine: widget.isMine),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _isPlaying
                        ? '${_formatDuration(_currentPosition)} / ${_formatDuration(_totalDuration)}'
                        : _formatDuration(_totalDuration),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _formatMessageTime(widget.message.createdAt),
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (widget.isMine) ...[
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.done_all,
                          size: 14,
                          color: Colors.white70,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Waveform extends StatelessWidget {
  const _Waveform({required this.progress, required this.isMine});

  final double progress;
  final bool isMine;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(40, (index) {
          final isActive = (index / 40) < progress;
          final random = (index * 7) % 11;
          final height = 3.0 + random * 1.5;
          return Container(
            width: 2.5,
            height: height,
            margin: const EdgeInsets.symmetric(horizontal: 0.5),
            decoration: BoxDecoration(
              color: isActive ? Colors.white : Colors.white.withOpacity(0.5),
              borderRadius: BorderRadius.circular(1.25),
            ),
          );
        }),
      ),
    );
  }
}

class _ImageMessage extends StatelessWidget {
  const _ImageMessage({required this.imagePath});

  final String imagePath;

  bool get _isNetworkImage =>
      imagePath.startsWith('http://') || imagePath.startsWith('https://');

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showFullScreenImage(context, imagePath),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: _isNetworkImage
            ? Image.network(
                imagePath,
                width: 200,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 200,
                    height: 200,
                    color: Colors.grey[800],
                    child: const Icon(
                      Icons.broken_image,
                      color: Colors.white70,
                    ),
                  );
                },
              )
            : Image.file(
                File(imagePath),
                width: 200,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 200,
                    height: 200,
                    color: Colors.grey[800],
                    child: const Icon(
                      Icons.broken_image,
                      color: Colors.white70,
                    ),
                  );
                },
              ),
      ),
    );
  }

  void _showFullScreenImage(BuildContext context, String imagePath) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => _FullScreenImageView(imagePath: imagePath),
        fullscreenDialog: true,
      ),
    );
  }
}

class _FullScreenImageView extends StatelessWidget {
  const _FullScreenImageView({required this.imagePath});

  final String imagePath;

  bool get _isNetworkImage =>
      imagePath.startsWith('http://') || imagePath.startsWith('https://');

  Future<void> _saveImage(BuildContext context) async {
    try {
      if (_isNetworkImage) {
        // Для сетевых изображений нужно сначала скачать
        final dio = Dio();
        final response = await dio.get<List<int>>(
          imagePath,
          options: Options(responseType: ResponseType.bytes),
        );
        if (response.data != null) {
          final result = await ImageGallerySaver.saveImage(
            Uint8List.fromList(response.data!),
            quality: 100,
          );
          if (result['isSuccess'] == true && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Фото сохранено в галерею'),
                duration: Duration(seconds: 2),
              ),
            );
          } else if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Не удалось сохранить фото'),
                duration: Duration(seconds: 2),
              ),
            );
          }
        }
      } else {
        final result = await ImageGallerySaver.saveFile(imagePath);
        if (result['isSuccess'] == true && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Фото сохранено в галерею'),
              duration: Duration(seconds: 2),
            ),
          );
        } else if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Не удалось сохранить фото'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка: $e'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: InteractiveViewer(
              minScale: 0.5,
              maxScale: 4.0,
              child: _isNetworkImage
                  ? Image.network(
                      imagePath,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(
                            Icons.broken_image,
                            color: Colors.white70,
                            size: 64,
                          ),
                        );
                      },
                    )
                  : Image.file(
                      File(imagePath),
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(
                            Icons.broken_image,
                            color: Colors.white70,
                            size: 64,
                          ),
                        );
                      },
                    ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.black54,
                        ),
                      ),
                      IconButton(
                        onPressed: () => _saveImage(context),
                        icon: const Icon(Icons.download, color: Colors.white),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InputBar extends StatefulWidget {
  const _InputBar({
    required this.controller,
    required this.focusNode,
    required this.onSend,
    required this.onImageTap,
    required this.onVoiceStart,
    required this.onVoiceStop,
    required this.formatDuration,
    required this.isRecording,
    required this.hasText,
    required this.recordingDuration,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onSend;
  final VoidCallback onImageTap;
  final VoidCallback onVoiceStart;
  final Future<void> Function({bool send}) onVoiceStop;
  final String Function(Duration) formatDuration;
  final bool isRecording;
  final bool hasText;
  final Duration recordingDuration;

  @override
  State<_InputBar> createState() => _InputBarState();
}

class _InputBarState extends State<_InputBar> {
  bool _isPressing = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF0B0B0C),
          border: Border(
            top: BorderSide(color: Colors.white.withOpacity(0.08), width: 1),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.isRecording)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                color: const Color(0xFF16161A),
                child: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.formatDuration(widget.recordingDuration),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () => widget.onVoiceStop(send: false),
                      child: const Text(
                        'Отменить',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () => widget.onVoiceStop(send: true),
                      icon: const Icon(Icons.send, color: Colors.white),
                      style: IconButton.styleFrom(
                        backgroundColor: const Color(0xFF5E17EB),
                      ),
                    ),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              child: Row(
                children: [
                  IconButton(
                    onPressed: widget.isRecording ? null : widget.onImageTap,
                    icon: Icon(
                      Icons.attach_file,
                      color: widget.isRecording
                          ? Colors.white.withOpacity(0.3)
                          : Colors.white70,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: widget.controller,
                      focusNode: widget.focusNode,
                      enabled: !widget.isRecording,
                      minLines: 1,
                      maxLines: 4,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: widget.isRecording
                            ? 'Запись голосового сообщения...'
                            : 'Сообщение',
                        hintStyle: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                        ),
                        filled: true,
                        fillColor: const Color(0xFF16161A),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(
                            color: Colors.white.withOpacity(0.08),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(
                            color: Colors.white.withOpacity(0.08),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            color: Color(0xFF5E17EB),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (widget.hasText || widget.isRecording)
                    IconButton.filled(
                      style: IconButton.styleFrom(
                        backgroundColor: const Color(0xFF5E17EB),
                      ),
                      onPressed: widget.isRecording
                          ? () => widget.onVoiceStop(send: true)
                          : widget.onSend,
                      icon: Icon(
                        widget.isRecording ? Icons.send : Icons.send,
                        color: Colors.white,
                      ),
                    )
                  else
                    GestureDetector(
                      onLongPressStart: (_) {
                        setState(() => _isPressing = true);
                        widget.onVoiceStart();
                      },
                      onLongPressEnd: (_) {
                        setState(() => _isPressing = false);
                        widget.onVoiceStop(send: true);
                      },
                      onLongPressCancel: () {
                        setState(() => _isPressing = false);
                        widget.onVoiceStop(send: false);
                      },
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: _isPressing
                              ? const Color(0xFF5E17EB).withOpacity(0.7)
                              : const Color(0xFF5E17EB),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.mic, color: Colors.white),
                      ),
                    ),
                ],
              ),
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
            Icon(
              Icons.wifi_off,
              color: Colors.white.withOpacity(0.8),
              size: 44,
            ),
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

class _ReplyQuote extends StatelessWidget {
  const _ReplyQuote({
    required this.replyToId,
    required this.allMessages,
    required this.peerName,
    required this.isMine,
  });

  final String replyToId;
  final List<ChatMessage> allMessages;
  final String peerName;
  final bool isMine;

  @override
  Widget build(BuildContext context) {
    final repliedMessage = allMessages.firstWhere(
      (m) => m.id == replyToId,
      orElse: () => ChatMessage(
        id: '',
        threadId: '',
        text: 'Сообщение удалено',
        createdAt: DateTime.now(),
        isMine: false,
      ),
    );

    String quoteText = '';
    if (repliedMessage.type == ChatMessageType.text) {
      quoteText = repliedMessage.text;
    } else if (repliedMessage.type == ChatMessageType.image) {
      quoteText = 'Фото';
    } else if (repliedMessage.type == ChatMessageType.voice) {
      quoteText = 'Голосовое сообщение';
    }

    final senderName = repliedMessage.isMine ? 'Вы' : peerName;

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border(
          left: BorderSide(
            color: isMine
                ? Colors.white.withOpacity(0.5)
                : const Color(0xFF5E17EB),
            width: 3,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            senderName,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            quoteText,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _ReplyPreview extends StatelessWidget {
  const _ReplyPreview({required this.message, required this.onCancel});

  final ChatMessage message;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    String previewText = '';
    if (message.type == ChatMessageType.text) {
      previewText = message.text;
    } else if (message.type == ChatMessageType.image) {
      previewText = 'Фото';
    } else if (message.type == ChatMessageType.voice) {
      previewText = 'Голосовое сообщение';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF16161A),
        border: Border(
          left: BorderSide(
            color: message.isMine
                ? const Color(0xFF5E17EB)
                : Colors.white.withOpacity(0.3),
            width: 3,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message.isMine ? 'Вы' : 'Отвечаете',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  previewText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onCancel,
            icon: const Icon(Icons.close, color: Colors.white70, size: 20),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}

class _MessageActionsSheet extends StatelessWidget {
  const _MessageActionsSheet({
    required this.message,
    required this.onReply,
    required this.onCopy,
    required this.onDelete,
  });

  final ChatMessage message;
  final VoidCallback onReply;
  final VoidCallback onCopy;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.reply, color: Colors.white),
              title: const Text(
                'Ответить',
                style: TextStyle(color: Colors.white),
              ),
              onTap: onReply,
            ),
            ListTile(
              leading: const Icon(Icons.copy, color: Colors.white),
              title: const Text(
                'Копировать',
                style: TextStyle(color: Colors.white),
              ),
              onTap: onCopy,
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Удалить', style: TextStyle(color: Colors.red)),
              onTap: onDelete,
            ),
            const SizedBox(height: 8),
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

String _formatMessageTime(DateTime dt) {
  final hh = dt.hour.toString().padLeft(2, '0');
  final mm = dt.minute.toString().padLeft(2, '0');
  return '$hh:$mm';
}
