import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../constants/api_constants.dart';
import '../service/db_service.dart';
import '../../features/chat/repository/api_chat_repository.dart';
import '../../features/chat/repository/api_chat_message_repository.dart';
import '../../features/chat/repository/mock_chat_repository.dart';
import '../../features/chat/repository/mock_chat_message_repository.dart';
import '../../features/home/repository/api_home_repository.dart';
import '../../features/home/repository/mock_home_repository.dart';
import '../../features/providers/control_page_provider.dart';
import '../../features/providers/chat_list_provider.dart';
import '../../features/providers/chat_messages_provider.dart';
import '../../features/providers/home_provider.dart';
import '../../features/screens/custom_page_control/custom_page_control.dart';
import '../../features/screens/home/home_screen.dart';
import '../../features/screens/chat/chat_list_screen.dart';
import '../../features/screens/chat/chat_detail_screen.dart';
import '../../features/screens/splash/splash_screen.dart';
import '../styles/app_theme_data.dart';
import '../../features/chat/models/chat_thread.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

final GlobalKey<NavigatorState> $navigatorKey = GlobalKey<NavigatorState>();

class _AppState extends State<App> {
  final GoRouter _router = GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
      final isFirstLaunch = DBService.isFirstLaunch;
      final location = state.uri.path;

      // Если не первый запуск и пользователь на splash, перенаправляем на home
      if (!isFirstLaunch && location == '/splash') {
        return '/home';
      }

      // Если первый запуск и пользователь не на splash, разрешаем доступ
      // (splash screen сам обработает переход)
      return null;
    },
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return CustomPageControl(child: child);
        },
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomeScreen(),
            pageBuilder: (context, state) {
              return CustomTransitionPage<void>(
                child: const HomeScreen(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                      return child;
                    },
              );
            },
          ),
          GoRoute(
            path: '/sell',
            builder: (context, state) => Scaffold(),
            pageBuilder: (context, state) {
              return CustomTransitionPage<void>(
                child: const Scaffold(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                      return child;
                    },
              );
            },
          ),
          GoRoute(
            path: '/chats',
            builder: (context, state) => const ChatListScreen(),
            pageBuilder: (context, state) {
              return CustomTransitionPage<void>(
                child: const ChatListScreen(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                      return child;
                    },
              );
            },
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const Scaffold(),
            pageBuilder: (context, state) {
              return CustomTransitionPage<void>(
                child: const Scaffold(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                      return child;
                    },
              );
            },
          ),
        ],
      ),
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/chat/:id',
        builder: (context, state) {
          final thread = state.extra;
          return ChatDetailScreen(
            threadId: state.pathParameters['id'] ?? '',
            initialThread: thread is ChatThread ? thread : null,
          );
        },
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    final chatRepository = ApiConstants.baseUrl.trim().isEmpty
        ? const MockChatRepository()
        : const ApiChatRepository();
    final chatMessageRepository = ApiConstants.baseUrl.trim().isEmpty
        ? const MockChatMessageRepository()
        : const ApiChatMessageRepository();
    final homeRepository = ApiConstants.baseUrl.trim().isEmpty
        ? const MockHomeRepository()
        : const ApiHomeRepository();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PageControlProvider()),
        ChangeNotifierProvider(
          create: (context) =>
              ChatListProvider(repository: chatRepository)..loadInitial(),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              ChatMessagesProvider(repository: chatMessageRepository),
        ),
        ChangeNotifierProvider(
          create: (context) => HomeProvider(repository: homeRepository),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp.router(
            // localizationsDelegates: AppLocalizations.localizationsDelegates,
            // supportedLocales: AppLocalizations.supportedLocales,
            debugShowCheckedModeBanner: false,
            title: '',
            theme: AppThemeData.theme,
            routerConfig: _router,
          );
        },
      ),
    );
  }
}
