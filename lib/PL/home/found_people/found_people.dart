import 'package:finalmps/PL/home/found_people/found_card.dart';
import 'package:finalmps/models/found_model.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:finalmps/provider/user_change.dart';

import '../../utilites/widgets/background_image.dart';
import '../../utilites/widgets/no_data_card.dart';

class Founds extends StatefulWidget {
  @override
  _FoundsState createState() => _FoundsState();
}

enum Page { MyFounds, OtherFounds }

class _FoundsState extends State<Founds> {
  Page selectedPage = Page.MyFounds;
  Color activeColor = Colors.white;
  Color notActiveColor = Colors.red;

  @override
  Widget build(BuildContext context) {
    UserChange userChange = Provider.of<UserChange>(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: appBar(),
        body: Container(
          child: Stack(
            children: <Widget>[
              BackgroundImage(),
              userChange.userData == null
                  ? Center(child: CircularProgressIndicator())
                  : bodyList(userId: userChange.userData!.id),
            ],
          ),
        ),
      ),
    );
  }

  Widget bodyList({String? userId}) {
    return StreamBuilder<QuerySnapshot>(
        stream: myStream(userId!),
        builder: (context, snapshot) {
          return !snapshot.hasData
              ? Center(child: CircularProgressIndicator())
              : snapshot.data!.size == 0
                  ? NoDataCard(msg: "لا توجد طلبات تم إيجادها")
                  : ListView.builder(
                      itemCount: snapshot.data!.size,
                      itemBuilder: (context, position) {
                        FoundModel foundModel = FoundModel.fromSnapshoot(
                            snapshot.data!.docs[position]);
                        return FoundCard(
                            foundModel: foundModel,
                            myFound: selectedPage == Page.MyFounds);
                      },
                      shrinkWrap: true);
        });
  }

  appBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        children: <Widget>[
          Expanded(
            child: TextButton(
                onPressed: () => setState(() => selectedPage = Page.MyFounds),
                child: Text("اشخاص تم ايجادهم لي",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: selectedPage == Page.MyFounds
                            ? activeColor
                            : notActiveColor))),
          ),
          Expanded(
              child: TextButton(
                  onPressed: () =>
                      setState(() => selectedPage = Page.OtherFounds),
                  child: Text("اشخاص ساعدت في ايجادهم",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: selectedPage == Page.OtherFounds
                              ? activeColor
                              : notActiveColor))))
        ],
      ),
    );
  }

  Stream<QuerySnapshot> myStream(String userId) {
    return selectedPage == Page.MyFounds
        ? FirebaseFirestore.instance
            .collection("founds")
            .where("main_user_id", isEqualTo: userId)
            .snapshots()
        : FirebaseFirestore.instance
            .collection("founds")
            .where("second_user_id", isEqualTo: userId)
            .snapshots();
  }
}
