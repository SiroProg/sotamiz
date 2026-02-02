import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/router/app_navigation.dart';
import '../../../core/service/db_service.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final features = <_FeatureTileData>[
      const _FeatureTileData(
        icon: Icons.home_outlined,
        title: 'Местный маркетплейс',
        subtitle: 'Находите товары рядом с вами',
      ),
      const _FeatureTileData(
        icon: Icons.lock_outline,
        title: 'Надёжно и безопасно',
        subtitle: 'Проверенные пользователи',
      ),
      const _FeatureTileData(
        icon: Icons.bolt_outlined,
        title: 'Быстрая продажа',
        subtitle: 'Размещайте за минуты',
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0C0C0C),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Дополнительный даунскейл для экранов ниже дизайн-высоты, чтобы избежать overflow без скролла
            final baseHeight = 812.h; // тот, что задан в ScreenUtilInit
            final scale = (constraints.maxHeight / baseHeight).clamp(0.85, 1.0);

            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 24.w * scale,
                vertical: 24.h * scale,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 24.h * scale),
                  _Logo(scale: scale),
                  SizedBox(height: 48.h * scale),
                  Text(
                    'Добро пожаловать в\nSotamiz',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: Colors.white,
                      fontSize: 32.sp * scale,
                      fontWeight: FontWeight.w700,
                      height: 1.1,
                    ),
                  ),
                  SizedBox(height: 16.h * scale),
                  Text(
                    'Покупайте и продавайте рядом с домом',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 18.sp * scale,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 32.h * scale),
                  ...features.map((item) => _FeatureTile(data: item, scale: scale)),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        padding: EdgeInsets.symmetric(vertical: 18.h * scale),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r * scale),
                        ),
                      ),
                      onPressed: () {
                        DBService.isFirstLaunch = false;
                        context.go(AppNavigation.home.path);
                      },
                      child: Text(
                        'Начать',
                        style: TextStyle(
                          fontSize: 20.sp * scale,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h * scale),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _FeatureTileData {
  const _FeatureTileData({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;
}

class _FeatureTile extends StatelessWidget {
  const _FeatureTile({required this.data, required this.scale});

  final _FeatureTileData data;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 18.h * scale),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: const Color(0xFF181818),
              borderRadius: BorderRadius.circular(16.r * scale),
            ),
            child: Padding(
              padding: EdgeInsets.all(16.w * scale),
              child: Icon(data.icon, size: 28.r * scale, color: Colors.white),
            ),
          ),
          SizedBox(width: 16.w * scale),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: Colors.white,
                    fontSize: 22.sp * scale,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 8.h * scale),
                Text(
                  data.subtitle,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 17.sp * scale,
                    fontWeight: FontWeight.w500,
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

class _Logo extends StatelessWidget {
  const _Logo({required this.scale});

  final double scale;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120.w * scale,
      height: 120.h * scale,
      decoration: BoxDecoration(
        color: const Color(0xFF181818),
        borderRadius: BorderRadius.circular(24.r * scale),
        border: Border.all(
          color: Colors.white.withOpacity(0.06),
          width: 1.w * scale,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.45),
            blurRadius: 16.r * scale,
            offset: Offset(0, 8.h * scale),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        'S',
        style: TextStyle(
          fontSize: 44.sp * scale,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }
}
