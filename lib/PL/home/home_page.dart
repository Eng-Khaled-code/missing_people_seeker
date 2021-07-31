import 'package:finalmps/PL/home/chat/chat_list.dart';
import 'package:finalmps/provider/chat_change.dart';
import 'package:finalmps/PL/home/notifications/notifications.dart';
import 'package:finalmps/PL/home/orders/add_missed/add_missed_1.dart';
import 'package:finalmps/provider/notify_change.dart';
import 'package:provider/provider.dart';
import 'package:finalmps/PL/utilites/custom_alert_dialog.dart';
import 'package:finalmps/PL/utilites/custom_button.dart';
import 'package:finalmps/PL/utilites/drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:finalmps/provider/user_change.dart';
import 'package:finalmps/PL/utilites/custom_chat_or_notify.dart';
import 'package:finalmps/PL/utilites/custom_clipper.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  loadNotificationsCount(
      {required NotifyChange notifyChange, String? userId}) async {
    await notifyChange.loadLastDate(userId: userId);
    await notifyChange.loadNotifyCount(
        userId: userId, date: notifyChange.getLastDate);
  }

  @override
  Widget build(BuildContext context) {
    UserChange user = Provider.of<UserChange>(context);
    NotifyChange notifyChange = Provider.of<NotifyChange>(context);

//loading notifications count
    user.userInformation != null
        ? loadNotificationsCount(
            userId: user.userInformation.id, notifyChange: notifyChange)
        : () {};
    //load notifications when the app starts up
    user.userInformation != null
        ? notifyChange.loadNotifications(userId: user.userInformation.id)
        : () {};

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
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            leading: Builder(builder: (context) {
              return IconButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                icon: Icon(
                  Icons.menu,
                  color: Colors.white,
                ),
              );
            }),
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
            title: Text(
              "الرئيسية",
              style: TextStyle(color: Colors.white),
            ),
            actions: user.userInformation == null
                ? [
                    Center(
                      child: CircularProgressIndicator(strokeWidth: 1.5),
                    )
                  ]
                : [
                    notificationWidget(
                        context: context,
                        userId: user.userInformation.id,
                        notifyChange: notifyChange),
                    chatWidget(
                      context: context,
                      userId: user.userInformation.id,
                    )
                  ],
          ),
          body: Container(
              child: Column(children: <Widget>[
            ClipPath(
                clipper: CustomShapeClipper(),
                child: Container(
                    height: MediaQuery.of(context).size.height * 0.4,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF0D47A1),
                          Color(0xFF1E88E5),
                        ],
                      ),
                    ),
                    child: Stack(children: <Widget>[
                      Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.3,
                        alignment: Alignment.center,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.person_search,
                              size: 100,
                              color: Colors.white,
                            ),
                            SizedBox(height: 10),
                            Text(
                              "الباحث عن الاشخاص المفقودين",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 25.0),
                            ),
                          ],
                        ),
                      ),
                    ]))),
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    CustomButton(
                        color: [
                          Color(0xFF0D47A1),
                          Color(0xFF1E88E5),
                        ],
                        text: "تسجيل طلب فقد",
                        onPress: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddMissed1(
                                      type: "فقد", addOrUpdate: "تسجيل")));
                        },
                        textColor: Colors.white),
                    SizedBox(height: 20),
                    CustomButton(
                        color: [
                          Color(0xFF0D47A1),
                          Color(0xFF1E88E5),
                        ],
                        text: "تسجيل طلب إيجاد",
                        onPress: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddMissed1(
                                      type: "شك", addOrUpdate: "تسجيل")));
                        },
                        textColor: Colors.white),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ])),
          drawer: CustomDrawer(),
        ),
      ),
    );
  }

  Widget notificationWidget(
      {NotifyChange? notifyChange, BuildContext? context, String? userId}) {
    return CustomChatNotifyWidget(
        icon: Icons.notifications_none,
        onPress: () async {
          Navigator.push(
              context!,
              MaterialPageRoute(
                  builder: (context) => NotificationPage(userId: userId)));
          await notifyChange!.updateLastDate(userId: userId);
        },
        count: int.tryParse(notifyChange!.getNotificationsCount));
  }

  Widget chatWidget({BuildContext? context, String? userId}) {
    return CustomChatNotifyWidget(
        icon: CupertinoIcons.chat_bubble_2,
        onPress: () {
          Navigator.push(
              context!,
              MaterialPageRoute(
                  builder: (context) => ChatList(
                        userId: userId,
                      )));

          //await chatChange.updateLastDate(userId: userId);
        },
        count: 0);
    // count: chatChange.getRecentMessagesCount);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    UserChange user = Provider.of<UserChange>(context, listen: false);

    switch (state) {
      case AppLifecycleState.paused:
        user.updateConnectStatus(
            connected: "no", userId: user.userInformation.id);
        break;
      case AppLifecycleState.resumed:
        user.updateConnectStatus(
            connected: "yes", userId: user.userInformation.id);
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.detached:
        user.updateConnectStatus(
            connected: "no", userId: user.userInformation.id);
        break;
    }
  }
}
