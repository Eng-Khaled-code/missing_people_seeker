import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalmps/models/notify_model.dart';
import 'package:finalmps/models/missed_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotifyServices {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late SharedPreferences prefs;

  List<NotifyModel> loadNotificationsList(String? userId) {
    List<NotifyModel> _notifyList = [];
    try {
      _firestore
          .collection(NotifyModel.REF)
          .doc(userId)
          .collection(NotifyModel.SUB_COLLECTIN_REF)
          .where(NotifyModel.USER_ID, isEqualTo: userId)
          .get()
          .then((snapshot) {
        snapshot.docs.forEach((element) async {
          NotifyModel _notifyModel = NotifyModel.fromSnapshoot(element);
          _notifyList.add(_notifyModel);
        });
      });
      return _notifyList;
    } catch (ex) {
      return [];
    }
  }

  Future<void> updateSeen({String? userId, String? notifyId}) async {
    await _firestore
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

    await _firestore
        .collection(NotifyModel.REF)
        .doc(userId)
        .collection(NotifyModel.SUB_COLLECTIN_REF)
        .doc(docId)
        .set(values);
  }

  Future<void> deleteNotifys({String? userId, String? orderId}) async {
    await _firestore
        .collection(NotifyModel.REF)
        .doc(userId)
        .collection(NotifyModel.SUB_COLLECTIN_REF)
        .where("order_id", isEqualTo: orderId)
        .get()
        .then((value) async {
      value.docs.forEach((element) async {
        await _firestore
            .collection(NotifyModel.REF)
            .doc(userId)
            .collection(NotifyModel.SUB_COLLECTIN_REF)
            .doc(element.get("notify_id"))
            .delete();
      });
    });
  }

  Future<void> deleteNotifyById({String? userId, String? notifyId}) async {
    await _firestore
        .collection(NotifyModel.REF)
        .doc(userId)
        .collection(NotifyModel.SUB_COLLECTIN_REF)
        .doc(notifyId)
        .delete();
  }

  Future<MissedModel> loadOrderData({String? orderId}) async {
    MissedModel _missedModel = MissedModel();
    await _firestore
        .collection(MissedModel.REF)
        .doc(orderId)
        .get()
        .then((value) {
      _missedModel = MissedModel.fromSnapshoot(value);
    });

    return _missedModel;
  }

  Future<String> notifyCount({String? userId, String? date}) async {
    String _count = "";
    if (int.tryParse(date!)! > 0)
      try {
        await _firestore
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
        await _firestore
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
      await _firestore
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
        await _firestore.collection(NotifyModel.REF).doc(userId).get();
    if (documentSnapshot.data() == null) {
      await _firestore
          .collection(NotifyModel.REF)
          .doc(userId)
          .set({"last_date": DateTime.now().millisecondsSinceEpoch.toString()});
    } else {
      await _firestore.collection(NotifyModel.REF).doc(userId).update(
          {"last_date": DateTime.now().millisecondsSinceEpoch.toString()});
    }
  }
}
