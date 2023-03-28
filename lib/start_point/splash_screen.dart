import 'package:finalmps/PL/utilites/text_style/text_styles.dart';
import 'package:flutter/material.dart';
import '../PL/utilites/strings.dart';
import '../PL/utilites/widgets/app_icon.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: double.infinity,
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppIcon(
              size: Size(150, 150),
            ),
            SizedBox(height: 10),
            title(),
            SizedBox(height: 25),
            CircularProgressIndicator(
              color: Colors.white,
            )
          ],
        )));
  }

  Text title() => Text(
        Strings.appName,
        textAlign: TextAlign.center,
        style: TextStyles.title,
      );
}
