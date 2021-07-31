import 'dart:io';

import 'package:finalmps/PL/home/found_people/found_people.dart';
import 'package:finalmps/PL/home/orders/orders.dart';
import 'package:finalmps/models/user_model.dart';
import 'package:finalmps/start_point/screen_controller.dart';
import 'package:finalmps/provider/user_change.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'custom_alert_dialog.dart';
import 'package:finalmps/PL/profile/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CustomDrawer extends StatefulWidget {
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    final user = Provider.of<UserChange>(context);
    return Drawer(
      child: Container(
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              height: height,
              width: width,
              child: Opacity(
                  opacity: 0.5,
                  child: Image.asset(
                    'assets/images/splach_bg.png',
                    fit: BoxFit.fill,
                  )),
            ),
            ListView(
              children: <Widget>[
                drawerHeader(user, height),
                drawerBodyTile(Icons.settings, Colors.blue, "إعدادات الحساب",
                    () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ProfilePage()));
                }),
                drawerBodyTile(Icons.library_books, Colors.blue, "الطلبات", () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => Orders("0")));
                }),
                drawerBodyTile(Icons.verified_user, Colors.blue,
                    "الاشخاص الذين تم إيجادهم", () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => Founds()));
                }),
                Divider(
                  color: Colors.blueAccent,
                ),
//                drawerBodyTile(Icons.privacy_tip_outlined, Colors.greenAccent,
//                    "سياسة الخصوصية", () {}),
                drawerBodyTile(Icons.arrow_back, Colors.red, "تسجيل الخروج",
                    () {
                  showDialog(
                      context: context,
                      builder: (context) => CustomAlertDialog(
                            title: "تنبيه",
                            onPress: () => logOut(user),
                            text: "هل تريد تسجيل الخروج بالفعل",
                          ));
                  //user.signOut();
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  logOut(UserChange user) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Navigator.pop(context);

        if (await user.signOut()) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => ScreenController()));
        } else
          Fluttertoast.showToast(msg: "يوجد مشكلة في تسجيل الخروج");
      }
    } on SocketException catch (_) {
      Fluttertoast.showToast(msg: "تاكد من اتصال الانترنت");
    }
  }

  drawerHeader(UserChange user, height) {
    return user.userInformation == UserModel.emptyConstractor()
        ? Container(
            height: height * .27,
            child:
                Center(child: CircularProgressIndicator(color: Colors.white)))
        : UserAccountsDrawerHeader(
            currentAccountPicture: ClipRRect(
                borderRadius: BorderRadius.circular(60),
                child: Container(
                    child: "${user.userInformation.imageUrl}" == "no image"
                        ? Icon(
                            Icons.account_circle,
                            color: Colors.white,
                            size: height * .1,
                          )
                        : CachedNetworkImage(
                            placeholder: (context, url) {
                              return Container(
                                padding: EdgeInsets.all(10.0),
                                child: CircularProgressIndicator(
                                    strokeWidth: 1, color: Colors.white),
                              );
                            },
                            imageUrl: "${user.userInformation.imageUrl}",
                            fit: BoxFit.cover,
                            errorWidget: (a, x, d) => Image.asset(
                              "assets/images/errorimage.png",
                              fit: BoxFit.cover,
                            ),
                          ))),
            accountEmail: Text(
              // user.userModel.email == null ? "wait while the internet become stronger" : user.userModel.email,
              "${user.userInformation.email}",
              style: TextStyle(color: Colors.white),
            ),
            accountName: Text(
                // user.userModel.name == null ? "wait while the internet become stronger" : user.userModel.name,
                "${user.userInformation.fName} " +
                    "${user.userInformation.lName}",
                style: TextStyle(color: Colors.white)),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF0D47A1),
                  Color(0xFF1E88E5),
                ],
              ),
            ),
          );
  }

  Widget drawerBodyTile(
      IconData icon, Color color, String text, Function()? onTap) {
    return ListTile(
      title: Text(text),
      leading: Icon(
        icon,
        color: color,
      ),
      onTap: onTap,
    );
  }
}
