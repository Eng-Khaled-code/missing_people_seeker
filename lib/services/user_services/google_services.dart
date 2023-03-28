
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalmps/models/user_model.dart';
import 'package:finalmps/services/user_services/user_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleServices
{

  FirebaseAuth firebaseAuth=FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore=FirebaseFirestore.instance;


  Future<void> googleSigningIn({GoogleSignInAccount? googleSignInAccount,
    String? type="sign in",String? birthdate,String? address,String? gender,String? ssn,String? phone}) async {



    final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount!.authentication;

    final AuthCredential credential =
    GoogleAuthProvider
        .credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);

  UserCredential userCredential=  await firebaseAuth.signInWithCredential(credential);

  if(type=="sign up"){
  await addUser(userCredential:userCredential,gender: gender,ssn: ssn,phone: phone,birthdate:birthdate,address: address );
  }

  }

  Future<void> addUser({UserCredential? userCredential,String? gender,String? ssn,String? phone,String? birthdate,String? address})async{
  String name = userCredential!.user!.displayName!.trim();
  String firstName = name.split(" ").first;
  String lastName = name.substring(firstName.length, name.length);

  Map<String, dynamic> data = {
    UserModel.ID: userCredential.user!.uid,
    UserModel.F_NAME: firstName,
    UserModel.L_NAME: lastName,
    UserModel.GENDER: gender,
    UserModel.PHONE_NUMBER: phone,
    UserModel.BIRTH_DATE: birthdate,
    UserModel.ADDRESS: address,
    UserModel.SSN: ssn,
    UserModel.EMAIL: userCredential.user!.email,
    UserModel.IMAGE_URL: userCredential.user!.photoURL,
    UserModel.TYPE: "user",
    UserModel.CONNECTED:"yes"

  };
  await UserServices().addToFirestore(
      collection: UserModel.USER_REF,
      docId: data[UserModel.ID],
      data: data);
}

  Future<bool> isSignedInBefore({String? userId})async {

    final QuerySnapshot querySnapshot = await firebaseFirestore
        .collection(UserModel.DIRECTORY)
        .where(UserModel.ID, isEqualTo:userId)
        .get();

    if(querySnapshot.docs.length==0){
      return false;
    }
     return true;

  }









}