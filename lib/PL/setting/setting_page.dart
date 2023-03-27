import 'package:flutter/material.dart';

import '../drawer/drawer_tile.dart';
class SettingPage extends StatelessWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding:const EdgeInsets.all(10),
        children: <Widget>[
          CustomDrawerTile(icon:Icons.mode_night, text: "Night mode", to: Container(),),
        ]
    );
  }
}
