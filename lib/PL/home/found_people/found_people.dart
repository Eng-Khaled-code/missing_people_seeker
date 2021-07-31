import 'package:finalmps/PL/utilites/found_card.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:finalmps/provider/user_change.dart';

class Founds extends StatefulWidget {
  @override
  _FoundsState createState() => _FoundsState();
}

enum Page { MyFounds, OtherFounds }

class _FoundsState extends State<Founds> {
  Page selectedPage = Page.MyFounds;
  MaterialColor activeColor = Colors.blue;
  MaterialColor notActiveColor = Colors.grey;

  @override
  Widget build(BuildContext context) {
    UserChange userChange = Provider.of<UserChange>(context);
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            title: Row(
              children: <Widget>[
                Expanded(
                  child: FlatButton(
                      onPressed: () {
                        setState(() {
                          selectedPage = Page.MyFounds;
                        });
                      },
                      child: Text("اشخاص تم ايجادهم لي",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: selectedPage == Page.MyFounds
                                  ? activeColor
                                  : notActiveColor))),
                ),
                Expanded(
                    child: FlatButton(
                        onPressed: () {
                          setState(() {
                            selectedPage = Page.OtherFounds;
                          });
                        },
                        child: Text("اشخاص ساعدت في ايجادهم",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: selectedPage == Page.OtherFounds
                                    ? activeColor
                                    : notActiveColor))))
              ],
            ),
          ),
          body: Container(
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
                userChange.userInformation == null
                    ? Center(child: CircularProgressIndicator())
                    : bodyList(userId: userChange.userInformation.id),
              ],
            ),
          ),
        ));
  }

  Widget bodyList({String? userId}) {
    Stream<QuerySnapshot> stream = selectedPage == Page.MyFounds
        ? FirebaseFirestore.instance
            .collection("founds")
            .where("main_user_id", isEqualTo: userId)
            .snapshots()
        : FirebaseFirestore.instance
            .collection("founds")
            .where("second_user_id", isEqualTo: userId)
            .snapshots();
    return StreamBuilder<QuerySnapshot>(
        stream: stream,
        builder: (context, snapshot) {
          return !snapshot.hasData
              ? Center(child: CircularProgressIndicator())
              : snapshot.data!.size == 0
                  ? _begainBuildingCard()
                  : ListView.builder(
                      itemCount: snapshot.data!.size,
                      itemBuilder: (context, position) {
                        return FoundCard(
                          foundDate: snapshot.data!.docs[position]["found_id"],
                          age: snapshot.data!.docs[position]["age"],
                          fullName: snapshot.data!.docs[position]["name"],
                          gender: snapshot.data!.docs[position]["gender"],
                          lastPlace: snapshot.data!.docs[position]["place"],
                          missingImagePath: selectedPage == Page.MyFounds
                              ? snapshot.data!.docs[position]["image_url_1"]
                              : snapshot.data!.docs[position]["image_url_2"],
                          personId: selectedPage == Page.MyFounds
                              ? snapshot.data!.docs[position]["second_user_id"]
                              : snapshot.data!.docs[position]["main_user_id"],
                        );
                      },
                      shrinkWrap: true);
        });
  }

  _begainBuildingCard() {
    return Container(
      alignment: Alignment.topCenter,
      margin: EdgeInsets.all(20),
      child: Column(
        children: [
          Icon(
            Icons.insert_emoticon,
            size: 40,
            color: Colors.blue,
          ),
          SizedBox(height: 10),
          Text(
            "لا توجد طلبات تم إيجادها",
            style: TextStyle(color: Colors.blue),
          )
        ],
      ),
    );
  }
}
