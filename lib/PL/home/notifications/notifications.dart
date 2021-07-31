import 'dart:io';
import 'package:finalmps/PL/utilites/custom_chat_or_notify.dart';
import 'package:finalmps/PL/utilites/custom_alert_dialog.dart';
import 'package:finalmps/PL/utilites/drawer.dart';
import 'package:finalmps/provider/missed_change.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:finalmps/models/notify_model.dart';
import 'package:provider/provider.dart';
import 'package:finalmps/provider/notify_change.dart';
import 'package:finalmps/PL/home/orders/order_suggestions.dart';
import 'package:finalmps/PL/home/orders/add_missed/add_missed_1.dart';
import 'package:finalmps/models/missed_model.dart';
import 'package:finalmps/PL/home/chat/chat_list.dart';
import 'package:finalmps/provider/chat_change.dart';
import 'package:finalmps/PL/home/notifications/notify_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationPage extends StatefulWidget {
  final String? userId;

  NotificationPage({this.userId});

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  Map<String, MissedModel> _notificationsOrderDataMap = Map();

  loadOrderDataMap(NotifyChange notifyChange, MissedChange missedChange) {
    if (notifyChange.getNotificationsList != null ||
        notifyChange.getNotificationsList != []) {
      notifyChange.getNotificationsList.forEach((element) async {
        if (element.type != "found") {
          MissedModel _missedModel =
              await missedChange.loadOrderData(orderId: element.orderId);
          _notificationsOrderDataMap[element.id] = _missedModel;
        } else {
          _notificationsOrderDataMap[element.id] = MissedModel();
        }
      });
    }
  }

  loadNotificationsCount({NotifyChange? notifyChange}) async {
    await notifyChange!.loadLastDate(userId: widget.userId);
    await notifyChange.loadNotifyCount(
        userId: widget.userId, date: notifyChange.getLastDate);
  }

  // loadRecentMessageCount({ChatChange chatChange}) async {
  //   await chatChange.loadLastDate(userId: widget.userId);
  //   await chatChange.updateRecentMesagesCount(
  //       date: chatChange.getLastDate, userId: widget.userId);

  //   await chatChange.loadRecentMessagesCount(userId: widget.userId);
  // }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    NotifyChange notifyChange = Provider.of<NotifyChange>(context);
    MissedChange missedChange = Provider.of<MissedChange>(context);
    ChatChange chatChange = Provider.of<ChatChange>(context);

    loadNotificationsCount(notifyChange: notifyChange);
    // loadRecentMessageCount(chatChange: chatChange);
    loadOrderDataMap(notifyChange, missedChange);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "الإشعارات",
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            notificationWidget(context: context, notifyChange: notifyChange),
            chatWidget(context: context, chatChange: chatChange)
          ],
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF1E88E5),
                  Color(0xFF0D47A1),
                ],
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
              ),
            ),
          ),
        ),
        drawer: CustomDrawer(),
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
              listBody(
                  missedChange: missedChange,
                  notifyChange: notifyChange,
                  context: context,
                  width: width,
                  height: height),
            ],
          ),
        ),
      ),
    );
  }

  Widget listBody(
      {BuildContext? context,
      NotifyChange? notifyChange,
      MissedChange? missedChange,
      double? width,
      double? height}) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection(NotifyModel.REF)
            .doc(widget.userId)
            .collection(NotifyModel.SUB_COLLECTIN_REF)
            .where(NotifyModel.USER_ID, isEqualTo: widget.userId)
            .snapshots(),
        builder: (context, snapshot) {
          return !snapshot.hasData ||
                  notifyChange!.getNotificationsList == null ||
                  _notificationsOrderDataMap == null
              ? Center(child: CircularProgressIndicator())
              : snapshot.data!.size == 0
                  ? _begainBuildingCard()
                  : ListView.builder(
                      itemCount: snapshot.data!.size,
                      itemBuilder: (context, position) {
                        List<QueryDocumentSnapshot> data = snapshot.data!.docs;
                        return InkWell(
                          onTap: () async {
                            data[position].get(NotifyModel.TYPE) == "refuse"
                                ? () {}
                                : await onNotificationSuggestTap(
                                    context: context,
                                    notifyModel: NotifyModel.fromSnapshoot(
                                        data[position]),
                                    orderData: _notificationsOrderDataMap[
                                        data[position].get(NotifyModel.ID)]!,
                                    notifyChange: notifyChange);
                          },
                          child: Container(
                              padding: EdgeInsets.all(10),
                              color: data[position].get(NotifyModel.OPENED) ==
                                      "yes"
                                  ? Colors.transparent
                                  : Colors.blue.withOpacity(.5),
                              child: Column(
                                children: [
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        ClipRRect(
                                          clipBehavior: Clip.hardEdge,
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                          child: Image.network(
                                            data[position]
                                                .get(NotifyModel.IMAGE_URL),
                                            width: width! * .25,
                                            height: width * .25,
                                            fit: BoxFit.cover,
                                            errorBuilder: (a, x, d) =>
                                                Image.asset(
                                              "assets/images/errorimage.png",
                                              fit: BoxFit.cover,
                                              width: width * .25,
                                              height: width * .25,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10.0),
                                        Flexible(
                                          child: Container(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  data[position].get(NotifyModel
                                                              .TYPE) ==
                                                          "accept"
                                                      ? "تمت الموافقة علي طلبك "
                                                      : data[position].get(
                                                                  NotifyModel
                                                                      .TYPE) ==
                                                              "suggest"
                                                          ? "تم إقتراح اشخاص جديدة ل ${data[position].get(NotifyModel.ORDER_NAME)}"
                                                          : data[position].get(
                                                                      NotifyModel
                                                                          .TYPE) ==
                                                                  "found"
                                                              ? " طلبك ساعدنا في العثور علي${data[position].get(NotifyModel.ORDER_NAME)}"
                                                              : "تم رفض طلبك " +
                                                                  "بإسم ${data[position].get(NotifyModel.ORDER_NAME)}",
                                                  style:
                                                      TextStyle(fontSize: 13),
                                                  maxLines: 1,
                                                ),
                                                Text(
                                                  data[position].get(NotifyModel
                                                              .TYPE) ==
                                                          "refuse"
                                                      ? "السبب : ${data[position].get(NotifyModel.REASON)}"
                                                      : "",
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                  maxLines: 3,
                                                ),
                                                SizedBox(height: 10),
                                                data[position].get(
                                                            NotifyModel.TYPE) ==
                                                        "refuse"
                                                    ? Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                            RaisedButton(
                                                              onPressed:
                                                                  () async {
                                                                await onUpdatePress(
                                                                    notifyChange:
                                                                        notifyChange,
                                                                    context:
                                                                        context,
                                                                    notifyModel:
                                                                        NotifyModel.fromSnapshoot(
                                                                            data[position]));
                                                              },
                                                              color:
                                                                  Colors.blue,
                                                              textColor:
                                                                  Colors.white,
                                                              child: Text(
                                                                  "تعديل",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          12)),
                                                            ),
                                                            SizedBox(width: 10),
                                                            RaisedButton(
                                                              onPressed: () async => await onDeletePress(
                                                                  notifyModel: NotifyModel
                                                                      .fromSnapshoot(
                                                                          data[
                                                                              position]),
                                                                  notifyChange:
                                                                      notifyChange,
                                                                  missedChange:
                                                                      missedChange!),
                                                              color:
                                                                  Colors.white,
                                                              textColor: Colors
                                                                  .black54,
                                                              child: Text("حذف",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          12)),
                                                            )
                                                          ])
                                                    : Container(),
                                                SizedBox(height: 10),
                                              ],
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.delete),
                                          onPressed: () => showDeleteDialog(
                                              notifyModel:
                                                  NotifyModel.fromSnapshoot(
                                                      data[position]),
                                              context: context,
                                              notifyChange: notifyChange),
                                        ),
                                      ]),
                                  Divider()
                                ],
                              )),
                        );
                      },
                      reverse: true,
                      shrinkWrap: true);
        });
  }

  _begainBuildingCard() {
    return Container(
      alignment: Alignment.topCenter,
      margin: EdgeInsets.all(20),
      child: Column(
        children: [
          Icon(
            Icons.insert_emoticon,
            size: 40,
            color: Colors.blue,
          ),
          SizedBox(height: 10),
          Text(
            "لا توجد إشعارات",
            style: TextStyle(color: Colors.blue),
          )
        ],
      ),
    );
  }

  onNotificationSuggestTap(
      {BuildContext? context,
      NotifyModel? notifyModel,
      NotifyChange? notifyChange,
      MissedModel? orderData}) async {
    //when navigate

    if (notifyModel!.type == "suggest" || notifyModel.type == "accept") {
      if ((notifyModel.type == "suggest" && orderData!.type == "فقد") ||
          notifyModel.type == "accept" && orderData!.type == "فقد") {
        Navigator.push(
            context!,
            MaterialPageRoute(
                builder: (context) => OrderSuggestions(
                      orderId: orderData.id,
                      imagePath: orderData.imageUrl,
                      lastPlace: orderData.lastPlace,
                      eyeColor: orderData.eyeColor,
                      gender: orderData.gender,
                      age: orderData.age,
                      faceColor: orderData.faceColor,
                      fullName: orderData.name,
                      hairColor: orderData.hairColor,
                      helthyStatus: orderData.helthyStatus,
                    )));
      } else if (orderData!.type == "شك") {
        Navigator.push(
            context!,
            MaterialPageRoute(
                builder: (context) => NotifyDetails(
                      orderId: notifyModel.orderId,
                      type: "accept",
                    )));
      }
    } else if (notifyModel.type == "found") {
      Navigator.push(
          context!,
          MaterialPageRoute(
              builder: (context) => NotifyDetails(
                    orderId: notifyModel.orderId,
                    type: "found",
                  )));
    }

    if (notifyModel.type != "refuse")
      await updateToBeSeen(
          notifyChange: notifyChange!,
          notifyId: notifyModel.id,
          opened: notifyModel.opened);
  }

  onDeletePress(
      {required NotifyModel notifyModel,
      NotifyChange? notifyChange,
      MissedChange? missedChange}) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        if (await missedChange!.deleteMissingOrder(
                id: notifyModel.orderId,
                type: notifyModel.type == "found" ? "شك" : "فقد",
                imageURL: notifyModel.imageUrl) &&
            await notifyChange!.deleteNotifyByOrder(
                orderId: notifyModel.orderId, userId: widget.userId))
          Fluttertoast.showToast(
              msg: "تم حذف الطلب بالفعل", toastLength: Toast.LENGTH_LONG);
      }
    } on SocketException catch (_) {
      Fluttertoast.showToast(
          msg: "تأكد من إتصالك بالإنترنت", toastLength: Toast.LENGTH_LONG);
    }
  }

  onUpdatePress(
      {required BuildContext context,
      required NotifyModel notifyModel,
      required NotifyChange notifyChange,
      MissedModel? orderData}) async {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AddMissed1(
          orderId: orderData!.id,
          type: orderData.type,
          addOrUpdate: "تعديل",
          imagePath: orderData.imageUrl,
          lastPlace: orderData.lastPlace,
          eyeColor: orderData.eyeColor,
          gender: orderData.gender,
          age: orderData.age,
          faceColor: orderData.faceColor,
          fullName: orderData.name,
          hairColor: orderData.hairColor,
          helthyStatus: orderData.helthyStatus);
    }));

    await updateToBeSeen(
        notifyChange: notifyChange,
        notifyId: notifyModel.id,
        opened: notifyModel.opened);
  }

  updateToBeSeen(
      {required String opened,
      required String notifyId,
      required NotifyChange notifyChange}) async {
    //update cart status to be seen
    opened == "no"
        ? await notifyChange.updateSeen(
            userId: widget.userId, notifyId: notifyId)
        : () {};
  }

  showDeleteDialog(
      {BuildContext? context,
      NotifyChange? notifyChange,
      NotifyModel? notifyModel}) {
    showDialog(
        context: context!,
        builder: (context) => CustomAlertDialog(
            title: "تنبيه",
            onPress: () async {
              Navigator.pop(context);
              if (await notifyChange!.deleteNotifyByNotifyId(
                  notifyId: notifyModel!.id, userId: widget.userId)) {
                Fluttertoast.showToast(
                    msg: "تم حذف الاشعار بالفعل",
                    toastLength: Toast.LENGTH_LONG);
              }
            },
            text: "هل تريد حذف هذا الإشعار بالفعل"));
  }

  Widget notificationWidget(
      {NotifyChange? notifyChange, BuildContext? context}) {
    return CustomChatNotifyWidget(
        icon: Icons.notifications_none,
        onPress: () async {
          await notifyChange!.updateLastDate(userId: widget.userId);
        },
        count: int.tryParse(notifyChange!.getNotificationsCount));
  }

  Widget chatWidget({ChatChange? chatChange, BuildContext? context}) {
    return CustomChatNotifyWidget(
        icon: CupertinoIcons.chat_bubble_2,
        onPress: () async {
          Navigator.push(
              context!,
              MaterialPageRoute(
                  builder: (context) => ChatList(
                        userId: widget.userId,
                      )));
          //await chatChange.updateLastDate(userId: widget.userId);
        },
        count: 0);
    // count: chatChange.getRecentMessagesCount);
  }
}
