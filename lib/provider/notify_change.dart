import 'package:finalmps/models/missed_model.dart';
import 'package:finalmps/models/notify_model.dart';
import 'package:finalmps/services/notify_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:finalmps/PL/home/orders/order_suggestions.dart';

class NotifyChange with ChangeNotifier {
  bool isLoading = false;

  NotifyChange.initialize();

  NotifyServices _notifyServices = NotifyServices();

  MissedModel _orderData = MissedModel();
  String _notifyCount = "";
  String _lastDate = "";
  List<NotifyModel> _notificationsList = [];

  Future<void> loadNotifications({String? userId}) async {
    _notificationsList = await _notifyServices.loadNotificationsList(userId);
    notifyListeners();
  }

  Future<bool> updateSeen({String? userId, String? notifyId}) async {
    try {
      isLoading = true;
      notifyListeners();

      // refuse order value 2
      await _notifyServices
          .updateSeen(userId: userId, notifyId: notifyId)
          .then((value) {
        isLoading = false;
        notifyListeners();
      });

      return true;
    } catch (ex) {
      isLoading = false;
      notifyListeners();
      return false;
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

  Future<void> loadNotifyCount({String? userId, String? date}) async {
    _notifyCount =
        await _notifyServices.notifyCount(userId: userId, date: date);
    notifyListeners();
  }

  Future<void> loadLastDate({String? userId}) async {
    _lastDate = await _notifyServices.loadLastDate(userId: userId);
    notifyListeners();
  }

  Future<void> loadOrderData({String? orderId}) async {
    try {
      isLoading = true;
      notifyListeners();

      _orderData = await _notifyServices.loadOrderData(orderId: orderId);
      isLoading = false;

      notifyListeners();
    } catch (ex) {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteNotifyByOrder({String? userId, String? orderId}) async {
    try {
      isLoading = true;
      notifyListeners();

      await _notifyServices
          .deleteNotifys(userId: userId, orderId: orderId)
          .then((value) {
        isLoading = false;
        notifyListeners();
      });

      return true;
    } catch (ex) {
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteNotifyByNotifyId(
      {String? userId, String? notifyId}) async {
    try {
      isLoading = true;
      notifyListeners();

      await _notifyServices
          .deleteNotifyById(userId: userId, notifyId: notifyId)
          .then((value) {
        isLoading = false;
        notifyListeners();
      });

      return true;
    } catch (ex) {
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  MissedModel get getOrderData => _orderData;

  String get getNotificationsCount => _notifyCount;

  String get getLastDate => _lastDate;

  List<NotifyModel> get getNotificationsList => _notificationsList;
}
