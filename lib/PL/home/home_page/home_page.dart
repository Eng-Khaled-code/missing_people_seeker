import 'package:finalmps/PL/home/orders/add_missed/add_missed_1.dart';
import 'package:finalmps/provider/notify_change.dart';
import 'package:provider/provider.dart';
import 'package:finalmps/PL/utilites/widgets/custom_alert_dialog.dart';
import 'package:finalmps/PL/utilites/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:finalmps/provider/user_change.dart';
import '../../drawer/drawer.dart';
import '../../utilites/helper/helper.dart';
import 'home_app_bar.dart';
import 'home_top_widget.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    UserChange userChange = Provider.of<UserChange>(context);
    NotifyChange notifyChange = Provider.of<NotifyChange>(context);

//loading notifications count
    if (userChange.userData != null)
      notifyChange.loadNotifyCount(userId: userChange.userData!.id);

    return WillPopScope(
      onWillPop: () {
        showDialog(
            context: context,
            builder: (context) => CustomAlertDialog(
                  title: "تنبيه",
                  onPress: () async {
                    SystemNavigator.pop();
                  },
                  text: "هل تريد الخروج من التطبيق بالفعل",
                ));
        return Future.delayed(Duration(seconds: 0));
      },
      child: userChange.userData == null
          ? Material(child: Center(child: CircularProgressIndicator()))
          : Scaffold(
              drawer: MyDrawer(),
              appBar: HomeAppBar(
                  userId: userChange.userData!.id, notifyChange: notifyChange),
              body: Column(children: <Widget>[
                HomeTopWidget(),
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        CustomButton(
                            text: "تسجيل طلب فقد",
                            onPress: () => Helper().goTo(
                                context: context,
                                to: AddMissed1(
                                    type: "فقد", addOrUpdate: "تسجيل"))),
                        SizedBox(height: 20),
                        CustomButton(
                            text: "تسجيل طلب إيجاد",
                            onPress: () => Helper().goTo(
                                context: context,
                                to: AddMissed1(
                                    type: "شك", addOrUpdate: "تسجيل"))),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ]),
            ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    UserChange user = Provider.of<UserChange>(context, listen: false);

    switch (state) {
      case AppLifecycleState.paused:
        user.updateConnectStatus(connected: "no");
        break;
      case AppLifecycleState.resumed:
        user.updateConnectStatus(connected: "yes");
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.detached:
        user.updateConnectStatus(connected: "no");
        break;
    }
  }
}
