import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalmps/PL/utilites/order_card.dart';
import 'package:finalmps/models/missed_model.dart';

class CustomStreemBuilder extends StatelessWidget {
  Stream<QuerySnapshot>? stream;
  String? page;

  // mainOrderId for the missing order not my be missed that i pass it from the suggestion page  when the suggestion is true
  String? mainOrderId;

  CustomStreemBuilder(
      {@required this.stream, @required this.page, this.mainOrderId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: stream,
        builder: (context, snapshot) {
          return !snapshot.hasData
              ? Center(
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.cyanAccent)),
                )
              : snapshot.data!.size == 0
                  ? _begainBuildingCard()
                  : ListView.builder(
                      itemCount: snapshot.data!.size,
                      itemBuilder: (context, position) {
                        return OrderCard(
                          status: snapshot.data!.docs[position]
                              [MissedModel.STATUS],
                          imagePath: snapshot.data!.docs[position]
                              [MissedModel.IMAGE_URL],
                          helthyStatus: snapshot.data!.docs[position]
                              [MissedModel.HELTHY_STATUS],
                          fullName: snapshot.data!.docs[position]
                                  [MissedModel.NAME] ??
                              " ",
                          age: snapshot.data!.docs[position][MissedModel.AGE] ??
                              " ",
                          gender: snapshot.data!.docs[position]
                              [MissedModel.GENDER],
                          lastPlace: snapshot.data!.docs[position]
                              [MissedModel.LAST_PLACE],
                          faceColor: snapshot.data!.docs[position]
                              [MissedModel.FACE_COLOR],
                          hairColor: snapshot.data!.docs[position]
                              [MissedModel.HAIR_COLOR],
                          eyeColor: snapshot.data!.docs[position]
                              [MissedModel.EYE_COLOR],
                          publishDate: snapshot.data!.docs[position]
                              [MissedModel.PUBLISH_DATE],
                          type: page!,
                          id: snapshot.data!.docs[position][MissedModel.ID],
                          mainOrderId: mainOrderId,
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
            page == "suggest"
                ? "لا توجد إقتراحات في الوقت الحالي"
                : "لا توجد طلبات",
            style: TextStyle(color: Colors.blue),
          )
        ],
      ),
    );
  }
}
