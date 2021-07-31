import 'package:finalmps/provider/search_change.dart';
import 'package:finalmps/provider/user_change.dart';
import 'package:finalmps/start_point/screen_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:finalmps/provider/notify_change.dart';
import 'package:finalmps/provider/chat_change.dart';
import 'package:finalmps/provider/missed_change.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserChange.initialize()),
        ChangeNotifierProvider(create: (_) => ChatChange.initialize()),
        ChangeNotifierProvider(create: (_) => MissedChange.initialize()),
        ChangeNotifierProvider(create: (_) => SearchChange.initialize()),
        ChangeNotifierProvider(create: (_) => NotifyChange.initialize()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "الباحث عن المفقودين",
      theme: ThemeData(
          appBarTheme: AppBarTheme(
              color: Colors.white,
              centerTitle: true,
              iconTheme: IconThemeData(color: Colors.white)),
          primaryColor: Colors.blue,
          primaryIconTheme: IconThemeData(color: Colors.red)),
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: ScreenController(),
      ),
    );
  }
}
