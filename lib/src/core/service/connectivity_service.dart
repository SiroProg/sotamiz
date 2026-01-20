// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter/material.dart';
// import '../utils/logger.dart';
// import 'package:dio/dio.dart';
// import 'dart:async';

// class ConnectivityService {
//   final Connectivity _connectivity = Connectivity();
//   final Dio _dio = Dio();
//   late StreamSubscription _subscription;
//   bool _isDialogOpen = false;

//   ConnectivityService._internal();

//   static final ConnectivityService _instance = ConnectivityService._internal();
//   static ConnectivityService get instance => _instance;

//   void initialize(GlobalKey<NavigatorState> navigatorKey) {
//     info('ConnectivityService initialized');
//     _subscription = _connectivity.onConnectivityChanged.listen(
//       (event) async {
//         info('Connectivity changed: ');
//         if (event.first == ConnectivityResult.none) {
//           if (!_isDialogOpen) {
//             _showNoInternetScreen(navigatorKey);
//           }
//         } else {
//           final hasInternetAccess = await _checkInternetAccess();
//           if (!hasInternetAccess) {
//             if (!_isDialogOpen) {
//               _showNoInternetScreen(navigatorKey);
//             }
//           } else if (_isDialogOpen) {
//             _hideNoInternetScreen(navigatorKey);
//           }
//         }
//       },
//     );
//     info('ConnectivityService subscription started');
//   }

//   Future<bool> _checkInternetAccess() async {
//     try {
//       final response = await _dio.get(
//         'https://www.google.com',
//         options: Options(
//           receiveTimeout: const Duration(seconds: 5),
//         ),
//       );
//       return response.statusCode == 200;
//     } catch (e) {
//       return false;
//     }
//   }

//   void _showNoInternetScreen(GlobalKey<NavigatorState> navigatorKey) {
//     _isDialogOpen = true;
//     Navigator.push(
//       navigatorKey.currentState!.context,
//       PageRouteBuilder(
//         pageBuilder: (context, animation, secondaryAnimation) =>
//             const NoInternetScreen(),
//         transitionsBuilder: (context, animation, secondaryAnimation, child) {
//           const begin = Offset(0.0, 1.0);
//           const end = Offset.zero;
//           const curve = Curves.easeInOut;

//           var tween =
//               Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
//           var offsetAnimation = animation.drive(tween);

//           return SlideTransition(position: offsetAnimation, child: child);
//         },
//       ),
//     );
//   }

//   void _hideNoInternetScreen(GlobalKey<NavigatorState> navigatorKey) {
//     _isDialogOpen = false;
//     Navigator.pop(
//       navigatorKey.currentState!.context,
//       PageRouteBuilder(
//         pageBuilder: (context, animation, secondaryAnimation) =>
//             const NoInternetScreen(),
//         transitionsBuilder: (context, animation, secondaryAnimation, child) {
//           const begin = Offset(0.0, -1.0);
//           const end = Offset.zero;
//           const curve = Curves.easeInOut;

//           var tween =
//               Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
//           var offsetAnimation = animation.drive(tween);

//           return SlideTransition(position: offsetAnimation, child: child);
//         },
//       ),
//     );
//   }

//   void dispose() {
//     _subscription.cancel();
//   }
// }
