import 'package:flutter/material.dart';
import '../app_colors/light_colors.dart';
import '../fonts.dart';

ThemeData lightThemeData() => ThemeData(
      brightness: Brightness.light,
      primaryColor: LightColors.primary,
      scaffoldBackgroundColor: LightColors.background,
      backgroundColor: LightColors.background,
      fontFamily: Fonts.saudiArabiaFont,
      //accentColor: LightColors.accent,
      dividerColor: LightColors.divider,
      //drawerTheme: DrawerThemeData(backgroundColor: LightColors.drawer,scrimColor: LightColors.drawer),
      // elevatedButtonTheme: ElevatedButtonThemeData(style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity,50))),
    );
