import 'package:finalmps/PL/utilites/widgets/custom_alert_dialog.dart';
import 'package:finalmps/PL/home/orders/orders_page/custom_streem_builder.dart';
import 'package:finalmps/provider/search_change.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalmps/models/missed_model.dart';
import 'package:finalmps/provider/missed_change.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../../../../authentication/loding_screen.dart';
import '../../../../utilites/text_style/text_styles.dart';
import '../../../../utilites/widgets/background_image.dart';
import 'card_details.dart';

class OrderSuggestions extends StatelessWidget {
  final MissedModel? missedModel;
  final MissedChange? missedChange;
  OrderSuggestions(
      {key,@required this.missedModel,this.missedChange}):super(key: key);

  @override
  Widget build(BuildContext context) {
    SearchChange searchChange = Provider.of<SearchChange>(context);

    searchChange.loadSuggestedOrdersIds(orderId: missedModel!.id);
    double height=MediaQuery.of(context).size.height;
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => onPressSuggestionFalse(context, searchChange),
        label: Text("الشخص الذي ابحث عنه غير موجود بالإقتراحات"),
      ),
      appBar: AppBar(
        title: Text(
          "التفاصيل و الاقتراحات",
        ),
      ),
      body: Container(
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
           BackgroundImage(),
            missedChange!.isLoading
                ? LoadingScreen(progressColor: Colors.blue,)
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          topImage(height),
                          CardDetailsTable(missedModel: missedModel,textStyle: TextStyle(color: Colors.white)),
                          Divider(),
                          Text(
                            "النتيجة",
                            style: TextStyles.title,
                          ),
                          SizedBox(height: 20),
                          Container(
                              height:
                                  height * 0.7,
                              child: searchChange.isLoading ||
                                      searchChange
                                          .getSuggestedOrdersIds.isEmpty
                                  ? Center(child: CircularProgressIndicator())
                                  : CustomStreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection("missed")
                                          .where(MissedModel.ID,
                                              whereIn: searchChange
                                                  .getSuggestedOrdersIds).snapshots()
                                          ,
                                      page: "suggest",
                                      mainOrderId: missedModel!.id,
                                    )),
                        ],
                      ),
                    ),
                  )
          ],
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

                    if (searchChange.getSuggestedOrdersIds != [] ||
                        searchChange.getSuggestedOrdersIds != null) {
                      Navigator.pop(context);
                      await searchChange.updateSuggestion(
                          orderId: missedModel!.id,
                          ordersIds: searchChange.getSuggestedOrdersIds);
                      }
                     else {
                      Fluttertoast.showToast(msg: "انت ليس لديك إقتراحات",toastLength: Toast.LENGTH_LONG);
                    }

              },
              text:
                  "هل انت متاكد من ان الشخص الذي تبحث عنه غير موجود بالإقتراحات",
            ));
  }

  topImage(double height) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
              color: Colors.grey.withOpacity(.3),
              width: 4),
        ),
        width: double.infinity,
        height: height * .3,
        child: Image.network(
          missedModel!.imageUrl,
          fit: BoxFit.fill,
          errorBuilder: (context, object, stackTrace) =>
              Image.asset(
                "assets/images/errorimage.png",
                fit: BoxFit.fill,
              ),
        ),
      ),
    );
  }
}
