import 'package:flutter/material.dart';

class AppColors {
  static const blackApp = Color(0xff1B2223);
  static const whiteApp = Color(0xffF4FEFD);
  static const greenApp = Color(0xFFA2C2B5);
  static const greyApp = Color(0xff363535);
  static const gradienteBaixo = Color(0xff87EF49);
  static const gradienteAlto = Color(0xff42E396);
}

class AppTheme {
  static final ThemeData themeData = ThemeData(
    primaryColor: AppColors.blackApp,
    cardColor: AppColors.greyApp,
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.whiteApp,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      floatingLabelBehavior: FloatingLabelBehavior.never,
      labelStyle: const TextStyle(
        color: AppColors.blackApp,
        fontSize: 18,
      ),
    ),
  );
}
