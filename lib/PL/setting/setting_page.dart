import 'package:flutter/material.dart';

import '../drawer/drawer_tile.dart';
import '../utilites/text_style/text_styles.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
            title: Text(
          "الإعدادات",
          style: TextStyles.title.copyWith(color: Colors.white),
        )),
        body: ListView(padding: const EdgeInsets.all(10), children: <Widget>[
          CustomDrawerTile(
            icon: Icons.mode_night,
            text: "الوضع المظلم",
            to: Container(),
          ),
        ]),
      ),
    );
  }
}
