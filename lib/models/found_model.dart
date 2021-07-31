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

  String _id = "";
  String _name = "";
  String _gender = "";
  String _imageUrl1 = " ";
  String _imageUrl2 = " ";
  String _place = "";
  String _mainUserId = "";
  String _secondUserId = "";
  String _age = "";

  FoundModel();

  FoundModel.fromSnapshoot(DocumentSnapshot snapshot) {
    Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;

    _id = userData[ID];
    _secondUserId = userData[SECOND_USER_ID];
    _mainUserId = userData[MAIN_USER_ID];
    _place = userData[PLACE];
    _imageUrl2 = snapshot.get(IMAGE_URL_2) ?? "";
    _imageUrl1 = snapshot.get(IMAGE_URL_1) ?? "";
    _gender = userData[GENDER];
    _age = userData[AGE];
    _name = userData[NAME];
  }

  String get id => _id;

  String get name => _name;

  String get age => _age;

  String get gender => _gender;

  String get place => _place;

  String get imageURL1 => _imageUrl1;

  String get imageUrl2 => _imageUrl2;

  String get mainUserId => _mainUserId;

  String get secondUserId => _secondUserId;
}
