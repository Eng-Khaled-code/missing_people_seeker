import 'package:finalmps/services/notify_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalmps/models/found_model.dart';
import 'package:finalmps/models/missed_model.dart';

class MissedSrvices {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String collectionId = "missed";
  NotifyServices _notifyServices = NotifyServices();

  Future<void> addMissedOrder(
      {String? docId, Map<String, dynamic>? data}) async {
    await _firestore.collection(collectionId).doc(docId).set(data!);
  }

  Future<void> updateMissedOrder(
      {String? docId, Map<String, dynamic>? data}) async {
    await _firestore.collection(collectionId).doc(docId).update(data!);
  }

  Future<void> deleteMissedOrder({String? docId}) async {
    await _firestore.collection(collectionId).doc(docId).delete();
  }

  Future<FoundModel> loadFoundedOrders({String? foundedOrderId}) async {
    FoundModel _foundModel = FoundModel();
    await _firestore
        .collection("founds")
        .doc(foundedOrderId)
        .get()
        .then((snapshot) {
      _foundModel = FoundModel.fromSnapshoot(snapshot);
    });

    return _foundModel;
  }

  Future<void> addFoundOrder(
      {String? missedOrderId,
      String? mayBeMissedOrderId,
      String? foundOrderId}) async {
    MissedModel _missedOrder = MissedModel();
    MissedModel _mayBeMissedOrder = MissedModel();

//getting data of missed order
    await _firestore
        .collection(collectionId)
        .doc(missedOrderId)
        .get()
        .then((value) {
      _missedOrder = MissedModel.fromSnapshoot(value);
    });

    //getting data of may be missed order

    await _firestore
        .collection(collectionId)
        .doc(mayBeMissedOrderId)
        .get()
        .then((value) {
      _mayBeMissedOrder = MissedModel.fromSnapshoot(value);
    });

    //Uploading data to firestore to collection founds

    if (_missedOrder != null && _mayBeMissedOrder != null) {
//age and gender for our system analysis

      Map<String, dynamic> values = {
        "found_id": foundOrderId,
        "name": _missedOrder.name,
        "age": _missedOrder.age,
        "gender": _missedOrder.gender,
        "main_user_id": _missedOrder.userId,
        "image_url_1": _missedOrder.imageUrl,
        "second_user_id": _mayBeMissedOrder.userId,
        "image_url_2": _mayBeMissedOrder.imageUrl,
        "place": _mayBeMissedOrder.lastPlace,
      };

      await _firestore
          .collection("founds")
          .doc(foundOrderId)
          .set(values)
          .then((value) async {
        //deletting the two orders
        await deleteMissedOrder(docId: _missedOrder.id);
        await deleteMissedOrder(docId: _mayBeMissedOrder.id);

        //deletting thire notifications
        await _notifyServices.deleteNotifys(
            orderId: _missedOrder.id, userId: _missedOrder.userId);
        await _notifyServices.deleteNotifys(
            orderId: _mayBeMissedOrder.id, userId: _mayBeMissedOrder.userId);

        //add notification to the user who helps to find the person that his order has added to founds
        await _notifyServices.addFoundNotifys(
            userId: _mayBeMissedOrder.userId,
            foundName: _missedOrder.name,
            foundOrderId: foundOrderId,
            secondUserImageUrl: _missedOrder.imageUrl);
      });
    }
  }
}
