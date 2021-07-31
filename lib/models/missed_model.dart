import 'package:cloud_firestore/cloud_firestore.dart';

class MissedModel {
  static const REF = "missed";
  static const MISSED_DIRECTORY = "missed images";
  static const MAY_MISSED_DIRECTORY = "may missed images";

  static const ID = "id";
  static const NAME = "name";
  static const GENDER = "gender";
  static const IMAGE_URL = "image_url";
  static const LAST_PLACE = "last_place";
  static const HELTHY_STATUS = "helthy_status";
  static const AGE = "age";
  static const FACE_COLOR = "face_color";
  static const HAIR_COLOR = "hair_color";
  static const EYE_COLOR = "eye_color";
  static const PUBLISH_DATE = "pub_date";
  static const STATUS = "status";
  static const TYPE = "type";

  static const USER_ID = "user_id";
  static const ADMIN_ID = "admin_id";

  String _id = "";
  String _name = "";
  String _helthyStatus = "";
  String _gender = "";
  String _imageUrl = " ";
  String _lastPlace = "";
  String _age = "";
  String _publishDate = "";
  String _faceColor = "";
  String _hairColor = "";
  String _eyeColor = "";
  String _status = "";
  String _type = "";
  String _userId = "";
  String _adminId = "";

  MissedModel();

  MissedModel.fromSnapshoot(DocumentSnapshot snapshot) {
    Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;

    _id = userData[ID];
    _name = userData[NAME];
    _helthyStatus = userData[HELTHY_STATUS];
    _imageUrl = snapshot.get(IMAGE_URL) ?? "";
    _gender = userData[GENDER];
    _lastPlace = userData[LAST_PLACE];
    _age = userData[AGE];
    _publishDate = userData[PUBLISH_DATE];
    _faceColor = userData[FACE_COLOR];
    _eyeColor = userData[EYE_COLOR];
    _hairColor = userData[HAIR_COLOR];
    _status = userData[STATUS];
    _type = userData[TYPE];
    _userId = userData[USER_ID];
    _adminId = userData[ADMIN_ID];
  }

  String get type => _type;

  String get status => _status;

  String get eyeColor => _eyeColor;

  String get hairColor => _hairColor;

  String get faceColor => _faceColor;

  String get publishDate => _publishDate;

  String get age => _age;

  String get lastPlace => _lastPlace;

  String get imageUrl => _imageUrl;

  String get gender => _gender;

  String get helthyStatus => _helthyStatus;

  String get name => _name;

  String get id => _id;

  String get adminId => _adminId;

  String get userId => _userId;
}
