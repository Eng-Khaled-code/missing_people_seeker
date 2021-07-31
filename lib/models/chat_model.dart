import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  static const ID = "message_id";
  static const CONTENT = "content";
  static const ID_FROM = "idFrom";
  static const TIMESTANP = "timestanp";
  static const SEEN = "seen";

  String _id = "";
  String _content = "";
  String _idFrom = "";
  String _timestanp = "";
  String _seen = " ";
  ChatModel();
  ChatModel.fromSnapshoot(DocumentSnapshot snapshot) {
    Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;

    _id = userData[ID];
    _content = userData[CONTENT];
    _idFrom = userData[ID_FROM];
    _timestanp = userData[TIMESTANP];
    _seen = userData[SEEN];
  }

  String get id => _id;

  String get content => _content;

  String get idFrom => _idFrom;

  String get timestanp => _timestanp;

  String get seen => _seen;
}
