import 'package:flutter/material.dart';

import 'app_colors.dart';

ThemeData appTheme = ThemeData(
    useMaterial3: false,
    colorScheme: colorScheme,
    fontFamily: 'PT_Sans',
    splashColor: AppColors.transparent,
    hoverColor: AppColors.transparent,
    highlightColor: AppColors.transparent,
    focusColor: AppColors.transparent,
    appBarTheme: appBarTheme,
    scaffoldBackgroundColor: AppColors.white,
    inputDecorationTheme: inputDecorationTheme,
    iconTheme: iconThemeData,
    drawerTheme: drawerThemeData);

AppBarTheme appBarTheme = const AppBarTheme(
    color: AppColors.white,
    elevation: 0,
    centerTitle: false,
    iconTheme: IconThemeData(color: AppColors.darkBlue),
    actionsIconTheme: IconThemeData(color: AppColors.blue));

ColorScheme colorScheme = const ColorScheme.light(
  surface: AppColors.white,
  background: AppColors.white,
  primary: AppColors.blue,
);

DrawerThemeData drawerThemeData =
    const DrawerThemeData(backgroundColor: AppColors.white, elevation: 0.0);

IconThemeData iconThemeData = const IconThemeData(color: AppColors.darkBlue);
InputDecorationTheme inputDecorationTheme = const InputDecorationTheme(
    filled: true,
    isDense: true,
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
    fillColor: AppColors.lightGrey,
    focusedBorder:
        OutlineInputBorder(borderSide: BorderSide(color: Colors.black12)),
    enabledBorder:
        OutlineInputBorder(borderSide: BorderSide(color: Colors.black12)),
    errorBorder:
        OutlineInputBorder(borderSide: BorderSide(color: AppColors.errorRed)),
    focusedErrorBorder:
        OutlineInputBorder(borderSide: BorderSide(color: AppColors.errorRed)),
    border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black12)),
    disabledBorder:
        OutlineInputBorder(borderSide: BorderSide(color: Colors.black12)),
    hintStyle: TextStyle(
        fontSize: 13, color: AppColors.darkGrey, fontWeight: FontWeight.w500));

extension AppTextTheme on TextTheme {
  TextStyle get appBarTitle {
    return const TextStyle(
        fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.darkBlue);
  }

  TextStyle get labelTextStyle {
    return const TextStyle(
        fontSize: 16, color: AppColors.darkBlue, fontWeight: FontWeight.w300);
  }

  TextStyle get gridViewLabelTextStyle {
    return const TextStyle(
        fontSize: 18, color: AppColors.cementGrey, fontWeight: FontWeight.w600);
  }

  TextStyle get fieldLabelTextStyle {
    return const TextStyle(
        fontSize: 14, color: AppColors.cementGrey, fontWeight: FontWeight.w600);
  }

  TextStyle get errorTextStyle {
    return const TextStyle(
        fontSize: 16, color: AppColors.black, fontWeight: FontWeight.w600);
  }

  TextStyle get productLabelTextStyle {
    return const TextStyle(
        fontSize: 16, color: AppColors.black, fontWeight: FontWeight.w600);
  }

  TextStyle get productNameTextStyle {
    return const TextStyle(
        fontSize: 14, color: AppColors.darkBlue, fontWeight: FontWeight.w700);
  }

  TextStyle get variantNameTextStyle {
    return const TextStyle(
        fontSize: 13, color: AppColors.darkBlue, fontWeight: FontWeight.w600);
  }

  TextStyle get descriptionTextStyle {
    return const TextStyle(
        fontSize: 12, color: AppColors.darkGrey, fontWeight: FontWeight.w500);
  }

  TextStyle get productCostTextStyle {
    return const TextStyle(
        fontSize: 16, color: AppColors.darkBlue, fontWeight: FontWeight.w700);
  }

  TextStyle get moduleHeadingTextStyle {
    return const TextStyle(
        fontSize: 26, color: AppColors.darkBlue, fontWeight: FontWeight.w800);
  }

  TextStyle get generalSectionHeadingTextStyle {
    return const TextStyle(
        fontSize: 16, color: AppColors.darkBlue, fontWeight: FontWeight.w700);
  }

  TextStyle get errorSubtitleTextStyle {
    return const TextStyle(
        fontSize: 12, color: AppColors.errorRed, fontWeight: FontWeight.w300);
  }
}
