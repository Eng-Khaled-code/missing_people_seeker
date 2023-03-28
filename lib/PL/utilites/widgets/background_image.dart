import 'package:flutter/material.dart';

import '../strings.dart';

class BackgroundImage extends StatelessWidget {
  const BackgroundImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Container(
      height: height,
      width: double.infinity,
      child: Opacity(
          opacity: 0.5,
          child: Image.asset(
            Strings.appBackgroundAssets,
            fit: BoxFit.fill,
          )),
    );
  }
}
