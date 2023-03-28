import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';

class StorageServices {
  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  Future<void> uploadingImageToStorage(
      {File? image,
      String? docId,
      String? type,
      String? collection,
      String? storageDirectoryPath,
      String? fieldName}) async {
    String? imgFileName = docId;
    try {
      Uint8List fileBytes = await image!.readAsBytes();
      if (type == "update") {
        await deleteImageFromStorage(
            storageDirectoryPath: storageDirectoryPath, imgFileName: docId);
      }

      Reference storageReference = _firebaseStorage
          .ref()
          .child(storageDirectoryPath!)
          .child(imgFileName!);

      UploadTask storageUploadTask;
      if (kIsWeb)
        storageUploadTask = storageReference.putData(fileBytes);
      else
        storageUploadTask = storageReference.putFile(image);

      await storageUploadTask.whenComplete(() {});

      await storageReference.getDownloadURL().then((profileURL) async {
        await FirebaseFirestore.instance
            .collection(collection!)
            .doc(docId)
            .update({"image_url": profileURL});
      });
    } on FirebaseException catch (e) {
      print("image error " + e.message!);
      Fluttertoast.showToast(msg: "image error " + e.message!);
    }
  }

  Future<void> deleteImageFromStorage(
      {String? imgFileName, String? storageDirectoryPath}) async {
    try {
      await _firebaseStorage
          .ref()
          .child(storageDirectoryPath!)
          .child(imgFileName!)
          .delete();
    } catch (ex) {}
  }
}
