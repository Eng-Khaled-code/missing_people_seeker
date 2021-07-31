import 'package:finalmps/PL/profile/top_container.dart';
import 'package:finalmps/PL/registration/google_phone_sign_up/google_sign_up.dart';
import 'package:finalmps/PL/registration/log_in.dart';
import 'package:finalmps/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:finalmps/PL/registration/register_with_email_or_phone/last_widget.dart';
import 'package:finalmps/services/storage_services.dart';
import 'package:finalmps/services/user_services.dart';
import 'dart:async';
import 'package:finalmps/PL/profile/profile_card_item.dart';
import 'package:image_picker/image_picker.dart';

enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }

class UserChange with ChangeNotifier {
  FirebaseAuth _firebaseAuth;

  UserServices _firestoreServices = UserServices();
  StorageServices _storageServices = StorageServices();

//re send message varables

  bool isLoading = false;
  bool isImageLoading = false;

  //status variables
  Status _status = Status.Uninitialized;

  Status get status => _status;

  //user model get and set
  UserModel _userInformation = UserModel.emptyConstractor();

  UserModel get userInformation => _userInformation;

  set setUserModel(UserModel value) {
    _userInformation = value;
  }

  final GoogleSignIn googleSignIn = GoogleSignIn();

//main constractor
  UserChange.initialize() : _firebaseAuth = FirebaseAuth.instance {
    _firebaseAuth.authStateChanges().listen(onStatusChange);
  }

  Future<void>? onStatusChange(User? user) async {
    if (user != null) {
      await updateConnectStatus(connected: "yes", userId: user.uid);
      //on sign in or up orany authentication operation happen the user information will be gotten
      await loadUserInformation(user.uid);

      _status = Status.Authenticated;
    } else {
      _status = Status.Unauthenticated;
    }
    notifyListeners();
  }

