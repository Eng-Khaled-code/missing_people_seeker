import 'package:flutter/material.dart';
import 'package:finalmps/PL/utilites/custom_streem_builder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalmps/models/missed_model.dart';
import 'package:finalmps/models/user_model.dart';

class OrdersAboutMissing extends StatefulWidget {
  final String userId;

  OrdersAboutMissing(this.userId);

  @override
  _OrdersAboutMissingState createState() => _OrdersAboutMissingState();
}

class _OrdersAboutMissingState extends State<OrdersAboutMissing> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: CustomStreemBuilder(
          stream: FirebaseFirestore.instance
              .collection(MissedModel.REF)
              .where(UserModel.ID, isEqualTo: widget.userId)
              .where("type", isEqualTo: "فقد")
              .snapshots(),
          page: "missed",
          mainOrderId: "",
        ));
  }
}
