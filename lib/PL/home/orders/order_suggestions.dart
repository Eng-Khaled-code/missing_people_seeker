import 'package:finalmps/PL/utilites/custom_alert_dialog.dart';
import 'package:finalmps/PL/utilites/custom_streem_builder.dart';
import 'package:finalmps/provider/search_change.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalmps/models/missed_model.dart';
import 'dart:io';
import 'package:finalmps/provider/missed_change.dart';
import 'package:provider/provider.dart';
import 'package:finalmps/PL/utilites/loding_screen.dart';

class OrderSuggestions extends StatelessWidget {
  final String? imagePath;
  final String? helthyStatus;
  final String? fullName;
  final String? age;
  final String? gender;
  final String? lastPlace;
  final String? faceColor;
  final String? hairColor;
  final String? eyeColor;
  final String? orderId;

  static String? error;

  OrderSuggestions(
      {@required this.imagePath,
      @required this.helthyStatus,
      @required this.fullName,
      @required this.orderId,
      @required this.age,
      @required this.gender,
      @required this.lastPlace,
      @required this.faceColor,
      @required this.hairColor,
      @required this.eyeColor});

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    SearchChange searchChange = Provider.of<SearchChange>(context);
    MissedChange missedChange = Provider.of<MissedChange>(context);

    searchChange.loadSuggestedOrdersIds(orderId: orderId);


    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        key: _scaffoldKey,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => onPressSuggestionFalse(context, searchChange),
          label: Text("الشخص الذي ابحث عنه غير موجود بالإقتراحات"),
        ),
        appBar: AppBar(
          title: Text(
            "التفاصيل و الاقتراحات",
            style: TextStyle(color: Colors.black, fontSize: 16),
          ),
        ),
        body: Container(
          child: Stack(
            alignment: Alignment.center,
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
              missedChange.isLoading
                  ? LoadingScreen()
                  : SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.grey.withOpacity(.3),
                                      width: 4),
                                ),
                                width: double.infinity,
                                height: MediaQuery.of(context).size.height * .3,
                                child: Image.network(
                                  imagePath!,
                                  fit: BoxFit.fill,
                                  errorBuilder: (context, object, stackTrace) =>
                                      Image.asset(
                                    "assets/images/errorimage.png",
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Table(
                                defaultColumnWidth: FixedColumnWidth(140),
                                children: [
                                  TableRow(children: [
                                    Text("الاسم بالكامل :"),
                                    Text(fullName!)
                                  ]),
                                  TableRow(children: [
                                    Text("الجنس :"),
                                    Text(gender!)
                                  ]),
                                  TableRow(
                                      children: [Text("السن :"), Text(age!)]),
                                  TableRow(children: [
                                    Text("الحالة الصحية :"),
                                    Text(helthyStatus!)
                                  ]),
                                  TableRow(children: [
                                    Text("لون البشرة :"),
                                    Text(faceColor!)
                                  ]),
                                  TableRow(children: [
                                    Text("لون الشعر :"),
                                    Text(hairColor!)
                                  ]),
                                  TableRow(children: [
                                    Text("لون العين :"),
                                    Text(eyeColor!)
                                  ]),
                                  TableRow(children: [
                                    Text("اخر مكان وجد به :"),
                                    Text(lastPlace!)
                                  ]),
                                ],
                              ),
                            ),
                            Divider(),
                            Text(
                              "النتيجة",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 20),
                            Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.7,
                                child: searchChange.isLoading ||
                                        searchChange
                                            .getSuggestedOrdersIds.isEmpty
                                    ? Center(child: CircularProgressIndicator())
                                    : CustomStreemBuilder(
                                        stream: FirebaseFirestore.instance
                                            .collection("missed")
                                            .where(MissedModel.ID,
                                                whereIn: searchChange
                                                    .getSuggestedOrdersIds)
                                            .snapshots(),
                                        page: "suggest",
                                        mainOrderId: orderId!,
                                      )),
                          ],
                        ),
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }

  onPressSuggestionFalse(BuildContext context, SearchChange searchChange) {
    showDialog(
        context: context,
        builder: (context) => CustomAlertDialog(
              title: "تنبيه",
              onPress: () async {
                try {
                  final result = await InternetAddress.lookup('google.com');
                  if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                    if (searchChange.getSuggestedOrdersIds != [] ||
                        searchChange.getSuggestedOrdersIds != null) {
                      if (!await searchChange.updateSuggestion(
                          orderId: orderId,
                          ordersIds: searchChange.getSuggestedOrdersIds)) {
                        _scaffoldKey.currentState!.showSnackBar(SnackBar(
                            content: Text("${OrderSuggestions.error}")));
                      } else {
                        _scaffoldKey.currentState!.showSnackBar(SnackBar(
                            content: Text(
                                "سوف نقوم بإرسال إقتراحات جديدة لك عند توفر المعلومات المطلوبة")));
                        Navigator.pop(context);
                      }
                    } else {
                      _scaffoldKey.currentState!.showSnackBar(
                          SnackBar(content: Text("انت ليس لديك إقتراحات")));
                    }
                  }
                } on SocketException catch (_) {
                  Fluttertoast.showToast(
                      msg: "تأكد من إتصالك بالإنترنت",
                      toastLength: Toast.LENGTH_LONG);
                }
              },
              text:
                  "هل انت متاكد من ان الشخص الذي تبحث عنه غير موجود بالإقتراحات",
            ));
  }
}
