import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../providers/chat_list_provider.dart';
import 'models/chat_thread.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ChatListProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0C),
      body: SafeArea(
        child: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF111115), Color(0xFF0B0B0C)],
            ),
          ),
          child: Column(
            children: [
              _Header(total: provider.threads.length),
              Expanded(
                child: Builder(
                  builder: (context) {
                    if (provider.status == LoadStatus.loading) {
                      return const _LoadingList();
                    }

                    if (provider.status == LoadStatus.error) {
                      return _ErrorState(
                        message: provider.errorMessage ?? 'Ошибка загрузки',
                        onRetry: provider.loadInitial,
                      );
                    }

                    if (provider.threads.isEmpty) {
                      return const _EmptyState();
                    }

                    return RefreshIndicator(
                      onRefresh: provider.refresh,
                      color: Colors.white,
                      backgroundColor: const Color(0xFF1A1A1D),
                      child: NotificationListener<ScrollNotification>(
                        onNotification: (n) {
                          if (n.metrics.maxScrollExtent <= 0) return false;
                          final nearBottom =
                              n.metrics.pixels >
                              (n.metrics.maxScrollExtent - 220);
                          if (nearBottom) {
                            provider.loadMore();
                          }
                          return false;
                        },
                        child: ListView.separated(
                          padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
                          itemBuilder: (context, index) {
                            if (index == provider.threads.length) {
                              return provider.isLoadingMore
                                  ? const _LoadMoreIndicator()
                                  : const SizedBox.shrink();
                            }
                            return _ChatCard(thread: provider.threads[index]);
                          },
                          separatorBuilder: (_, __) => SizedBox(height: 12.h),
                          itemCount: provider.threads.length + 1,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.total});

  final int total;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Сообщения',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: Colors.white,
                  fontSize: 32.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.search, color: Colors.white, size: 22.r),
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFF17171A),
                  padding: EdgeInsets.all(12.w),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          Text(
            '$total активных диалогов',
            style: TextStyle(
              color: Colors.white.withOpacity(0.65),
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatCard extends StatelessWidget {
  const _ChatCard({required this.thread});

  final ChatThread thread;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18.r),
      onTap: () => context.go('/chat/${thread.id}', extra: thread),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18.r),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF16161A), Color(0xFF0F0F12)],
          ),
          border: Border.all(color: Colors.white.withOpacity(0.08), width: 1.w),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.35),
              blurRadius: 12.r,
              offset: Offset(0, 8.h),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(14.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Avatar(
                url: thread.peer.avatarUrl,
                isOnline: thread.isPeerOnline,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            thread.peer.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Text(
                          _formatRelativeTime(thread.lastMessageAt),
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.55),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (thread.unreadCount > 0) ...[
                          SizedBox(width: 10.w),
                          _UnreadBadge(count: thread.unreadCount),
                        ],
                      ],
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      thread.lastMessage.text,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.92),
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (thread.listing != null) ...[
                      SizedBox(height: 12.h),
                      _ListingChip(listing: thread.listing!),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ListingChip extends StatelessWidget {
  const _ListingChip({required this.listing});
  final ChatListingPreview listing;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Padding(
        padding: EdgeInsets.all(10.w),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: _NetworkOrPlaceholder(
                url: listing.imageUrl,
                width: 72.w,
                height: 60.h,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    listing.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    listing.priceText,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w800,
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

class _Avatar extends StatelessWidget {
  const _Avatar({required this.url, required this.isOnline});

  final String? url;
  final bool isOnline;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(18.r),
          child: _NetworkOrPlaceholder(url: url, width: 58.w, height: 58.h),
        ),
        Positioned(
          bottom: -2.h,
          right: -2.w,
          child: Container(
            width: 16.r,
            height: 16.r,
            decoration: BoxDecoration(
              color: isOnline
                  ? const Color(0xFF3FE972)
                  : const Color(0xFF2A2A2E),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF0B0B0C), width: 2.w),
            ),
          ),
        ),
      ],
    );
  }
}

class _UnreadBadge extends StatelessWidget {
  const _UnreadBadge({required this.count});
  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Text(
        '$count',
        style: TextStyle(
          color: Colors.black,
          fontSize: 13.sp,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _NetworkOrPlaceholder extends StatelessWidget {
  const _NetworkOrPlaceholder({
    required this.url,
    required this.width,
    required this.height,
  });

  final String? url;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    if (url == null || url!.isEmpty) {
      return Container(
        width: width,
        height: height,
        color: const Color(0xFF1A1A1D),
        alignment: Alignment.center,
        child: Icon(
          Icons.image_outlined,
          color: Colors.white.withOpacity(0.5),
          size: 18.r,
        ),
      );
    }

    return Image.network(
      url!,
      width: width,
      height: height,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Container(
        width: width,
        height: height,
        color: const Color(0xFF1A1A1D),
        alignment: Alignment.center,
        child: Icon(
          Icons.broken_image_outlined,
          color: Colors.white.withOpacity(0.5),
          size: 18.r,
        ),
      ),
    );
  }
}

class _LoadingList extends StatelessWidget {
  const _LoadingList();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
      itemBuilder: (context, index) => const _ShimmerChatCard(),
      separatorBuilder: (_, __) => SizedBox(height: 12.h),
      itemCount: 6,
    );
  }
}

class _ShimmerChatCard extends StatelessWidget {
  const _ShimmerChatCard();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFF1A1A1D),
      highlightColor: const Color(0xFF2A2A2E),
      child: Container(
        height: 116.h,
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1D),
          borderRadius: BorderRadius.circular(18.r),
        ),
      ),
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
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.wifi_off,
              color: Colors.white.withOpacity(0.8),
              size: 44.r,
            ),
            SizedBox(height: 14.h),
            Text(
              'Не удалось загрузить чаты',
              style: TextStyle(
                color: Colors.white.withOpacity(0.95),
                fontSize: 18.sp,
                fontWeight: FontWeight.w800,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              message,
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 16.h),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                padding: EdgeInsets.symmetric(
                  horizontal: 18.w,
                  vertical: 14.h,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.r),
                ),
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

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat_bubble_outline,
              color: Colors.white.withOpacity(0.7),
              size: 44.r,
            ),
            SizedBox(height: 14.h),
            Text(
              'Пока нет сообщений',
              style: TextStyle(
                color: Colors.white.withOpacity(0.95),
                fontSize: 18.sp,
                fontWeight: FontWeight.w800,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              'Когда кто-то напишет вам по объявлению, диалог появится здесь.',
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadMoreIndicator extends StatelessWidget {
  const _LoadMoreIndicator();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10.h),
      child: Center(
        child: SizedBox(
          width: 22.w,
          height: 22.w,
          child: CircularProgressIndicator(
            strokeWidth: 2.4,
            color: Colors.white.withOpacity(0.85),
          ),
        ),
      ),
    );
  }
}

String _formatRelativeTime(DateTime dt) {
  if (dt.millisecondsSinceEpoch == 0) return '';
  final now = DateTime.now();
  final diff = now.difference(dt);
  if (diff.inMinutes < 1) return 'сейчас';
  if (diff.inMinutes < 60) return '${diff.inMinutes}м';
  if (diff.inHours < 24) return '${diff.inHours}ч';
  return '${diff.inDays}д';
}
