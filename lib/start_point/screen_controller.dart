import 'package:finalmps/PL/home/home_page.dart';
import 'package:finalmps/PL/registration/log_in.dart';
import 'package:finalmps/provider/user_change.dart';
import 'package:finalmps/start_point/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScreenController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserChange>(context);

    switch (user.status) {
      case Status.Uninitialized:
        return SplashScreen();
        break;
      case Status.Authenticating:
      case Status.Unauthenticated:
        return LogIn();
        break;
      case Status.Authenticated:
        return HomePage();
        break;
      default:
        return SplashScreen();
    }
  }
}
