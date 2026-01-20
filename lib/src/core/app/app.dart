import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../features/providers/control_page_provider.dart';
import '../../features/screens/custom_page_control/custom_page_control.dart';
import '../../features/screens/home/home_screen.dart';
import '../../features/screens/splash/splash_screen.dart';
import '../styles/app_theme_data.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

final GlobalKey<NavigatorState> $navigatorKey = GlobalKey<NavigatorState>();

class _AppState extends State<App> {
  final GoRouter _router = GoRouter(
    initialLocation: '/splash',
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return CustomPageControl(child: child);
        },
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => HomeScreen(),
            pageBuilder: (context, state) {
              return CustomTransitionPage<void>(
                child: HomeScreen(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                      return child;
                    },
              );
            },
          ),
          GoRoute(
            path: '/cart',
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
            path: '/orders',
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
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PageControlProvider()),
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
