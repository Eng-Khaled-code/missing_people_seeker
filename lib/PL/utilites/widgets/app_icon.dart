import 'package:flutter/material.dart';

import '../strings.dart';

class AppIcon extends StatelessWidget {
  const AppIcon({Key? key,this.size}) : super(key: key);
  final Size? size;
  @override
  Widget build(BuildContext context) {
    return ClipOval(
        child: Image.asset(Strings.appIconAssets,
          width: size!.width,
          height:size!.height,
          fit: BoxFit.fill,
        ));

  }
}
