import 'package:finalmps/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserServices {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addToFirestore(
      {String? collection, String? docId, Map<String, dynamic>? data}) async {
    await _firestore.collection(collection!).doc(docId).set(data!);
  }

  Future<void> updateToFirestore(
      {String? collection, String? docId, Map<String, dynamic>? data}) async {
    await _firestore.collection(collection!).doc(docId).update(data!);
  }

  Future<void> deleteFromFirestore({String? collection, String? docId}) async {
    await _firestore.collection(collection!).doc(docId).delete();
  }

  Future<UserModel> loadUserInformation(String userID) async {
    UserModel _user = UserModel.emptyConstractor();

    DocumentSnapshot<Map<String, dynamic>>? snapshot =
        await _firestore.collection(UserModel.USER_REF).doc(userID).get();
    _user = UserModel.fromSnapshoot(snapshot);
    return _user;
  }
}
