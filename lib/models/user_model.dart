import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  static const USER_REF = "users";
  static const DIRECTORY = "profile images";
  static const ID = "user_id";
  static const F_NAME = "f_name";
  static const L_NAME = "l_name";
  static const GENDER = "gender";
  static const IMAGE_URL = "image_url";
  static const ADDRESS = "address";
  static const SSN = "ssn";
  static const BIRTH_DATE = "birth_date";
  static const EMAIL = "email";
  static const PHONE_NUMBER = "phone_number";
  static const TYPE = "type";
  static const CONNECTED = "connected";

  String _id = "";
  String _fName = "";
  String _lName = "";
  String _gender = "";
  String _imageUrl = " ";
  String _address = "";
  String _ssn = "";
  String _birthDate = "";
  String _phoneNumber = "";
  String _email = "";
  String _type = "";
  String _connected = "";

  UserModel.emptyConstractor();

  UserModel(
      this._id,
      this._fName,
      this._lName,
      this._gender,
      this._imageUrl,
      this._address,
      this._ssn,
      this._birthDate,
      this._phoneNumber,
      this._email,
      this._type,
      this._connected);

  factory UserModel.fromSnapshoot(
      DocumentSnapshot<Map<String, dynamic>>? snapshot) {
    return UserModel(
        snapshot!.get(ID),
        snapshot.get(F_NAME),
        snapshot.get(L_NAME),
        snapshot.get(GENDER),
        snapshot.get(IMAGE_URL) ?? "",
        snapshot.get(ADDRESS),
        snapshot.get(SSN),
        snapshot.get(BIRTH_DATE),
        snapshot.get(PHONE_NUMBER),
        snapshot.get(EMAIL),
        snapshot.get(TYPE),
        snapshot.get(CONNECTED));
  }

  String get id => _id;

  String get fName => _fName;

  String get lName => _lName;

  String get gender => _gender;

  String get imageUrl => _imageUrl;

  String get address => _address;

  String get ssn => _ssn;

  String get birthDate => _birthDate;

  String get phoneNumber => _phoneNumber;

  String get email => _email;

  String get type => _type;

  String get connected => _connected;
}
