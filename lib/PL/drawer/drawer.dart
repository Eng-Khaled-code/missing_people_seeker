import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/user_change.dart';
import '../help_page/help_page.dart';
import '../home/found_people/found_people.dart';
import '../home/orders/orders_page/orders.dart';
import '../profile/profile_page.dart';
import '../setting/setting_page.dart';
import '../utilites/widgets/background_image.dart';
import 'drawer_header.dart';
import 'drawer_tile.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UserChange userChange = Provider.of<UserChange>(context);

    return Drawer(
        child: Stack(alignment: Alignment.center, children: <Widget>[
      BackgroundImage(),
      ListView(
        children: <Widget>[
          CustomDrawerHeader(userChange: userChange),
          CustomDrawerTile(
            icon: Icons.home,
            text: "الرئيسية",
            to: Container(),
            userChange: userChange,
          ),
          CustomDrawerTile(
              icon: Icons.account_circle_outlined,
              text: "إعدادات الحساب",
              to: ProfilePage()),
          CustomDrawerTile(
            icon: Icons.library_books,
            text: "الطلبات",
            to: Orders("0"),
          ),
          CustomDrawerTile(
              icon: Icons.verified_user,
              text: "الاشخاص الذين تم إيجادهم",
              to: Founds()),
          Divider(
            color: Colors.blueAccent,
          ),
          CustomDrawerTile(
              icon: Icons.settings, text: "الإعدادات", to: SettingPage()),
          CustomDrawerTile(
              icon: Icons.help, text: "سياسة الخصوصية", to: HelpPage()),
          CustomDrawerTile(
            icon: Icons.arrow_back,
            text: "تسجيل الخروج",
            to: Container(),
            userChange: userChange,
          ),
        ],
      ),
    ]));
  }
}
