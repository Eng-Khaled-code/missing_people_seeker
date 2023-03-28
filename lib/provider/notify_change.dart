import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalmps/models/missed_model.dart';
import 'package:finalmps/models/notify_model.dart';
import 'package:finalmps/services/notify_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';

class NotifyChange with ChangeNotifier {
  bool isLoading = false;

  NotifyChange.initialize();

  NotifyServices _notifyServices = NotifyServices();

  MissedModel orderData = MissedModel();
  String notifyCount = "";
  String lastDate = "";
  List<NotifyModel>? notificationsList;

  Future<void> loadNotifications({String? userId}) async {
    try {
      notificationsList = await _notifyServices.loadNotificationsList(userId);
      notifyListeners();
    } on FirebaseException catch (e) {
      Fluttertoast.showToast(msg: e.message!, toastLength: Toast.LENGTH_LONG);
    }
  }

  Future<void> updateSeen({String? userId, String? notifyId}) async {
    try {
      // refuse order value 2
      await _notifyServices.updateSeen(userId: userId, notifyId: notifyId);
      notifyListeners();
    } on FirebaseException catch (e) {
      Fluttertoast.showToast(msg: e.message!, toastLength: Toast.LENGTH_LONG);
    }
  }

  Future updateLastDate({String? userId}) async {
    try {
      // refuse order value 2
      await _notifyServices.updateLastDate(userId: userId).then((value) {
        notifyListeners();
      });
    } catch (ex) {
      notifyListeners();
    }
  }

  Future<void> loadNotifyCount({String? userId}) async {
    notifyCount = await _notifyServices.notifyCount(userId: userId);
    notifyListeners();
  }

  Future<void> loadLastDate({String? userId}) async {
    lastDate = await _notifyServices.loadLastDate(userId: userId);
    notifyListeners();
  }

  Future<void> loadOrderData({String? orderId}) async {
    try {
      isLoading = true;
      notifyListeners();

      orderData = await _notifyServices.loadOrderData(orderId: orderId);
      isLoading = false;

      notifyListeners();
    } catch (ex) {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteNotifyByOrder({String? userId, String? orderId}) async {
    try {
      await _notifyServices.deleteNotifys(userId: userId, orderId: orderId);

      Fluttertoast.showToast(
          msg: "تم حذف الاشعار بالفعل", toastLength: Toast.LENGTH_LONG);
      return true;
    } on FirebaseException catch (e) {
      Fluttertoast.showToast(msg: e.message!, toastLength: Toast.LENGTH_LONG);
      return false;
    }
  }

  Future<void> deleteNotifyByNotifyId(
      {String? userId, String? notifyId}) async {
    try {
      await _notifyServices.deleteNotifyById(
          userId: userId, notifyId: notifyId);

      Fluttertoast.showToast(
          msg: "تم حذف الاشعار بالفعل", toastLength: Toast.LENGTH_LONG);
    } on FirebaseException catch (e) {
      Fluttertoast.showToast(msg: e.message!, toastLength: Toast.LENGTH_LONG);
    }
  }
}
