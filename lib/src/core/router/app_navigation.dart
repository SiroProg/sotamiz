// import 'package:elk_mobile/src/features/screens/chat/chat_screen.dart';
// import 'package:elk_mobile/src/features/screens/custom_page_control/custom_page_control.dart';
// import 'package:elk_mobile/src/features/screens/home/home_screen.dart';
// import 'package:elk_mobile/src/features/screens/new_auth/auth_screen.dart';
// import 'package:elk_mobile/src/features/screens/notification/notification_screen.dart';
// import 'package:elk_mobile/src/features/screens/profile/profile_screen.dart';
// import 'package:elk_mobile/src/features/screens/splash/splash_screen.dart';
// import 'package:flutter/material.dart';
//
// import 'package:go_router/go_router.dart';
//
// class AppNavigation {
//   AppNavigation._();
//
//   static const String splash = '/splash';
//   static const String auth = '/auth';
//
//   static const String home = '/home';
//   static const String chat = '/chat';
//   static const String notification = '/notification';
//   static const String menu = '/menu';
//
//   static final _rootNavigatorKey = GlobalKey<NavigatorState>();
//   static final _shellNavigatorHome = GlobalKey<NavigatorState>(debugLabel: 'shellHome');
//   static final _shellNavigatorChat = GlobalKey<NavigatorState>(debugLabel: 'shellChat');
//   static final _shellNavigatorNotification = GlobalKey<NavigatorState>(debugLabel: 'shellNotification');
//   static final _shellNavigatorMenu = GlobalKey<NavigatorState>(debugLabel: 'shellMenu');
//
//   static final GoRouter router = GoRouter(
//     initialLocation: splash,
//     debugLogDiagnostics: true,
//     navigatorKey: _rootNavigatorKey,
//     routes: <RouteBase>[
//       StatefulShellRoute.indexedStack(
//         builder: (context, state, navigationShell) {
//           // Control page
//           return const CustomPageControl(
//             child: SizedBox(),
//             // navigationShell: navigationShell,
//           );
//         },
//         branches: <StatefulShellBranch>[
//           StatefulShellBranch(
//             navigatorKey: _shellNavigatorHome,
//             routes: <RouteBase>[
//               GoRoute(
//                 path: home,
//                 name: "home",
//                 builder: (BuildContext context, GoRouterState state) => const HomeScreen(),
//               ),
//             ],
//           ),
//           StatefulShellBranch(
//             navigatorKey: _shellNavigatorChat,
//             routes: <RouteBase>[
//               GoRoute(
//                 path: chat,
//                 name: "Chat",
//                 builder: (BuildContext context, GoRouterState state) => const ChatScreen(),
//               ),
//             ],
//           ),
//           StatefulShellBranch(
//             navigatorKey: _shellNavigatorNotification,
//             routes: <RouteBase>[
//               GoRoute(
//                 path: notification,
//                 name: "Notification",
//                 builder: (BuildContext context, GoRouterState state) => const NotificationScreen(),
//               ),
//             ],
//           ),
//           StatefulShellBranch(
//             navigatorKey: _shellNavigatorMenu,
//             routes: <RouteBase>[
//               GoRoute(
//                 path: menu,
//                 name: "Menu",
//                 builder: (BuildContext context, GoRouterState state) => const ProfileScreen(),
//               ),
//             ],
//           ),
//         ],
//       ),
//       GoRoute(
//         path: splash,
//         name: 'splash',
//         builder: (context, state) => const SplashScreen(),
//       ),
//       GoRoute(
//         path: '/auth',
//         name: 'auth',
//         builder: (context, state) => const AuthScreen(),
//       ),
//     ],
//   );
enum AppNavigation {
  splash('/splash'),
  home('/home');

  const AppNavigation(this.path);
  final String path;
}

// }
