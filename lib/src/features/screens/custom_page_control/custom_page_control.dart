// import 'dart:io';
//
// import 'package:elk_mobile/src/core/app/app.dart';
// import 'package:elk_mobile/src/core/widgets/icon/app_icon.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:provider/provider.dart';
//
// import '../../../core/styles/app_colors.dart';
// import '../../../core/styles/app_icons.dart';
// import '../../provider/page_control_provider.dart';
// import '../../provider/biometric_provider.dart';
// import 'package:back_button_interceptor/back_button_interceptor.dart';
//
// class CustomPageControl extends StatefulWidget {
//   const CustomPageControl({super.key});
//
//   @override
//   State<CustomPageControl> createState() => _CustomPageControlState();
// }
//
// class _CustomPageControlState extends State<CustomPageControl> {
//   @override
//   void initState() {
//     super.initState();
//
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       BackButtonInterceptor.add(myInterceptor);
//       final controlProvider = Provider.of<PageControlProvider>(context, listen: false);
//       controlProvider.initialize();
//
//       final provider = Provider.of<BiometricProvider>(context, listen: false);
//       provider.checkBiometricAvailability(context);
//     });
//   }
//
//   @override
//   void dispose() {
//     BackButtonInterceptor.remove(myInterceptor);
//     super.dispose();
//   }
//
//   bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
//     final controlProvider = Provider.of<PageControlProvider>(context, listen: false);
//     if (controlProvider.currentIndex == 0) {
//       return false;
//     } else {
//       controlProvider.willPop();
//       return true;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final controlProvider = Provider.of<PageControlProvider>(context);
//     return Consumer<BiometricProvider>(
//       builder: (
//         BuildContext context,
//         BiometricProvider provider,
//         Widget? child,
//       ) =>
//           !provider.isAuthenticated
//               ? const Scaffold()
//               // ignore: deprecated_member_use
//               : WillPopScope(
//                   onWillPop: () async {
//                     if (Navigator.of($navigatorKey.currentState!.context)
//                         .canPop()) {
//                       Navigator.of($navigatorKey.currentState!.context).pop();
//                       return false;
//                     } else if (controlProvider.currentIndex == 0) {
//                       return true;
//                     } else {
//                       controlProvider.willPop();
//                       return false;
//                     }
//                   },
//                   child: GestureDetector(
//                     behavior: HitTestBehavior.opaque,
//                     onHorizontalDragUpdate: (details) {
//                       if (details.primaryDelta! > 20) {
//                         if (controlProvider.currentIndex > 0) {
//                           controlProvider.willPop();
//                         }
//                       }
//                     },
//                     child: Scaffold(
//                       resizeToAvoidBottomInset: false,
//                       body: Column(
//                         children: [
//                           Expanded(
//                             child: PageView(
//                               physics: const NeverScrollableScrollPhysics(),
//                               scrollDirection: Axis.vertical,
//                               onPageChanged: (index) {
//                                 controlProvider.changeIndex(index);
//                               },
//                               controller: controlProvider.pageController,
//                               children: controlProvider.pages,
//                             ),
//                           ),
//                           Divider(
//                             height: 0.h,
//                             color: AppColors.colorFillTertiary,
//                           ),
//                           SizedBox(
//                             width: double.infinity,
//                             height: Platform.isIOS ? 78.h : 65.h,
//                             child: const DecoratedBox(
//                               decoration: BoxDecoration(
//                                 color: AppColors.white,
//                                 borderRadius: BorderRadius.only(
//                                   topLeft: Radius.circular(10),
//                                   topRight: Radius.circular(10),
//                                 ),
//                               ),
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                                 children: [
//                                   NavigateItem(
//                                     icon: AppIcons.mainLogo,
//                                     text: 'Главная',
//                                     index: 0,
//                                   ),
//                                   NavigateItem(
//                                     icon: AppIcons.chatOf,
//                                     text: 'Чат',
//                                     index: 1,
//                                   ),
//                                   NavigateItem(
//                                     icon: AppIcons.settingsNotificationOff,
//                                     text: 'Уведомление',
//                                     index: 2,
//                                   ),
//                                   NavigateItem(
//                                     icon: AppIcons.mainMenu,
//                                     text: 'Меню',
//                                     index: 3,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//     );
//   }
// }
//
// class NavigateItem extends StatelessWidget {
//   final int index;
//   final String icon;
//   final String text;
//   const NavigateItem({
//     super.key,
//     required this.icon,
//     required this.text,
//     required this.index,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final controlProvider = Provider.of<PageControlProvider>(context);
//     return GestureDetector(
//       onTap: () => controlProvider.onBottomNavTapped(index),
//       onDoubleTap: () => controlProvider.clear(index),
//       child: DecoratedBox(
//         decoration: const BoxDecoration(
//           borderRadius: BorderRadius.all(
//             Radius.circular(10),
//           ),
//           color: AppColors.white,
//         ),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(
//             vertical: 10,
//             horizontal: 10,
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               AppIcon(
//                 icon,
//                 size: 20,
//                 color: controlProvider.currentIndex == index ? AppColors.colorInfo : AppColors.colorIcon,
//               ),
//               5.verticalSpace,
//               Text(
//                 text,
//                 style: TextStyle(
//                   color: controlProvider.currentIndex == index ? AppColors.colorInfo : AppColors.colorIcon,
//                   fontSize: 12.sp,
//                   fontWeight: FontWeight.w500,
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//

// import 'dart:io';

// import 'package:elk_mobile/src/core/app/app.dart';
// import 'package:elk_mobile/src/core/widgets/icon/app_icon.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:go_router/go_router.dart';
// import 'package:provider/provider.dart';

// import '../../../core/styles/app_colors.dart';
// import '../../../core/styles/app_icons.dart';
// import '../../provider/page_control_provider.dart';
// import '../../provider/biometric_provider.dart';
// import 'package:back_button_interceptor/back_button_interceptor.dart';

// class CustomPageControl extends StatefulWidget {
//   const CustomPageControl({
//     super.key,
//     required this.navigationShell,
//   });
//   final StatefulNavigationShell navigationShell;

//   @override
//   State<CustomPageControl> createState() => _CustomPageControlState();
// }

// class _CustomPageControlState extends State<CustomPageControl> {
//   @override
//   void initState() {
//     super.initState();

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       BackButtonInterceptor.add(myInterceptor);
//       final controlProvider =
//           Provider.of<PageControlProvider>(context, listen: false);
//       controlProvider.initialize();

//       final provider = Provider.of<BiometricProvider>(context, listen: false);
//       provider.checkBiometricAvailability(context);
//     });
//   }

//   void _goBranch(int index) {
//     widget.navigationShell.goBranch(
//       index,
//       initialLocation: index == widget.navigationShell.currentIndex,
//     );
//   }

//   @override
//   void dispose() {
//     BackButtonInterceptor.remove(myInterceptor);
//     super.dispose();
//   }

//   bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
//     final controlProvider =
//         Provider.of<PageControlProvider>(context, listen: false);
//     if (controlProvider.currentIndex == 0) {
//       return false;
//     } else {
//       controlProvider.willPop();
//       return true;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final controlProvider = Provider.of<PageControlProvider>(context);
//     return Consumer<BiometricProvider>(
//       builder: (
//         BuildContext context,
//         BiometricProvider provider,
//         Widget? child,
//       ) =>
//           !provider.isAuthenticated
//               ? const Scaffold()
//               // ignore: deprecated_member_use
//               : WillPopScope(
//                   onWillPop: () async {
//                     if (Navigator.of($navigatorKey.currentState!.context)
//                         .canPop()) {
//                       Navigator.of($navigatorKey.currentState!.context).pop();
//                       return false;
//                     } else if (controlProvider.currentIndex == 0) {
//                       return true;
//                     } else {
//                       controlProvider.willPop();
//                       return false;
//                     }
//                   },
//                   child: GestureDetector(
//                     behavior: HitTestBehavior.opaque,
//                     onHorizontalDragUpdate: (details) {
//                       if (details.primaryDelta! > 20) {
//                         if (controlProvider.currentIndex > 0) {
//                           controlProvider.willPop();
//                         }
//                       }
//                     },
//                     child: Scaffold(
//                       resizeToAvoidBottomInset: false,
//                       body: Column(
//                         children: [
//                           Expanded(
//                             child: PageView(
//                               physics: const NeverScrollableScrollPhysics(),
//                               scrollDirection: Axis.vertical,
//                               onPageChanged: (index) {
//                                 controlProvider.changeIndex(index);
//                                 _goBranch(index);
//                               },
//                               controller: controlProvider.pageController,
//                               children: controlProvider.pages,
//                             ),
//                           ),
//                           Divider(
//                             height: 0.h,
//                             color: AppColors.colorFillTertiary,
//                           ),
//                           SizedBox(
//                             width: double.infinity,
//                             height: Platform.isIOS ? 78.h : 65.h,
//                             child: const DecoratedBox(
//                               decoration: BoxDecoration(
//                                 color: AppColors.white,
//                                 borderRadius: BorderRadius.only(
//                                   topLeft: Radius.circular(10),
//                                   topRight: Radius.circular(10),
//                                 ),
//                               ),
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceAround,
//                                 children: [
//                                   NavigateItem(
//                                     icon: AppIcons.mainLogo,
//                                     text: 'Главная',
//                                     index: 0,
//                                   ),
//                                   NavigateItem(
//                                     icon: AppIcons.chatOf,
//                                     text: 'Чат',
//                                     index: 1,
//                                   ),
//                                   NavigateItem(
//                                     icon: AppIcons.settingsNotificationOff,
//                                     text: 'Уведомление',
//                                     index: 2,
//                                   ),
//                                   NavigateItem(
//                                     icon: AppIcons.mainMenu,
//                                     text: 'Меню',
//                                     index: 3,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//     );
//   }
// }

// class NavigateItem extends StatelessWidget {
//   final int index;
//   final String icon;
//   final String text;
//   const NavigateItem({
//     super.key,
//     required this.icon,
//     required this.text,
//     required this.index,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final controlProvider = Provider.of<PageControlProvider>(context);
//     return GestureDetector(
//       onTap: () {
//         controlProvider.onBottomNavTapped(index);
//       },
//       onDoubleTap: () => controlProvider.clear(index),
//       child: DecoratedBox(
//         decoration: const BoxDecoration(
//           borderRadius: BorderRadius.all(
//             Radius.circular(10),
//           ),
//           color: AppColors.white,
//         ),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(
//             vertical: 10,
//             horizontal: 10,
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               AppIcon(
//                 icon,
//                 size: 20,
//                 color: controlProvider.currentIndex == index
//                     ? AppColors.colorInfo
//                     : AppColors.colorIcon,
//               ),
//               5.verticalSpace,
//               Text(
//                 text,
//                 style: TextStyle(
//                   color: controlProvider.currentIndex == index
//                       ? AppColors.colorInfo
//                       : AppColors.colorIcon,
//                   fontSize: 12.sp,
//                   fontWeight: FontWeight.w500,
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/styles/svg_icons.dart';
import '../../providers/control_page_provider.dart';
import '../../providers/chat_list_provider.dart';

class CustomPageControl extends StatefulWidget {
  final Widget child;

  const CustomPageControl({super.key, required this.child});

  @override
  State<CustomPageControl> createState() => _CustomPageControlState();
}

class _CustomPageControlState extends State<CustomPageControl> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
          return false;
        }
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: widget.child, // Отображаем дочерний маршрут
        bottomNavigationBar: SizedBox(
          width: double.infinity,
          height: Platform.isIOS ? 82.h : 70.h,
          child: const Column(
            children: [
              Divider(height: 0, color: Color(0xFF1A1A1D)),
              CustomBottomNavigationBar(),
            ],
          ), // Панель навигации
        ),
      ),
    );
  }
}

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: Platform.isIOS ? 82.h : 70.h,
      child: DecoratedBox(
        decoration: const BoxDecoration(color: Color(0xFF0B0B0C)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            NavigateItem(
              iconFell: SvgIcons.homeFill,
              color: Colors.white,
              icon: SvgIcons.home,
              text: 'Главная',
              index: 0,
              path: '/home',
            ),
            _SellButton(index: 1, path: '/sell'),
            NavigateItemWithBadge(
              iconFell: SvgIcons.chatFill,
              color: Colors.white,
              icon: SvgIcons.chat,
              text: 'Чаты',
              index: 2,
              path: '/chats',
            ),
            NavigateItem(
              iconFell: SvgIcons.userFill,
              color: Colors.white,
              icon: SvgIcons.user,
              text: 'Профиль',
              index: 3,
              path: '/profile',
            ),
          ],
        ),
      ),
    );
  }
}

