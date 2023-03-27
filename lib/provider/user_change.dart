import 'dart:io';
import 'package:finalmps/models/user_model.dart';
import 'package:finalmps/services/storage_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:finalmps/services/user_services/user_services.dart';
import 'dart:async';

enum AuthPage { SIGN_IN, GOOGLE_SIGN_UP, EMAIL_SIGN_UP ,FORGET_PASSWORD,LOADING,HOME,SPLASH}

class UserChange with ChangeNotifier {

  GoogleSignInAccount? googleSignInAccount;
  UserServices userServices = UserServices();
  StorageServices storageServices=StorageServices();
  AuthPage authPage=AuthPage.SPLASH;

  bool isLoading = false;
  bool isImageLoading = false;

  UserModel? userData;
  File? profileImage;


//main constractor
  UserChange.initialize(){
    FirebaseAuth.instance.authStateChanges().listen(onStatusChange);
  }

  Future<void>? onStatusChange(User? user) async {
    if (user != null) {
      await updateConnectStatus(connected: "yes", userId: user.uid);
      //on sign in or up or any authentication operation happen the user information will be gotten
      userData=await userServices.loadUserInformation(user.uid);

      authPage = AuthPage.HOME;
      Fluttertoast.showToast(msg:"sign in successfully");

    } else {
      authPage = AuthPage.SIGN_IN;
    }

    notifyListeners();
  }

  setAuthPage(AuthPage page){
    authPage=page;
    notifyListeners();
  }

  setProfileImage(File image) {
    profileImage=image;
    notifyListeners();
  }

  Future<void> updateUserName(
      {String? fName, String? lName}) async {
    try {
      isLoading = true;
      notifyListeners();

      await userServices.updateToFirestore(
          collection: UserModel.USER_REF,
          docId: userData!.id,
          data: {
            UserModel.F_NAME: fName,
            UserModel.L_NAME: lName
          });

      userData=await userServices.loadUserInformation(userData!.id);
      isLoading = false;
      notifyListeners();
      Fluttertoast.showToast(msg:"تم تعديل الاسم بنجاح");
    }on FirebaseException catch (e) {
      isLoading = false;
      notifyListeners();
      Fluttertoast.showToast(msg:e.message!);
    }
  }

  Future<void> updateConnectStatus(
      {String? connected,String? userId}) async {
    try {

      await userServices.updateToFirestore(
          collection: UserModel.USER_REF,
          docId:userId??userData!.id,
          data: {UserModel.CONNECTED: connected});

    }on FirebaseException catch (e) {
      Fluttertoast.showToast(msg:e.message!);
    }
  }

  Future<void> updateUserField(
      {String? field,String? value}) async {
    try {
      isLoading = true;
      notifyListeners();
      await userServices.updateToFirestore(
          collection: UserModel.USER_REF,
          docId: userData!.id,
          data: {field!: value}
      );

      userData=await userServices.loadUserInformation(userData!.id);
      isLoading = false;
      notifyListeners();
      Fluttertoast.showToast(msg:"تم التعديل بنجاح");
    }on FirebaseException catch (e) {
      isLoading = false;
      notifyListeners();
      Fluttertoast.showToast(msg:e.message!);
    }
  }

  Future<void> updateProfilePicture(
      {File? imageFile}) async {
    try {
      isImageLoading = true;
      notifyListeners();

      await storageServices
          .uploadingImageToStorage(
              docId: userData!.id,
              collection: UserModel.USER_REF,
              image: imageFile,
              fieldName: UserModel.IMAGE_URL,
              storageDirectoryPath: UserModel.DIRECTORY,
              type: "update");

      userData=await userServices.loadUserInformation(userData!.id);
      isImageLoading = false;
      notifyListeners();
      Fluttertoast.showToast(msg:"تم تعديل رقم الصورة بنجاح");
    }on FirebaseException catch (e) {
      isImageLoading = false;
      notifyListeners();
      Fluttertoast.showToast(msg:e.message!);
    }
  }


  Future<void> googleSignIn() async {
    try {

      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleSignInAccount1 = await googleSignIn.signIn();

      if(await userServices.isSignedInBefore(userId:googleSignInAccount1!.id))
      {

        await userServices.googleSigningIn(googleSignInAccount: googleSignInAccount1);
      }
      else
      {
        googleSignInAccount=googleSignInAccount1;
        authPage = AuthPage.GOOGLE_SIGN_UP;
      }

      notifyListeners();

    }on FirebaseException catch (e) {
      Fluttertoast.showToast(msg:"sign in With Google Failed, "  + e.message.toString(),toastLength: Toast.LENGTH_LONG);
      authPage = AuthPage.SIGN_IN;
      notifyListeners();
    }
  }


  Future<void> googleSignUp({String? birthdate,String? address,String? gender,String? ssn,String? phone}) async{
    try{

      authPage = AuthPage.LOADING;
      notifyListeners();
      await userServices.googleSigningIn(googleSignInAccount: googleSignInAccount,type: "sign up",gender: gender,ssn: ssn,phone: phone,birthdate:birthdate,address: address );

    }on FirebaseException catch (e) {
      Fluttertoast.showToast(msg:"sign up With Google Failed, "  + e.message.toString(),toastLength: Toast.LENGTH_LONG);
      authPage = AuthPage.GOOGLE_SIGN_UP;
      notifyListeners();
      }
  }

  Future<void> signInAndUpWithEmail(
      {
      String? type="sign in",
      String? firstName,
      String? lastName,
      String? gender,
      String? ssn,
      String? phoneNumber,
      String? address,
      String? birthDate,
      String? email,
      String? password}) async {
    try {
      authPage=AuthPage.LOADING;
      notifyListeners();
      if(type=="sign in")
        await userServices.signInWithEmailAndPassword(email!, password!);
      else
      await userServices.signUpWithEmailAndPassword(
          email: email,
          password: password,
          fName: firstName,
          lName: lastName,
          gender:gender,
          ssn: ssn,
          phone: phoneNumber,
          birthDate: birthDate,
          address: address,
          profilePicture: profileImage!
      );


    }on FirebaseException catch (e) {

      authPage = AuthPage.EMAIL_SIGN_UP;
      Fluttertoast.showToast(msg:"Sign up Failed, "  + e.message.toString(),toastLength: Toast.LENGTH_LONG);
      notifyListeners();
    }
  }

//sign out for all
    Future signOut() async {
      FirebaseAuth.instance.signOut();
      try{
        final GoogleSignIn _googleSignIn = GoogleSignIn();
        await _googleSignIn.disconnect();
        await _googleSignIn.signOut();
      }catch(e){}

    }

  navigateToHome() {
    authPage = AuthPage.HOME;
    notifyListeners();
  }
}
