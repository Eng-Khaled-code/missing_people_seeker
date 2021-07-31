import 'package:finalmps/PL/utilites/loding_screen.dart';
import 'package:finalmps/provider/user_change.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'order_about_missing.dart';
import 'order_about_my_be_missied.dart';

class Orders extends StatefulWidget {
  String selectedPage;

  Orders(this.selectedPage);

  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  Color activeColor = Colors.white;
  Color notActiveColor = Colors.black;

  @override
  Widget build(BuildContext context) {
    UserChange user = Provider.of<UserChange>(context);

    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF1E88E5),
                    Color(0xFF0D47A1),
                  ],
                  begin: Alignment.bottomRight,
                  end: Alignment.topLeft,
                ),
              ),
            ),
            title: Row(
              children: <Widget>[
                Expanded(
                  child: TextButton(
                      onPressed: () {
                        setState(() {
                          widget.selectedPage = "0";
                        });
                      },
                      child: Text("طلبات الفقد",
                          style: TextStyle(
                              color: widget.selectedPage == "0"
                                  ? activeColor
                                  : notActiveColor))),
                ),
                Expanded(
                    child: TextButton(
                        onPressed: () {
                          setState(() {
                            widget.selectedPage = "1";
                          });
                        },
                        child: Text("طلبات إيجاد",
                            style: TextStyle(
                                color: widget.selectedPage == "1"
                                    ? activeColor
                                    : notActiveColor))))
              ],
            ),
          ),
          body: user.userInformation == null
              ? LoadingScreen()
              : Container(
                  child: Stack(
                    children: <Widget>[
                      Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: Opacity(
                            opacity: 0.5,
                            child: Image.asset(
                              'assets/images/splach_bg.png',
                              fit: BoxFit.fill,
                            )),
                      ),
                      widget.selectedPage == "0"
                          ? OrdersAboutMissing(user.userInformation.id)
                          : OrdersAboutMayBeMissed(user.userInformation.id)
                    ],
                  ),
                ),
        ));
  }
}
