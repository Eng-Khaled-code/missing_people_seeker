import 'package:cloud_firestore/cloud_firestore.dart';

class FoundModel {
  static const ID = "found_id";
  static const NAME = "name";
  static const GENDER = "gender";
  static const AGE = "age";
  static const IMAGE_URL_1 = "image_url_1";
  static const PLACE = "place";
  static const MAIN_USER_ID = "main_user_id";
  static const SECOND_USER_ID = "second_user_id";
  static const IMAGE_URL_2 = "image_url_2";

  String id = "";
  String name = "";
  String gender = "";
  String imageUrl1 = " ";
  String imageUrl2 = " ";
  String place = "";
  String mainUserId = "";
  String secondUserId = "";
  String age = "";
  FoundModel();

  FoundModel.fromSnapshoot(DocumentSnapshot snapshot) {
    Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;

    id = userData[ID];
    secondUserId = userData[SECOND_USER_ID];
    mainUserId = userData[MAIN_USER_ID];
    place = userData[PLACE];
    imageUrl2 = snapshot.get(IMAGE_URL_2) ?? "";
    imageUrl1 = snapshot.get(IMAGE_URL_1) ?? "";
    gender = userData[GENDER];
    age = userData[AGE];
    name = userData[NAME];
  }

}
