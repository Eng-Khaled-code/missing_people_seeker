import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalmps/models/missed_model.dart';

class NotifyModel {
  static const REF = "notify";
  static const SUB_COLLECTIN_REF = "notifications";

  static const ID = "notify_id";
  static const USER_ID = "user_id";
  static const ORDER_ID = "order_id";
  static const IMAGE_URL = "image_url";
  static const ORDER_NAME = "order_name";
  static const OPENED = "opened";
  static const TYPE = "type";
  static const REASON = "reason";
  static const DATE_TIME = "datetime";

  String _id = "";
  String _orderId = "";
  String _imageUrl = " ";
  String _orderName = "";
  String _opened = "";
  String _reason = "";
  String _type = "";
  String _date = "";

  NotifyModel.fromSnapshoot(DocumentSnapshot snapshot) {
    Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;

    _id = userData[ID];
    _orderId = userData[ORDER_ID];
    _orderName = userData[ORDER_NAME];
    _imageUrl = snapshot.get("image_url") ?? "";
    _opened = userData[OPENED];
    _reason = userData[REASON];
    _type = userData[TYPE];
    _date = userData[DATE_TIME];
  }

  String get type => _type;

  String get reason => _reason;

  String get opened => _opened;

  String get orderName => _orderName;

  String get imageUrl => _imageUrl;

  String get orderId => _orderId;

  String get id => _id;

  String get date => _date;
}
