import 'package:finalmps/provider/missed_change.dart';
import 'package:flutter/material.dart';
import 'package:finalmps/models/notify_model.dart';
import 'package:provider/provider.dart';
import 'package:finalmps/provider/notify_change.dart';
import 'package:finalmps/models/missed_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../utilites/widgets/background_image.dart';
import '../../utilites/widgets/no_data_card.dart';
import '../home_page/home_app_bar.dart';
import 'notification_card.dart';

// ignore: must_be_immutable
class NotificationPage extends StatelessWidget {
  final String? userId;
  final NotifyChange? notifyChange;

  NotificationPage({this.userId, this.notifyChange});

  Map<String, MissedModel> _notificationsOrderDataMap = Map();

  loadOrderDataMap(MissedChange missedChange) {
    if (notifyChange!.notificationsList != null ||
        notifyChange!.notificationsList != []) {
      notifyChange!.notificationsList!.forEach((element) async {
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

  @override
  Widget build(BuildContext context) {
    MissedChange missedChange = Provider.of<MissedChange>(context);
    loadOrderDataMap(missedChange);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: HomeAppBar(
          title: "الإشعارات",
          notifyChange: notifyChange,
          userId: userId,
        ),
        body: Stack(
          children: <Widget>[
            BackgroundImage(),
            listBody(
              missedChange: missedChange,
              context: context,
            ),
          ],
        ),
      ),
    );
  }

  Widget listBody({
    BuildContext? context,
    MissedChange? missedChange,
  }) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection(NotifyModel.REF)
            .doc(userId)
            .collection(NotifyModel.SUB_COLLECTIN_REF)
            .where(NotifyModel.USER_ID, isEqualTo: userId)
            .snapshots(),
        builder: (context, snapshot) {
          return !snapshot.hasData ||
                  notifyChange!.lastDate == null ||
                  _notificationsOrderDataMap == null
              ? Center(child: CircularProgressIndicator())
              : snapshot.data!.size == 0
                  ? NoDataCard(msg: "لا توجد إشعارات")
                  : ListView.builder(
                      itemCount: snapshot.data!.size,
                      itemBuilder: (context, position) {
                        List<QueryDocumentSnapshot> data = snapshot.data!.docs;
                        NotifyModel model =
                            NotifyModel.fromSnapshoot(data[position]);
                        return NotifyCard(
                          userId: userId,
                          notifyChange: notifyChange,
                          missedChange: missedChange,
                          notifyModel: model,
                          missedModel: _notificationsOrderDataMap[model.id],
                        );
                      },
                      reverse: true,
                      shrinkWrap: true);
        });
  }
}
