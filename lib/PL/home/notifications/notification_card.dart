import 'package:finalmps/PL/utilites/helper/helper.dart';
import 'package:finalmps/models/notify_model.dart';
import 'package:finalmps/provider/missed_change.dart';
import 'package:finalmps/provider/notify_change.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../models/missed_model.dart';
import '../../utilites/widgets/custom_alert_dialog.dart';
import '../orders/add_missed/add_missed_1.dart';
import '../orders/orders_page/order_card/order_suggestions.dart';
import 'notify_details.dart';

class NotifyCard extends StatelessWidget {

  const NotifyCard({Key? key,this.notifyModel,this.notifyChange,this.missedModel,this.missedChange,this.userId}) : super(key: key);
  final NotifyModel? notifyModel;
  final NotifyChange? notifyChange;
  final MissedModel? missedModel;
  final MissedChange? missedChange;
  final String? userId;
  @override
  Widget build(BuildContext context) {
    bool orderRefused=notifyModel!.type == "refuse";
    return InkWell(
      onTap: () async {
        if(!orderRefused)
        await onNotificationSuggestTap(context: context);
      },
      child: Container(
          padding: EdgeInsets.all(10),
          color: notifyModel!.opened ==
              "yes"
              ? Colors.transparent
              :Theme.of(context).colorScheme.background==Colors.white? Colors.blue.withOpacity(.5):Colors.grey,
          child: Column(
            children: [
              Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  children: [
                    image(),
                    SizedBox(width: 10.0),
                    Flexible(
                      child: Container(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              notifyModel!.type ==
                                  "accept"
                                  ? "تمت الموافقة علي طلبك "
                                  : notifyModel!.type ==
                                  "suggest"
                                  ? "تم إقتراح اشخاص جديدة ل ${notifyModel!.orderName}"
                                  : notifyModel!.type ==
                                  "found"
                                  ? " طلبك ساعدنا في العثور علي${notifyModel!.orderName}"
                                  : "تم رفض طلبك " +
                                  "بإسم ${notifyModel!.orderName}",
                              style:
                              TextStyle(fontSize: 13),
                              maxLines: 1,
                            ),
                            Text(
                              orderRefused
                                  ? "السبب : ${notifyModel!.reason}"
                                  : "",
                              style:
                              TextStyle(fontSize: 12),
                              maxLines: 3,
                            ),
                            SizedBox(height: 10),
                            orderRefused
                                ? Row(
                                mainAxisAlignment:
                                MainAxisAlignment
                                    .start,
                                children: [
                                  ElevatedButton(
                                    onPressed: () async => await onUpdatePress(context: context),
                                    child: Text("تعديل"),),
                                  SizedBox(width: 10),
                                  ElevatedButton(
                                      onPressed: ()  async => await onDeletePress(),
                                      child: Text("حذف",),
                                  )
                                ])
                                : Container(),
                            SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                    deleteButton(context),
                  ]),
              Divider()
            ],
          )),
    );
  }

deleteButton(BuildContext context){
    return IconButton(
      icon: Icon(Icons.delete),
      onPressed: () => showDeleteDialog(context: context),
    );
}

  onNotificationSuggestTap(
      {BuildContext? context}) async {
    //when navigate

    if (notifyModel!.type == "suggest" || notifyModel!.type == "accept") {

      if ((notifyModel!.type == "suggest" && missedModel!.type == "فقد") ||
          notifyModel!.type == "accept" && missedModel!.type == "فقد") {
        Helper().goTo(context: context, to:OrderSuggestions(missedModel: missedModel,missedChange: missedChange));
      } else if (missedModel!.type == "شك") {
        Helper().goTo(context: context, to:NotifyDetails(
                  orderId: notifyModel!.orderId,
                  type: "accept"));
      }
    } else if (notifyModel!.type == "found") {
      Helper().goTo(context: context, to: NotifyDetails(
                orderId: notifyModel!.orderId,
                type: "found",
              ));
    }

    if (notifyModel!.type != "refuse")
      await updateToBeSeen();
  }

  onDeletePress() async {

        if (await missedChange!.deleteMissingOrder(
            id: notifyModel!.orderId,
            type: notifyModel!.type == "found" ? "شك" : "فقد",
            imageURL: notifyModel!.imageUrl) &&
            await notifyChange!.deleteNotifyByOrder(
                orderId: notifyModel!.orderId, userId:userId))
          Fluttertoast.showToast(
              msg: "تم حذف الطلب بالفعل", toastLength: Toast.LENGTH_LONG);

  }

  onUpdatePress(
      {required BuildContext context}) async {
    Helper().goTo(context: context, to: AddMissed1(
          orderId: missedModel!.id,
          type: missedModel!.type,
          addOrUpdate: "تعديل",
          imagePath: missedModel!.imageUrl,
          lastPlace: missedModel!.lastPlace,
          eyeColor: missedModel!.eyeColor,
          gender: missedModel!.gender,
          age: missedModel!.age,
          faceColor: missedModel!.faceColor,
          fullName: missedModel!.name,
          hairColor: missedModel!.hairColor,
          helthyStatus: missedModel!.helthyStatus));

    await updateToBeSeen( );
  }

  updateToBeSeen() async {
    //update cart status to be seen
    if(notifyModel!.opened == "no")
      await notifyChange!.updateSeen(userId: userId, notifyId: notifyModel!.id);
  }

  showDeleteDialog(
      {BuildContext? context}) {
    showDialog(
        context: context!,
        builder: (context) => CustomAlertDialog(
            title: "تنبيه",
            onPress: () async {
              Navigator.pop(context);
              await notifyChange!.deleteNotifyByNotifyId(notifyId: notifyModel!.id, userId: userId);
            },
            text: "هل تريد حذف هذا الإشعار بالفعل"));
  }

  image() {
    return ClipOval(
        child: Image.network(
          notifyModel!.imageUrl,
          width: 200,
          height: 200,
          fit: BoxFit.cover,
          errorBuilder: (a, x, d) =>
              Image.asset(
                "assets/images/errorimage.png",
                fit: BoxFit.cover,
                width:200,
                height: 200,
              ),
        )

    );
  }

}
