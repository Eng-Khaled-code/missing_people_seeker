import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../PL/utilites/strings.dart';

class ThemeProvider with ChangeNotifier {

  String themeMode=Strings.lightMode;
  SharedPreferences? preferences;

  ThemeProvider(){
    initializeThemeMode();
  }

  Future<void> initializeThemeMode()async{

    preferences=await SharedPreferences.getInstance();
    themeMode=preferences!.getString(Strings.mode)??Strings.lightMode;
  }

  void setThemeMode(String mode) async {
    themeMode=mode;
    preferences=await SharedPreferences.getInstance();
     preferences!.setString(Strings.mode, mode);
    notifyListeners();
  }

}