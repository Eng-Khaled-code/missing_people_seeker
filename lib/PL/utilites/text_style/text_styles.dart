
import 'package:flutter/material.dart';

import 'font_sizes.dart';

class TextStyles {


  static TextStyle title = TextStyle(fontSize: FontSizes.title,fontWeight: FontWeight.bold);

  static TextStyle cartCount = TextStyle(color: Colors.blue, fontSize: FontSizes.cartCount, fontWeight: FontWeight.w500);
  static TextStyle logInButtonText = TextStyle(color: Colors.blue, fontSize:FontSizes.logInButtonText, fontWeight: FontWeight.bold);
  static TextStyle errorDialog = TextStyle(color: Colors.white, fontSize: FontSizes.errorDialog);

  static  TextStyle appName = TextStyle(color:Colors.white,fontSize:FontSizes.appName);
  static  TextStyle logInLogo = TextStyle(color:Colors.white,fontSize:FontSizes.logInLogo);

// etc
}