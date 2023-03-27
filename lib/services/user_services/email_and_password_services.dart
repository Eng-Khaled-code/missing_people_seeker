import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalmps/services/user_services/user_services.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../models/user_model.dart';
import '../storage_services.dart';

class EmailAndPasswordServices
{

   FirebaseAuth firebaseAuth=FirebaseAuth.instance;
   FirebaseFirestore firebaseFirestore=FirebaseFirestore.instance;

   Future<void> signInWithEmailAndPassword(String email, String password)async
   {

     await firebaseAuth
             .signInWithEmailAndPassword(email: email, password: password);

   }

   Future<void> signUpWithEmailAndPassword(
       {String? fName, String? email, String? password,
     String? lName, String? address, String? gender,String? ssn, String? phone, String? birthDate,
     File? profilePicture}) async
   {

     UserCredential user= await firebaseAuth
       .createUserWithEmailAndPassword(email: email!, password: password!);

     Map<String, dynamic> values = {
       UserModel.ID: user.user!.uid,
       UserModel.F_NAME: fName,
       UserModel.L_NAME: lName,
       UserModel.GENDER: gender,
       UserModel.PHONE_NUMBER: phone,
       UserModel.BIRTH_DATE: birthDate,
       UserModel.ADDRESS: address,
       UserModel.SSN: ssn,
       UserModel.EMAIL: email,
       UserModel.TYPE: "user",
     };

     await UserServices()
         .addToFirestore(
         collection: UserModel.USER_REF,
         docId: values[UserModel.ID],
         data: values)
         .then((value) async {
         await StorageServices()
             .uploadingImageToStorage(
             image: profilePicture,
             docId: user.user!.uid,
             type: "add",
             collection: UserModel.USER_REF,
             storageDirectoryPath: UserModel.DIRECTORY,
             fieldName: UserModel.IMAGE_URL);
     });

   }


}