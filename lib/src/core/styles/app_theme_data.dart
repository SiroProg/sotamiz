import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppThemeData {
  static ThemeData get theme {
    return ThemeData(
      // colorScheme: const ColorScheme(
      //   brightness: Brightness.light,
      //   primary: AppColors.white,
      //   onPrimary: AppColors.white,
      //   secondary: Color(0xFF0288D1),
      //   onSecondary: AppColors.white,
      //   error: Color(0xFFD32F2F),
      //   onError: AppColors.white,
      //   onSurface: AppColors.black,
      // ),
      scaffoldBackgroundColor: AppColors.white,
      appBarTheme: const AppBarTheme(backgroundColor: AppColors.white),
      popupMenuTheme: const PopupMenuThemeData(color: AppColors.white),
      drawerTheme: const DrawerThemeData(
        backgroundColor: AppColors.white,
        elevation: 0,
      ),
      bottomSheetTheme:
          const BottomSheetThemeData(backgroundColor: AppColors.white),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.white,
        unselectedItemColor: AppColors.colorTextSecondary,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.inter(
          fontSize: 20.sp,
          fontWeight: FontWeight.w600,
          height: 26.h / 20.sp,
        ),
        displayMedium: GoogleFonts.inter(
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
          height: 24.h / 18.sp,
        ),
        displaySmall: GoogleFonts.inter(
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          height: 22.h / 16.sp,
        ),
        headlineLarge: GoogleFonts.inter(
          fontSize: 15.sp,
          fontWeight: FontWeight.w600,
          height: 20.h / 15.sp,
        ),
        headlineMedium: GoogleFonts.inter(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          height: 18.h / 14.sp,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 15.sp,
          fontWeight: FontWeight.w400,
          height: 20.h / 15.sp,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          height: 18.h / 14.sp,
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: 16.sp,
          fontWeight: FontWeight.w400,
          height: 22.h / 16.sp,
        ),
        labelLarge: GoogleFonts.inter(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          height: 18.h / 14.sp,
        ),
      ),
    );
  }
}
