import 'package:flutter/material.dart';

sealed class AppColors {
  const AppColors._();

  static const Color white = Color(0xFFFFFFFF);
  static const Color mainLightGreen = Color(0xFFB9F4A4); // #b9f4a4
  static const Color mainDarkGreen = Color(0xFF219723); // #219723

  static const Color white10 = Color(0xFFF6F5F5);

  static const Color black = Color(0xFF000000);

  static const Color iconColor = Color(0xFFB3B4B3);
  static const Color splashBac = Color(0xFF219723);

  static const Color colorTextSecondary = Color(0xFF4D545F);

  static const Color colorPrimaryBg = Color(0xFFEAF3F9);
  static const Color colorPrimaryBgHover = Color(0xFFDDECF5);
  static const Color colorPrimaryBorder = Color(0xFFC5DFEE);
  static const Color colorPrimaryBorderHover = Color(0xFFA2CCE3);
  static const Color colorPrimaryHover = Color(0xFF7CB7D8);
  static const Color colorPrimary = Color(0xFF006196);
  static const Color colorPrimaryActive = Color(0xFF003B5C);
  static const Color colorPrimaryTextHover = Color(0xFF0577B4);
  static const Color colorPrimaryText = Color(0xFF006196);
  static const Color colorPrimaryTextActive = Color(0xFF003B5C);
  static const Color colorPrimaryTextDisabled = Color(0x0A2C310D);
  static const Color colorPrimaryTextDisabled2 = Color(0x002C310D);
  static const Color colorPrimaryText3 = Color(0xFF003755);

// Success
  static const Color colorSuccessBg = Color(0xFFE3F7E8);
  static const Color colorSuccessBgHover = Color(0xFFD3F2DB);
  static const Color colorSuccessBorder = Color(0xFFABE8BA);
  static const Color colorSuccessBorderHover = Color(0xFF73D88D);
  static const Color colorSuccessHover = Color(0xFF73D88D);
  static const Color colorSuccess = Color(0xFF33C357);
  static const Color colorSuccessActive = Color(0xFF269241);
  static const Color colorSuccessTextHover = Color(0xFF73D88D);
  static const Color colorSuccessText = Color(0xFF33C357);
  static const Color colorSuccessTextActive = Color(0xFF269241);

// Warning
  static const Color colorWarningBg = Color(0xFFFFF1DD);
  static const Color colorWarningBgHover = Color(0xFFFFE8C7);
  static const Color colorWarningBorder = Color(0xFFFFD292);
  static const Color colorWarningBorderHover = Color(0xFFFFB44A);
  static const Color colorWarningHover = Color(0xFFFFB44A);
  static const Color colorWarning = Color(0xFFF99100);
  static const Color colorWarningActive = Color(0xFFBA6C00);
  static const Color colorWarningTextHover = Color(0xFFFFB44A);
  static const Color colorWarningText = Color(0xFFF99100);
  static const Color colorWarningTextActive = Color(0xFFBA6C00);

// Info
  static const Color colorInfoBg = Color(0xFFEAF3F9);
  static const Color colorInfoBgHover = Color(0xFFDDECF5);
  static const Color colorInfoBorder = Color(0xFFC5DFEE);
  static const Color colorInfoBorderHover = Color(0xFFA2CCE3);
  static const Color colorInfoHover = Color(0xFF7CB7D8);
  static const Color colorInfo = Color(0xFF006196);
  static const Color colorInfoActive = Color(0xFF003B5C);
  static const Color colorInfoTextHover = Color(0xFF0577B4);
  static const Color colorInfoText = Color(0xFF006196);
  static const Color colorInfoTextActive = Color(0xFF003B5C);

// Error
  static const Color colorErrorBg = Color(0xFFFDEFF3);
  static const Color colorErrorBgHover = Color(0xFFFFE3EB);
  static const Color colorErrorBorder = Color(0xFFF9CFDB);
  static const Color colorErrorBorderHover = Color(0xFFF5B0C3);
  static const Color colorErrorHover = Color(0xFFF5B0C3);
  static const Color colorError = Color(0xFFCD184B);
  static const Color colorErrorActive = Color(0xFFA7143D);
  static const Color colorErrorTextHover = Color(0xFFE73B6B);
  static const Color colorErrorText = Color(0xFFCD184B);
  static const Color colorErrorTextActive = Color(0xFFA7143D);

// Link
  static const Color colorLink = Color(0xFF006196);
  static const Color colorLinkHover = Color(0xFFA2CCE3);
  static const Color colorLinkActive = Color(0xFF003B5C);

// Control
  static const Color controllItemBgActive = Color(0xFFEAF3F9);
  static const Color controllItemBgActiveDisabled = Color(0xFFBBC1CD);
  static const Color controllItemBgActiveHover = Color(0xFFDDECF5);
  static const Color controllItemBgHover = Color(0xFFE7EAF0);
  static const Color controlOutline = Color(0xFFEAF3F9);
  static const Color controlTmpOutline = Color(0xFFEEF0F5);

// Neutural Colors
  static const Color colorWhite = Color(0xFFFFFFFF);
  static const Color colorBgBase = Color(0xFFEAF3F9);
  static const Color colorTextBase = Color(0xFF2A2C31);
  static const Color transparent = Color(0x2A2C314D);

// Text    rgba(42, 44, 49, 0.8)
  static const Color colorText1 = Color(0xFF2A2C31);
  static const Color colorText2 = Color(0x2A2C310F);
  static const Color colorText3 = Color.fromRGBO(42, 44, 49, 0.8);
  static const Color colorTextTertiary = Color(0xFF757D8C);
  static const Color colorTextQuaternary = Color(0xFFA2A9B6);
  static const Color colorTextLightSolid = Color(0xFFFFFFFF);
  static const Color colorTextHeading = Color(0xFF2A2C31);
  static const Color colorTextLabel = Color(0xFF4D545F);
  static const Color colorTextDescription = Color(0xFF757D8C);
  static const Color colorTextDisabled = Color(0xFFA2A9B6);
  static const Color colorTextDisabled2 = Color(0x402A2C31);
  static const Color colorTextPlaceholder = Color(0xFFA2A9B6);

