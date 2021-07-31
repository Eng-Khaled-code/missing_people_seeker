import 'package:cached_network_image/cached_network_image.dart';
import 'package:finalmps/PL/home/orders/add_missed/add_missed_1.dart';
import 'package:finalmps/PL/home/orders/order_suggestions.dart';
import 'package:finalmps/PL/utilites/custom_alert_dialog.dart';
import 'package:finalmps/PL/utilites/custom_button.dart';
import 'package:finalmps/provider/notify_change.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:finalmps/provider/missed_change.dart';
import 'package:finalmps/provider/user_change.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:finalmps/PL/home/notifications/notify_details.dart';

class OrderCard extends StatelessWidget {
  final String? id;
  final String? status;
  final String? imagePath;
  final String? helthyStatus;
  final String? fullName;
  final String? age;
  final String? gender;
  final String? lastPlace;
  final String? faceColor;
  final String? hairColor;
  final String? eyeColor;
  final String? type;
  final String? publishDate;

  // mainOrderId for the missing order not my be missed that i pass it from the suggestion page  when the suggestion is true
  String? mainOrderId;

  static String? error;
  TextStyle textStyle = TextStyle(color: Colors.white);
  OrderCard(
      {@required this.id,
      @required this.status,
      @required this.imagePath,
      @required this.helthyStatus,
      @required this.fullName,
      @required this.age,
      @required this.gender,
      @required this.lastPlace,
      @required this.faceColor,
      @required this.hairColor,
      @required this.eyeColor,
      @required this.type,
      @required this.publishDate,
      this.mainOrderId});

