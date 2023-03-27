import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalmps/models/notify_model.dart';
import 'package:finalmps/models/missed_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotifyServices {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late SharedPreferences prefs;

  Future<List<NotifyModel>> loadNotificationsList(String? userId) async {
    List<NotifyModel>? notifyList;
          QuerySnapshot snapshot=await firestore
          .collection(NotifyModel.REF)
          .doc(userId)
          .collection(NotifyModel.SUB_COLLECTIN_REF)
          .where(NotifyModel.USER_ID, isEqualTo: userId)
          .get();

    snapshot.docs.forEach((element){
      NotifyModel _notifyModel = NotifyModel.fromSnapshoot(element);
      notifyList!.add(_notifyModel);
    });

      return notifyList!;

  }

  Future<void> updateSeen({String? userId, String? notifyId}) async {
    await firestore
        .collection(NotifyModel.REF)
        .doc(userId)
        .collection(NotifyModel.SUB_COLLECTIN_REF)
        .doc(notifyId)
        .update({NotifyModel.OPENED: "yes"});
  }

  Future<void> addFoundNotifys(
      {String? userId,
      String? foundOrderId,
      String? secondUserImageUrl,
      String? foundName}) async {

    String docId = DateTime.now().millisecondsSinceEpoch.toString();

    Map<String, dynamic> values = {
      NotifyModel.DATE_TIME: docId,
      NotifyModel.IMAGE_URL: secondUserImageUrl,
      NotifyModel.ID: docId,
      NotifyModel.OPENED: "no",
      NotifyModel.ORDER_ID: foundOrderId,
      NotifyModel.REASON: "",
      NotifyModel.ORDER_NAME: foundName,
      NotifyModel.TYPE: "found",
      NotifyModel.USER_ID: userId,
    };

    await firestore
        .collection(NotifyModel.REF)
        .doc(userId)
        .collection(NotifyModel.SUB_COLLECTIN_REF)
        .doc(docId)
        .set(values);
  }

  Future<void> deleteNotifys({String? userId, String? orderId}) async {
   QuerySnapshot snapshot=  await firestore
        .collection(NotifyModel.REF)
        .doc(userId)
        .collection(NotifyModel.SUB_COLLECTIN_REF)
        .where("order_id", isEqualTo: orderId)
        .get();

      snapshot.docs.forEach((element) async {
        await firestore
            .collection(NotifyModel.REF)
            .doc(userId)
            .collection(NotifyModel.SUB_COLLECTIN_REF)
            .doc(element.get("notify_id"))
            .delete();
      });

  }

  Future<void> deleteNotifyById({String? userId, String? notifyId}) async {
    await firestore
        .collection(NotifyModel.REF)
        .doc(userId)
        .collection(NotifyModel.SUB_COLLECTIN_REF)
        .doc(notifyId)
        .delete();
  }

  Future<MissedModel> loadOrderData({String? orderId}) async {
    MissedModel _missedModel = MissedModel();

    DocumentSnapshot snapshot=await firestore
        .collection(MissedModel.REF)
        .doc(orderId)
        .get();

      _missedModel = MissedModel.fromSnapshoot(snapshot);

    return _missedModel;
  }

  Future<String> notifyCount({String? userId}) async {
    String _count = "";
    String date=await loadLastDate(userId: userId);

    if (int.tryParse(date)! > 0)
      try {
        await firestore
            .collection(NotifyModel.REF)
            .doc(userId)
            .collection(NotifyModel.SUB_COLLECTIN_REF)
            .where(NotifyModel.DATE_TIME, isGreaterThan: date)
            .get()
            .then((value) {
          _count = value.docs.length.toString();
        });
      } catch (ex) {}
    else if (int.tryParse(date) == 0) {
      try {
        await firestore
            .collection(NotifyModel.REF)
            .doc(userId)
            .collection(NotifyModel.SUB_COLLECTIN_REF)
            .get()
            .then((value) {
          _count = value.docs.length.toString();
        });
      } catch (ex) {}
    }
    return _count;
  }

  Future<String> loadLastDate({String? userId}) async {
    String _date = "";

    try {
      await firestore
          .collection(NotifyModel.REF)
          .doc(userId)
          .get()
          .then((value) async {
        _date = value.data() == null ? "0" : value.data()!["last_date"];
      });
    } catch (ex) {
      _date = "0";
    }
    return _date;
  }


  Future<void> updateLastDate({String? userId}) async {
    DocumentSnapshot documentSnapshot =
        await firestore.collection(NotifyModel.REF).doc(userId).get();
    if (documentSnapshot.data() == null) {
      await firestore
          .collection(NotifyModel.REF)
          .doc(userId)
          .set({"last_date": DateTime.now().millisecondsSinceEpoch.toString()});
    } else {
      await firestore.collection(NotifyModel.REF).doc(userId).update(
          {"last_date": DateTime.now().millisecondsSinceEpoch.toString()});
    }
  }
}
