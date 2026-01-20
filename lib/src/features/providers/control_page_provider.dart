// import 'package:elk_mobile/src/features/screens/chat/chat_screen.dart';
// import 'package:elk_mobile/src/features/screens/home/home_screen.dart';
// import 'package:elk_mobile/src/features/screens/notification/notification_screen.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:elk_mobile/src/features/screens/profile/profile_screen.dart';
//
// enum Pages {
//   home('home'),
//   chat('chat'),
//   notification('notification'),
//   menu('menu');
//
//   const Pages(this.key);
//   final String key;
// }
//
// class PageControlProvider extends ChangeNotifier {
//   int currentIndex = 0;
//   List<Widget> pages = [];
//
//   PageController pageController = PageController();
//
//   List<Widget> home = [const HomeScreen()];
//   List<Widget> chat = [const ChatScreen()];
//   List<Widget> notification = [const NotificationScreen()];
//   List<Widget> menu = [const ProfileScreen()];
//
//   void onBottomNavTapped(int index) {
//     pageController.jumpToPage(index);
//     currentIndex = index;
//     notifyListeners();
//   }
//
//   void changeIndex(int index) {
//     currentIndex = index;
//     notifyListeners();
//   }
//
//   void initialize() {
//     pages = [home.last, chat.last, notification.last, menu.last];
//     notifyListeners();
//   }
//
//   void push({required Pages page, required Widget screen}) {
//     if (page.key == Pages.home.key) {
//       home.add(screen);
//     } else if (page.key == Pages.chat.key) {
//       chat.add(screen);
//     } else if (page.key == Pages.notification.key) {
//       notification.add(screen);
//     } else if (page.key == Pages.menu.key) {
//       menu.add(screen);
//     }
//     initialize();
//   }
//
//   void pop(Pages page) {
//     if (page.key == Pages.home.key) {
//       home.removeLast();
//     } else if (page.key == Pages.chat.key) {
//       chat.removeLast();
//     } else if (page.key == Pages.notification.key) {
//       notification.removeLast();
//     } else if (page.key == Pages.menu.key) {
//       menu.removeLast();
//     }
//     initialize();
//   }
//
//   void willPop() {
//     if (currentIndex == 0 && home.length > 1) {
//       home.removeLast();
//     } else if (currentIndex == 1 && chat.length > 1) {
//       chat.removeLast();
//     } else if (currentIndex == 2 && notification.length > 1) {
//       notification.removeLast();
//     } else if (currentIndex == 3 && menu.length > 1) {
//       menu.removeLast();
//     } else {
//       onBottomNavTapped(0);
//     }
//     initialize();
//   }
//
//   void clear(int index) {
//     if (index == 0) {
//       home = [const HomeScreen()];
//     } else if (index == 1) {
//       chat = [const ChatScreen()];
//     } else if (index == 2) {
//       notification = [const NotificationScreen()];
//     } else if (index == 3) {
//       menu = [const ProfileScreen()];
//     }
//     initialize();
//   }
// }
import 'package:flutter/cupertino.dart';

class PageControlProvider extends ChangeNotifier {
  int currentIndex = 0;
  final PageController pageController = PageController();

  void changeIndex(int index) {
    currentIndex = index;
    notifyListeners();
  }

  void onBottomNavTapped(int index, BuildContext context) {
    changeIndex(index);
  }
}
