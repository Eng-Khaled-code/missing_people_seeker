import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../app_colors/dark_colors.dart';
import '../fonts.dart';

ThemeData darkThemeData() => ThemeData(
    primaryColor: DarkColors.primary,
    brightness: Brightness.dark,
    //accentColor:  DarkColors.accent,
    dividerColor: DarkColors.divider,
    fontFamily: Fonts.saudiArabiaFont,
    cupertinoOverrideTheme:
        const CupertinoThemeData(brightness: Brightness.dark),
    scaffoldBackgroundColor: DarkColors.background,
    backgroundColor: DarkColors.background
    // elevatedButtonTheme: ElevatedButtonThemeData(style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity,50))),
    );
