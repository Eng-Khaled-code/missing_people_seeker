import 'package:flutter/material.dart';
import 'package:finalmps/PL/utilites/custom_streem_builder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalmps/models/missed_model.dart';
import 'package:finalmps/models/user_model.dart';
import 'package:provider/provider.dart';
import 'package:finalmps/provider/user_change.dart';

class OrdersAboutMayBeMissed extends StatefulWidget {
  final String userId;

  OrdersAboutMayBeMissed(this.userId);

  @override
  _OrdersAboutMayBeMissedState createState() => _OrdersAboutMayBeMissedState();
}

class _OrdersAboutMayBeMissedState extends State<OrdersAboutMayBeMissed> {
  @override
  Widget build(BuildContext context) {
    UserChange user = Provider.of<UserChange>(context);

    return Directionality(
        textDirection: TextDirection.rtl,
        child: CustomStreemBuilder(
          stream: FirebaseFirestore.instance
              .collection(MissedModel.REF)
              .where(UserModel.ID, isEqualTo: widget.userId)
              .where("type", isEqualTo: "شك")
              .snapshots(),
          page: "mayBe",
          mainOrderId: "",
        ));
  }
}
