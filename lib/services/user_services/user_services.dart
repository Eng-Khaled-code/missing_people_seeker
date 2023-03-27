import 'package:finalmps/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'email_and_password_services.dart';
import 'google_services.dart';
class UserServices extends GoogleServices with EmailAndPasswordServices{
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
    UserModel? user ;

    DocumentSnapshot<Map<String, dynamic>>? snapshot =
        await _firestore.collection(UserModel.USER_REF).doc(userID).get();
    user = UserModel.fromSnapshoot(snapshot);
    return user;
  }

}
