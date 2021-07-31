import 'package:flutter/material.dart';
import 'package:finalmps/models/found_model.dart';
import 'package:finalmps/models/missed_model.dart';
import 'package:finalmps/provider/missed_change.dart';
import 'package:provider/provider.dart';
import 'package:finalmps/PL/utilites/found_card.dart';
import 'package:finalmps/PL/utilites/order_card.dart';

class NotifyDetails extends StatelessWidget {
  final String? type;
  final String? orderId;
  NotifyDetails({@required this.type, @required this.orderId});
  FoundModel foundModel=FoundModel();
  MissedModel missedModel=MissedModel();

  loadOrderData(MissedChange missedChange) async {
    if (type == "found") {
      foundModel = await missedChange.loadFoundOrderData(foundOrderId: orderId);
    } else {
      missedModel = await missedChange.loadOrderData(orderId: orderId);
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    MissedChange missedChange = Provider.of<MissedChange>(context);

    loadOrderData(missedChange);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: (type == "found" && foundModel == null) ||
                  (type == "accept" && missedModel == null)
              ? Container(
                  width: 20,
                  height: 20,
                  child: Center(
                      child: CircularProgressIndicator(
                    strokeWidth: .7,
                  )))
              : Text(
                  type == "found"
                      ? foundModel.name
                      : missedModel.name == ""
                          ? "الاسم غير موجود"
                          : missedModel.name,
                  style:
                      TextStyle(color: Colors.black54, fontSize: width * .039),
                ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Icon(
                Icons.done,
                color: Colors.green,
              ),
            )
          ],
        ),
        body: Container(
          child: Stack(
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
              (type == "found" && foundModel == null) ||
                      (type == "accept" && missedModel == null)
                  ? Center(child: CircularProgressIndicator())
                  : type == "found"
                      ? FoundCard(
                          age: foundModel.age,
                          foundDate: foundModel.id,
                          fullName: foundModel.name,
                          gender: foundModel.gender,
                          lastPlace: foundModel.place,
                          missingImagePath: foundModel.imageUrl2,
                          personId: foundModel.secondUserId)
                      : OrderCard(
                          age: missedModel.age,
                          eyeColor: missedModel.eyeColor,
                          faceColor: missedModel.faceColor,
                          fullName: missedModel.name,
                          gender: missedModel.gender,
                          hairColor: missedModel.hairColor,
                          helthyStatus: missedModel.helthyStatus,
                          imagePath: missedModel.imageUrl,
                          type: missedModel.type,
                          status: missedModel.status,
                          lastPlace: missedModel.lastPlace,
                          publishDate: missedModel.publishDate,
                          id: missedModel.id),
            ],
          ),
        ),
      ),
    );
  }
}
