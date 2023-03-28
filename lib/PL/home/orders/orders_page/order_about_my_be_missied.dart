import 'package:flutter/material.dart';
import 'package:finalmps/PL/home/orders/orders_page/custom_streem_builder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalmps/models/missed_model.dart';
import 'package:finalmps/models/user_model.dart';

class OrdersAboutMayBeMissed extends StatelessWidget {
  final String userId;

  OrdersAboutMayBeMissed(this.userId);

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: CustomStreamBuilder(
          stream: FirebaseFirestore.instance
              .collection(MissedModel.REF)
              .where(UserModel.ID, isEqualTo: userId)
              .where("type", isEqualTo: "شك")
              .snapshots(),
          page: "mayBe",
          mainOrderId: "",
        ));
  }
}
