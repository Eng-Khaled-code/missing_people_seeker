import 'package:finalmps/PL/utilites/strings.dart';
import 'package:finalmps/PL/utilites/widgets/no_data_card.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalmps/PL/home/orders/orders_page/order_card/order_card.dart';
import 'package:finalmps/models/missed_model.dart';

import '../../../authentication/loding_screen.dart';
import '../../../utilites/helper/helper.dart';

// ignore: must_be_immutable
class CustomStreamBuilder extends StatelessWidget {
  final Stream<QuerySnapshot>? stream;
  final String? page;

  // mainOrderId for the missing order not my be missed that i pass it from the suggestion page  when the suggestion is true
  final String? mainOrderId;
  String? screenSizeDesign;
  CustomStreamBuilder(
      {key, @required this.stream, @required this.page, this.mainOrderId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    screenSizeDesign = Helper().getDesignSize(context);
    double width = MediaQuery.of(context).size.width;
    return StreamBuilder<QuerySnapshot>(
        stream: stream,
        builder: (context, snapshot) {
          return !snapshot.hasData
              ? LoadingScreen(
                  progressColor: Colors.blue,
                )
              : snapshot.data!.size == 0
                  ? NoDataCard(
                      msg: page == "suggest"
                          ? "لا توجد إقتراحات في الوقت الحالي"
                          : "لا توجد طلبات")
                  : GridView.builder(
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                          childAspectRatio:
                              screenSizeDesign == Strings.smallDesign
                                  ? 0.8
                                  : 0.7,
                          maxCrossAxisExtent:
                              screenSizeDesign == Strings.smallDesign
                                  ? width
                                  : width * .4),
                      itemCount: snapshot.data!.size,
                      itemBuilder: (context, position) {
                        MissedModel missedModel = MissedModel.fromSnapshoot(
                            snapshot.data!.docs[position]);
                        return OrderCard(
                          missedModel: missedModel,
                          type: page!,
                          mainOrderId: mainOrderId,
                        );
                      },
                      shrinkWrap: true);
        });
  }
}
