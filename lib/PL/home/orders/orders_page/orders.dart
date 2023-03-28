import 'package:finalmps/provider/user_change.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../authentication/loding_screen.dart';
import '../../../utilites/widgets/background_image.dart';
import 'order_about_missing.dart';
import 'order_about_my_be_missied.dart';

// ignore: must_be_immutable
class Orders extends StatefulWidget {
  String selectedPage;

  Orders(this.selectedPage);

  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  Color activeColor = Colors.white;
  Color notActiveColor = Colors.red;

  @override
  Widget build(BuildContext context) {
    UserChange user = Provider.of<UserChange>(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            children: <Widget>[
              Expanded(
                child: TextButton(
                    onPressed: () => setState(() => widget.selectedPage = "0"),
                    child: Text("طلبات الفقد",
                        style: TextStyle(
                            fontSize: 22,
                            color: widget.selectedPage == "0"
                                ? activeColor
                                : notActiveColor))),
              ),
              Expanded(
                  child: TextButton(
                      onPressed: () =>
                          setState(() => widget.selectedPage = "1"),
                      child: Text("طلبات إيجاد",
                          style: TextStyle(
                              fontSize: 22,
                              color: widget.selectedPage == "1"
                                  ? activeColor
                                  : notActiveColor))))
            ],
          ),
        ),
        body: user.userData == null
            ? LoadingScreen(
                progressColor: Colors.blue,
              )
            : Stack(
                children: <Widget>[
                  BackgroundImage(),
                  widget.selectedPage == "0"
                      ? OrdersAboutMissing(user.userData!.id)
                      : OrdersAboutMayBeMissed(user.userData!.id)
                ],
              ),
      ),
    );
  }
}