  // Icon
  static const Color colorIcon = Color(0xFF757D8C);
  static const Color colorIconHover = Color(0xFF2A2C31);
  static const Color colorIconBac = Color(0x162A2C31);

// Border
  static const Color colorBorder = Color(0xFFD2D7E3);
  static const Color c = Color(0xFFE7EAF0);
  static const Color colorSplit = Color(0x182A2C31);

// Fill
  static const Color colorFill = Color(0xFFBBC1CD);
  static const Color colorFillSecondary = Color(0xFFD2D7E3);
  static const Color colorFillTertiary = Color(0xFFE7EAF0);
  static const Color colorFillQuaternary = Color(0xFFEEF0F5);
  static const Color colorFillContent = Color(0xFFD2D7E3);
  static const Color colorFillContentHover = Color(0xFFBBC1CD);
  static const Color colorFillAlter = Color(0xFFEEF0F5);

// Background
  static const Color colorBgContainer = Color(0xFFEAF3F9);

  static const Color colorBgContainer1 = Color(0xFFEEF4F8);
  static const Color colorBgElevated = Color(0xFFFFFFFF);
  static const Color colorBgLayout = Color(0x4B2A2C31);
  static const Color colorBgMask = Color(0x4B2A2C31);
  static const Color colorBgSpotlight = Color(0xD72A2C31);
  static const Color colorBgContainerDisabled = Color(0x4B2A2C31);
  static const Color colorBgTextActive = Color(0x4B2A2C31);
  static const Color colorBgTextHover = Color(0x4B2A2C31);
  static const Color colorBorderBg = Color(0x4B2A2C31);
  // new j
  static const Color scaffolBg = Color(0xFFEEF4F8);
  static const Color red = Color(0xFFF44336);

  // new
  static const Color purple = Color(0xFFDAE3FF);
  static const Color textBlue = Color.fromRGBO(0, 97, 150, 1);
  static const Color cyan = Color(0xFF13C2C2);
  static const Color purple06 = Color(0xFF722ED1);
  static const Color green = Color(0x40389E0D);
  static const Color green2 = Color(0xFF389E0D);
  static const Color green3 = Color(0x40389E0D);
  static const Color yellow = Color(0xFFFFECDC);
  static const Color cartItemTextColor = Color(0xFF2C2E33);
  static const Color black02 = Color(0x2A2C3100);
  static const Color buttonBackground = Color(0x0577B41A);

  static const Color dividerColor = Color(0xFFE7EAF0);
}
