import 'package:flutter/material.dart';
import 'package:finalmps/models/found_model.dart';
import 'package:finalmps/models/missed_model.dart';
import 'package:finalmps/provider/missed_change.dart';
import 'package:provider/provider.dart';
import 'package:finalmps/PL/home/found_people/found_card.dart';
import 'package:finalmps/PL/home/orders/orders_page/order_card/order_card.dart';
import '../../utilites/widgets/background_image.dart';

// ignore: must_be_immutable
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
    MissedChange missedChange = Provider.of<MissedChange>(context);

    loadOrderData(missedChange);

    return (type == "found" && foundModel == null) ||
        (type == "accept" && missedModel == null)
        ?
    Material(child:Center(child: CircularProgressIndicator()))
        :
    Scaffold(
      appBar:appBar(width),
      body: Container(
        child: Stack(
          children: <Widget>[
            BackgroundImage(),
            type == "found"
                ? FoundCard(foundModel: foundModel,myFound: true)
                : OrderCard(missedModel: missedModel,type: missedModel.type,
            ),
          ],
        ),
      ),
    );
  }

  AppBar appBar(double width) {
    return  AppBar(
      title:Text(
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
    );
  }
}