class NavigateItem extends StatelessWidget {
  final int index;
  final String icon;
  final String iconFell;
  final String text;
  final Color color;
  final String path;

  const NavigateItem({
    super.key,
    required this.icon,
    required this.text,
    required this.index,
    required this.path,
    required this.color,
    required this.iconFell,
  });

  @override
  Widget build(BuildContext context) {
    final controlProvider = Provider.of<PageControlProvider>(context);
    final isSelected = controlProvider.currentIndex == index;

    return GestureDetector(
      onTap: () {
        controlProvider.onBottomNavTapped(index, context);
        context.go(path);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.string(
              isSelected ? iconFell : icon,
              width: isSelected ? 24.w : 23.w,
              height: isSelected ? 24.h : 23.h,
              colorFilter: ColorFilter.mode(
                isSelected ? color : Colors.white.withOpacity(0.6),
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              text,
              style: TextStyle(
                color: isSelected ? color : Colors.white.withOpacity(0.6),
                fontSize: 12.sp,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NavigateItemWithBadge extends StatelessWidget {
  final int index;
  final String icon;
  final String iconFell;
  final String text;
  final Color color;
  final String path;

  const NavigateItemWithBadge({
    super.key,
    required this.icon,
    required this.text,
    required this.index,
    required this.path,
    required this.color,
    required this.iconFell,
  });

  @override
  Widget build(BuildContext context) {
    final controlProvider = Provider.of<PageControlProvider>(context);
    final chatProvider = context.watch<ChatListProvider>();
    final isSelected = controlProvider.currentIndex == index;

    // Подсчитываем общее количество непрочитанных сообщений
    final unreadCount = chatProvider.threads.fold<int>(
      0,
      (sum, thread) => sum + thread.unreadCount,
    );

    return GestureDetector(
      onTap: () {
        controlProvider.onBottomNavTapped(index, context);
        context.go(path);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                SvgPicture.string(
                  isSelected ? iconFell : icon,
                  width: isSelected ? 24.w : 23.w,
                  height: isSelected ? 24.h : 23.h,
                  colorFilter: ColorFilter.mode(
                    isSelected ? color : Colors.white.withOpacity(0.6),
                    BlendMode.srcIn,
                  ),
                ),
                if (unreadCount > 0)
                  Positioned(
                    top: -4,
                    right: -4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 2,
                      ),
                      decoration: const BoxDecoration(
                        color: Color(0xFFF44336),
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Center(
                        child: Text(
                          unreadCount > 99 ? '99+' : '$unreadCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              text,
              style: TextStyle(
                color: isSelected ? color : Colors.white.withOpacity(0.6),
                fontSize: 12.sp,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SellButton extends StatelessWidget {
  final int index;
  final String path;

  const _SellButton({required this.index, required this.path});

  @override
  Widget build(BuildContext context) {
    final controlProvider = Provider.of<PageControlProvider>(context);
    final isSelected = controlProvider.currentIndex == index;

    return GestureDetector(
      onTap: () {
        controlProvider.onBottomNavTapped(index, context);
        context.go(path);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 48.w,
            height: 48.h,
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1D),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.add, color: Colors.white, size: 24.sp),
          ),
          const SizedBox(height: 4),
          Text(
            'Продать',
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.white.withOpacity(0.6),
              fontSize: 12.sp,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
