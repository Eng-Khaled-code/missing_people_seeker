import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  final Color? progressColor;

  LoadingScreen({key,this.progressColor=Colors.white}):super(key: key);

  @override
  Widget build(BuildContext context) {
    return   Container(
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(progressColor)),
            SizedBox(height: 10),
            Text(
              "إنتظر لحظة...",
            )
          ],
        ),
      ),
    );

  }
}
