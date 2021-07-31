import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalmps/models/missed_model.dart';

class SearchServices {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> updateSuggestionsToNo(
      {String? collection, String? orderId, List<String>? ordersIds}) async {
    ordersIds!.forEach((element) async {
      if (element != "no orders")
        await _firestore
            .collection(collection!)
            .doc(orderId)
            .collection("suggest")
            .doc(element)
            .update({"suggest_true": "no"});
    });
  }

  Future<List<String>> loadSuggestedOrdersId({String? orderId}) async {
    List<String> _repetedOrdersIds = ["no orders"];
    await _firestore
        .collection(MissedModel.REF)
        .doc(orderId)
        .collection("suggest")
        .where("suggest_true", isEqualTo: "yes")
        .get()
        .then((snapshot) {
      snapshot.docs.forEach((element) async {
        //getting admins id that they responsible for my orders
        _repetedOrdersIds.add(element.get("its_order_id"));
      });
    });

    return _repetedOrdersIds;
  }
}