  Future<void> loadUserInformation(String userId) async {
    try {
      _userInformation = await _firestoreServices.loadUserInformation(userId);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<bool> updateUserName(
      {String? fName, String? lName, required String userId}) async {
    try {
      isLoading = true;
      notifyListeners();

      await _firestoreServices.updateToFirestore(
          collection: UserModel.USER_REF,
          docId: userId,
          data: {
            UserModel.F_NAME: fName,
            UserModel.L_NAME: lName
          }).then((value) async {
        await loadUserInformation(userId);
      });

      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      isLoading = false;
      CardItem.error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<void> updateConnectStatus(
      {String? connected, required String userId}) async {
    try {
      await _firestoreServices.updateToFirestore(
          collection: UserModel.USER_REF,
          docId: userId,
          data: {UserModel.CONNECTED: connected});

      notifyListeners();
    } catch (e) {
      CardItem.error = e.toString();
      notifyListeners();
    }
  }

  Future<bool> updatePhoneNumber(
      {String? phoneNumber, required String userId}) async {
    try {
      isLoading = true;
      notifyListeners();
      await _firestoreServices.updateToFirestore(
          collection: UserModel.USER_REF,
          docId: userId,
          data: {
            UserModel.PHONE_NUMBER: phoneNumber,
          }).then((value) async => await loadUserInformation(userId));

      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      isLoading = false;
      CardItem.error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateProfilePicture(
      {XFile? imageFile, required String userId}) async {
    try {
      isImageLoading = true;
      notifyListeners();
      await _storageServices
          .uploadingImageToStorage(
              docId: userId,
              collection: UserModel.USER_REF,
              image: imageFile,
              fieldName: UserModel.IMAGE_URL,
              storageDirectoryPath: UserModel.DIRECTORY,
              type: "update")
          .then((value) async {
        await loadUserInformation(userId);
      });

      isImageLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      isImageLoading = false;

      TopContainer.error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateSSN({String? SSN, required String userId}) async {
    try {
      isLoading = true;
      notifyListeners();

      await _firestoreServices.updateToFirestore(
          collection: UserModel.USER_REF,
          docId: userId,
          data: {
            UserModel.SSN: SSN,
          }).then((value) async => await loadUserInformation(userId));

      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      isLoading = false;
      CardItem.error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateGender({String? gender, required String userId}) async {
    try {
      isLoading = true;
      notifyListeners();

      await _firestoreServices.updateToFirestore(
          collection: UserModel.USER_REF,
          docId: userId,
          data: {
            UserModel.GENDER: gender,
          }).then((value) async => await loadUserInformation(userId));

      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      isLoading = false;
      CardItem.error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateAddress({String? address, required String userId}) async {
    try {
      isLoading = true;
      notifyListeners();

      await _firestoreServices.updateToFirestore(
          collection: UserModel.USER_REF,
          docId: userId,
          data: {
            UserModel.ADDRESS: address,
          }).then((value) async => await loadUserInformation(userId));

      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      isLoading = false;

      CardItem.error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateBirthdate(
      {String? birthdate, required String userId}) async {
    try {
      isLoading = true;
      notifyListeners();

      await _firestoreServices.updateToFirestore(
          collection: UserModel.USER_REF,
          docId: userId,
          data: {
            UserModel.BIRTH_DATE: birthdate,
          }).then((value) async => await loadUserInformation(userId));

      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      isLoading = false;
      CardItem.error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> googleSginUp(
      {String? gender,
      String? ssn,
      String? phone,
      String? address,
      String? birthDate}) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();

      final GoogleSignIn _googleSignIn = GoogleSignIn();

      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);

      await _firebaseAuth.signInWithCredential(credential).then((user) {
        String name = user.user!.displayName!.trim();
        String firstName = name.split(" ").first;
        String lastName = name.substring(firstName.length, name.length);

        Map<String, dynamic> data = {
          UserModel.ID: user.user!.uid,
          UserModel.F_NAME: firstName,
          UserModel.L_NAME: lastName,
          UserModel.GENDER: gender,
          UserModel.PHONE_NUMBER: phone,
          UserModel.BIRTH_DATE: birthDate,
          UserModel.ADDRESS: address,
          UserModel.SSN: ssn,
          UserModel.EMAIL: user.user!.email,
          UserModel.IMAGE_URL: user.user!.photoURL,
          UserModel.TYPE: "user",
        };

        isSignedUp(data: data);
      });

      _status = Status.Authenticated;
      notifyListeners();

      return true;
    } catch (e) {
      _status = Status.Unauthenticated;
      GoogleSignUpWidgets.error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> googleSginIn() async {
    try {
      _status = Status.Authenticating;
      notifyListeners();

      final GoogleSignIn _googleSignIn = GoogleSignIn();

      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);

      String userId = "";
      await _firebaseAuth.signInWithCredential(credential).then((user) {
        userId = user.user!.uid;
      });

      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(UserModel.USER_REF)
          .where(UserModel.ID, isEqualTo: userId)
          .get();
      final List<DocumentSnapshot> querySnapshotResultList = querySnapshot.docs;

      //saving data to firestore becase this user is new
      if (querySnapshotResultList.length == 0) {
        await googleSignIn.disconnect();

        _status = Status.Unauthenticated;
        notifyListeners();
        return false;
      } else {
        _status = Status.Authenticated;
        notifyListeners();

        return true;
      }
    } catch (e) {
      _status = Status.Unauthenticated;
      GoogleSignUpWidgets.error = e.toString();
      notifyListeners();
      return false;
    }
  }

  isSignedUp({required Map<String, dynamic> data}) async {
    //if the user already signed up
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(UserModel.USER_REF)
        .where(UserModel.ID, isEqualTo: data[UserModel.ID])
        .get();
    final List<DocumentSnapshot> querySnapshotResultList = querySnapshot.docs;

    print(querySnapshotResultList.length.toString() + "jhjhjhjh");
    //saving data to firestore becase this user is new
    if (querySnapshotResultList.length == 0)
      await _firestoreServices.addToFirestore(
          collection: UserModel.USER_REF,
          docId: data[UserModel.ID],
          data: data);
  }

  // sign in with email and password
  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    try {
      _status = Status.Authenticating;

      LogIn.logInErrorMessage = "";
      notifyListeners();
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(UserModel.USER_REF)
          .where(UserModel.EMAIL, isEqualTo: email)
          .where(UserModel.TYPE, isEqualTo: "user")
          .get();
      final List<DocumentSnapshot> querySnapshotResultList = querySnapshot.docs;

      //saving data to firestore becase this user is new
      if (querySnapshotResultList.length != 0) {
        await _firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password);

        _status = Status.Authenticated;
        print("3 " + _status.toString());

        notifyListeners();
        return true;
      } else {
        _status = Status.Unauthenticated;
        print("4 " + _status.toString());

        LogIn.logInErrorMessage = "هذا الإيميل غير موجود";

        notifyListeners();
        return false;
      }
    } catch (ex) {
      _status = Status.Unauthenticated;
      print("5 " + _status.toString());

      LogIn.logInErrorMessage = ex.toString();
      notifyListeners();
      return false;
    }
  }

//completed
  Future<bool> signUpWithEmail(
      {XFile? profileImage,
      String? firstName,
      String? lastName,
      String? gender,
      String? SSN,
      String? phoneNumber,
      String? address,
      String? birthDate,
      String? email,
      String? password}) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();

      await _firebaseAuth
          .createUserWithEmailAndPassword(email: email!, password: password!)
          .then((user) async {
        Map<String, dynamic> values = {
          UserModel.ID: user.user!.uid,
          UserModel.F_NAME: firstName,
          UserModel.L_NAME: lastName,
          UserModel.GENDER: gender,
          UserModel.PHONE_NUMBER: phoneNumber,
          UserModel.BIRTH_DATE: birthDate,
          UserModel.ADDRESS: address,
          UserModel.SSN: SSN,
          UserModel.EMAIL: email,
          UserModel.TYPE: "user",
        };

        await _firestoreServices
            .addToFirestore(
                collection: UserModel.USER_REF,
                docId: values[UserModel.ID],
                data: values)
            .then((value) async {
          if (profileImage != null) {
            await _storageServices
                .uploadingImageToStorage(
                    image: profileImage,
                    docId: user.user!.uid,
                    type: "add",
                    collection: UserModel.USER_REF,
                    storageDirectoryPath: UserModel.DIRECTORY,
                    fieldName: UserModel.IMAGE_URL)
                .then((value) async {
              await loadUserInformation(user.user!.uid);
            });
          }
        });
      });

      _status = Status.Authenticated;
      return true;
    } catch (e) {
      _status = Status.Unauthenticated;
      LastWidgetState.error = e.toString();
      notifyListeners();
      return false;
    }
  }

//sign out for all
  Future<bool> signOut() async {
    try {
      _status = Status.Authenticating;
      notifyListeners();

      _firebaseAuth.signOut();
      await updateConnectStatus(connected: "no", userId: userInformation.id);

      //this try and catch because i might loged in by another method than google
      try {
        await googleSignIn.disconnect();
        await googleSignIn.signOut();
      } catch (ex) {}

      _status = Status.Unauthenticated;
      notifyListeners();
      return true;
    } catch (ex) {
      _status = Status.Authenticated;
      notifyListeners();

      return false;
    }
  }

  navigateToHome() {
    _status = Status.Authenticated;
    notifyListeners();
  }
}
