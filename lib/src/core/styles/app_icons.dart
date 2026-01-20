import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'app_colors.dart';

sealed class AppIcons {
  const AppIcons._();

  static const String iconName = '';
}

class AppIcon extends StatelessWidget {
  const AppIcon(
    this.icon, {
    this.color = AppColors.iconColor,
    this.size = 20,
    super.key,
    this.withColor = true,
  });

  final String icon;
  final Color? color;
  final double size;
  final bool withColor;

  @override
  Widget build(BuildContext context) => SvgPicture.string(
        width: size.w,
        height: size.h,
        icon,
        // ignore: deprecated_member_use
        color: withColor ? color : null,
      );
}