  @override
  Widget build(BuildContext context) {
    MissedChange missedChange = Provider.of<MissedChange>(context);
    NotifyChange notifyChange = Provider.of<NotifyChange>(context);

    return InkWell(
      onTap: () {
        if (type == "missed" || type == "mayBe")
          showCustomBottomSheet(
              context: context,
              status: status!,
              missedChange: missedChange,
              notifyChange: notifyChange);
        else if (type == "suggest") {
          onPressSuggestionTrue(
            context: context,
            missedChange: missedChange,
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF1E88E5),
                  Color(0xFF0D47A1),
                ],
              ),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 2,
                )
              ]),
          padding: EdgeInsets.all(5.0),
          child: Column(
            children: [
              Row(children: [
                Text(
                  "  تاريخ النشر: " +
                      DateFormat("a").format(
                          DateTime.fromMicrosecondsSinceEpoch(
                              int.parse(publishDate!))),
                  style: textStyle,
                ),
                Text(
                    "  " +
                        DateTime.fromMicrosecondsSinceEpoch(
                                int.parse(publishDate!))
                            .hour
                            .toString() +
                        ":" +
                        DateTime.fromMicrosecondsSinceEpoch(
                                int.parse(publishDate!))
                            .minute
                            .toString() +
                        "      " +
                        DateTime.fromMicrosecondsSinceEpoch(
                                int.parse(publishDate!))
                            .day
                            .toString() +
                        "/" +
                        DateTime.fromMicrosecondsSinceEpoch(
                                int.parse(publishDate!))
                            .month
                            .toString() +
                        "/" +
                        DateTime.fromMicrosecondsSinceEpoch(
                                int.parse(publishDate!))
                            .year
                            .toString(),
                    style: textStyle)
              ]),
              SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  placeholder: (context, url) {
                    return Container(
                      padding: EdgeInsets.all(10.0),
                      child: CircularProgressIndicator(
                          strokeWidth: 1, color: Colors.white),
                    );
                  },
                  imageUrl: imagePath!,
                  width: double.infinity,
                  height: 300,
                  fit: BoxFit.fill,
                  errorWidget: (a, x, d) => Image.asset(
                    "assets/images/errorimage.png",
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              type == "suggest" ? Container() : statusRow(),
              SizedBox(height: 10.0),
              Table(
                defaultColumnWidth: FixedColumnWidth(140),
                children: [
                  TableRow(children: [
                    Text("الاسم بالكامل :", style: textStyle),
                    Text("$fullName", style: textStyle)
                  ]),
                  TableRow(children: [
                    Text("الجنس :", style: textStyle),
                    Text(gender!, style: textStyle)
                  ]),
                  TableRow(children: [
                    Text("السن :", style: textStyle),
                    Text("$age", style: textStyle)
                  ]),
                  TableRow(children: [
                    Text("الحالة الصحية :", style: textStyle),
                    Text(helthyStatus!, style: textStyle)
                  ]),
                  TableRow(children: [
                    Text("لون البشرة :", style: textStyle),
                    Text(faceColor!, style: textStyle)
                  ]),
                  TableRow(children: [
                    Text("لون الشعر :", style: textStyle),
                    Text(hairColor!, style: textStyle)
                  ]),
                  TableRow(children: [
                    Text("لون العين :", style: textStyle),
                    Text(eyeColor!, style: textStyle)
                  ]),
                  TableRow(children: [
                    Text("اخر مكان وجد به :", style: textStyle),
                    Text(lastPlace!, style: textStyle)
                  ]),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget statusRow() {
    return //0 for waitting
        //1 for success
        //2 for faild
        Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("الحالة", style: textStyle),
          Text(
              status == "0"
                  ? "أنتظر"
                  : status == "1"
                      ? "مقبول"
                      : "مرفوض",
              style: textStyle),
          Icon(
            status == "0"
                ? Icons.more_horiz
                : status == "1"
                    ? Icons.check
                    : Icons.clear,
            color: status == "0"
                ? Colors.white
                : status == "1"
                    ? Colors.green
                    : Colors.red,
            size: 30,
          )
        ],
      ),
    );
  }

  onPressSuggestionTrue({
    BuildContext? context,
    MissedChange? missedChange,
  }) {
    showDialog(
        context: context!,
        builder: (context) => CustomAlertDialog(
            title: "تنبيه",
            text: "هل انت متاكد من ان هذا الشخص هو الذي تبحث عنه",
            onPress: () async {
              try {
                final result = await InternetAddress.lookup('google.com');
                if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                  String docId =
                      DateTime.now().millisecondsSinceEpoch.toString();

                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pop(context);
                  await firestoreSuggestionTrueOperations(
                      missedChange: missedChange!,
                      context: context,
                      docId: docId);

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NotifyDetails(
                                type: "found",
                                orderId: docId,
                              )));
                }
              } on SocketException catch (_) {
                Fluttertoast.showToast(
                    msg: "تأكد من إتصالك بالإنترنت",
                    toastLength: Toast.LENGTH_LONG);
              }
            }));
  }

  firestoreSuggestionTrueOperations(
      {MissedChange? missedChange, BuildContext? context, docId}) async {
    if (await missedChange!.addFoundOrder(
        missedOrderId: mainOrderId,
        mayBeMissedOrderId: id,
        foundOrderId: docId)) {
      Fluttertoast.showToast(
        msg: "تمت إضافة هذا الطلب الي شاشة الاشخاص الذين تم العثور عليهم",
        toastLength: Toast.LENGTH_LONG,
      );
    } else {
      Fluttertoast.showToast(
        msg: "خطأ " + error!,
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }

  showCustomBottomSheet(
      {BuildContext? context,
      String? status,
      MissedChange? missedChange,
      NotifyChange? notifyChange}) {
    showModalBottomSheet(
        isDismissible: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        context: context!,
        builder: (context) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text("ما الذي تريد فعله بهذا الطلب؟"),
              ),
              status == "1" && type == "missed"
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 5),
                      child: CustomButton(
                          color: [Color(0xFF0000FF), Color(0xFFFF3500)],
                          text: "عرض",
                          onPress: () => navigateToSuggestionPage(context),
                          textColor: Colors.blue),
                    )
                  : Container(),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
                child: CustomButton(
                    color: [Color(0xFF1E88E5), Color(0xFF0D47A1)],
                    text: "تعديل",
                    onPress: () => navigateToUpdatePage(context),
                    textColor: Colors.white),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
                child: CustomButton(
                    color: [Color(0xFF1E88E5), Color(0xFF0D47A1)],
                    text: "حذف",
                    onPress: () => deleteOrder(
                        notifyChange: notifyChange!,
                        missedChange: missedChange!,
                        context: context),
                    textColor: Colors.white),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
                child: CustomButton(
                    color: [Color(0xFF1E88E5), Color(0xFF0D47A1)],
                    text: "إغلاق",
                    onPress: () => Navigator.pop(context),
                    textColor: Colors.white),
              ),
            ],
          );
        });
  }

  navigateToUpdatePage(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AddMissed1(
                orderId: id,
                type: type == "mayBe" ? "شك" : "فقد",
                addOrUpdate: "تعديل",
                imagePath: imagePath,
                helthyStatus: helthyStatus,
                fullName: fullName,
                age: age,
                gender: gender,
                lastPlace: lastPlace,
                faceColor: faceColor,
                hairColor: hairColor,
                eyeColor: eyeColor)));
  }

  navigateToSuggestionPage(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => OrderSuggestions(
                orderId: id,
                imagePath: imagePath,
                helthyStatus: helthyStatus,
                fullName: fullName,
                age: age,
                gender: gender,
                lastPlace: lastPlace,
                faceColor: faceColor,
                hairColor: hairColor,
                eyeColor: eyeColor)));
  }

  deleteOrder(
      {MissedChange? missedChange,
      NotifyChange? notifyChange,
      BuildContext? context}) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        UserChange userChange =
            Provider.of<UserChange>(context!, listen: false);
        if (await missedChange!
                .deleteMissingOrder(id: id, type: type, imageURL: imagePath) &&
            await notifyChange!.deleteNotifyByOrder(
                userId: userChange.userInformation.id, orderId: id)) {
          Fluttertoast.showToast(
              msg: "تم حذف الطلب بالفعل", toastLength: Toast.LENGTH_LONG);
          Navigator.pop(context);
        } else {
          Fluttertoast.showToast(
              msg: error! + "خطأ ", toastLength: Toast.LENGTH_LONG);
        }
      }
    } on SocketException catch (_) {
      Fluttertoast.showToast(
          msg: "تأكد من إتصالك بالإنترنت", toastLength: Toast.LENGTH_LONG);
    }
  }
}
