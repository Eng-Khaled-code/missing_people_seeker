import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalmps/PL/utilites/strings.dart';
import 'package:finalmps/services/uploding_orders_image.dart';
import 'package:finalmps/services/user_services/user_services.dart';
import 'package:finalmps/services/missed_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:finalmps/services/notify_services.dart';
import 'dart:io';
import 'package:finalmps/PL/home/orders/add_missed/add_missed_2.dart';
import 'package:finalmps/models/missed_model.dart';
import 'package:finalmps/models/found_model.dart';
import 'package:finalmps/models/user_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart' as p;

class MissedChange with ChangeNotifier {
  bool isLoading = false;
  MissedSrvices _missedServeces = MissedSrvices();
  OrdersImageServices _ordersImageServices = OrdersImageServices();

  MissedChange.initialize();

  Future<MissedModel> loadOrderData({String? orderId}) async {
    MissedModel _orderData;
    _orderData = await NotifyServices().loadOrderData(orderId: orderId);
    notifyListeners();
    return _orderData;
  }

  Future<FoundModel> loadFoundOrderData({String? foundOrderId}) async {
    FoundModel _orderData;
    _orderData =
        await _missedServeces.loadFoundedOrders(foundedOrderId: foundOrderId);
    notifyListeners();
    return _orderData;
  }

  Future<bool> addMissingOrder(
      {File? imageFile,
      String? userId,
      String? type,
      String? name,
      String? gender,
      String? age,
      String? helthStatus,
      String? faceColor,
      String? hairColor,
      String? eyeColor,
      String? lastPlace}) async {
    try {
      isLoading = true;
      notifyListeners();

      String docID = DateTime.now().millisecondsSinceEpoch.toString();

      String extention = p.extension(imageFile!.path);
      String imageName = docID + "." + extention;

      String imageURLVar1 = Strings.serverName + "/mps_images/";
      String imageURLVar2 =
          (type == "فقد" ? "missed images" : "found images") + "/" + imageName;
      Map<String, dynamic> data = {
        UserModel.ID: userId,
        MissedModel.ID: docID,
        MissedModel.EYE_COLOR: eyeColor,
        MissedModel.HAIR_COLOR: hairColor,
        MissedModel.FACE_COLOR: faceColor,
        MissedModel.PUBLISH_DATE: docID,
        MissedModel.STATUS: "0",
        MissedModel.AGE: age,
        MissedModel.LAST_PLACE: lastPlace,
        MissedModel.GENDER: gender,
        MissedModel.HELTHY_STATUS: helthStatus,
        MissedModel.NAME: name,
        MissedModel.TYPE: type,
        MissedModel.ADMIN_ID: "",
        MissedModel.IMAGE_URL: imageURLVar1 + imageURLVar2
      };
      await _missedServeces
          .addMissedOrder(docId: docID, data: data)
          .then((value) async {
        String base64 = base64Encode(File(imageFile.path).readAsBytesSync());
        String type1 = type == "فقد" ? "missed images" : "found images";
        String addOrUpdatePhoto = "add";
        Map<String, String> postData = {
          "base64": base64,
          "imagename": imageName,
          "type": type1,
          "addOrUpdatePhoto": addOrUpdatePhoto
        };

        Map<String, dynamic> resultMap =
            await _ordersImageServices.uploadImageToServer(
                postData, Strings.serverName + "/mps_images/upload_photo.php");

        print(resultMap.toString());

        isLoading = false;
        notifyListeners();
      });

      return true;
    } catch (ex) {
      AddMissed2.error = ex.toString();
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> addFoundOrder(
      {String? missedOrderId,
      String? mayBeMissedOrderId,
      String? foundOrderId}) async {
    try {
      isLoading = true;
      notifyListeners();

      await _missedServeces.addFoundOrder(
          missedOrderId: missedOrderId,
          mayBeMissedOrderId: mayBeMissedOrderId,
          foundOrderId: foundOrderId);
      isLoading = false;
      notifyListeners();
      Fluttertoast.showToast(
          msg: "تمت إضافة هذا الطلب الي شاشة الاشخاص الذين تم العثور عليهم",
          toastLength: Toast.LENGTH_LONG);
    } on FirebaseException catch (ex) {
      Fluttertoast.showToast(
        msg: "خطأ " + ex.message!,
        toastLength: Toast.LENGTH_LONG,
      );
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateMissingOrderWithImage(
      {String? id,
      File? imageFile,
      String? name,
      String? gender,
      String? age,
      String? helthStatus,
      String? type,
      String? faceColor,
      String? hairColor,
      String? eyeColor,
      String? lastPlace}) async {
    try {
      isLoading = true;
      notifyListeners();
      String extention = p.extension(imageFile!.path);
      String imageName = id! + "." + extention;

      String imageURLVar1 = Strings.serverName + "/mps_images/";
      String imageURLVar2 =
          (type == "فقد" ? "missed images" : "found images") + "/" + imageName;
      Map<String, dynamic> data = {
        MissedModel.ID: id,
        MissedModel.EYE_COLOR: eyeColor,
        MissedModel.HAIR_COLOR: hairColor,
        MissedModel.FACE_COLOR: faceColor,
        MissedModel.STATUS: "0",
        MissedModel.AGE: age,
        MissedModel.LAST_PLACE: lastPlace,
        MissedModel.GENDER: gender,
        MissedModel.HELTHY_STATUS: helthStatus,
        MissedModel.NAME: name,
        MissedModel.IMAGE_URL: imageURLVar1 + imageURLVar2
      };
      await _missedServeces
          .updateMissedOrder(docId: id, data: data)
          .then((value) async {
        String base64 = base64Encode(File(imageFile.path).readAsBytesSync());
        String type1 = type == "فقد" ? "missed images" : "found images";
        String addOrUpdatePhoto = "update";
        Map<String, String> postData = {
          "base64": base64,
          "imagename": imageName,
          "type": type1,
          "addOrUpdatePhoto": addOrUpdatePhoto
        };

        Map<String, dynamic> resultMap =
            await _ordersImageServices.uploadImageToServer(
                postData, Strings.serverName + "/mps_images/upload_photo.php");

        isLoading = false;
      });
      notifyListeners();

      return true;
    } catch (ex) {
      AddMissed2.error = ex.toString();
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateMissingOrderWithNoImage(
      {String? id,
      String? name,
      String? gender,
      String? age,
      String? helthStatus,
      String? faceColor,
      String? hairColor,
      String? eyeColor,
      String? lastPlace}) async {
    try {
      isLoading = true;
      notifyListeners();

      Map<String, dynamic> data = {
        MissedModel.ID: id,
        MissedModel.EYE_COLOR: eyeColor,
        MissedModel.HAIR_COLOR: hairColor,
        MissedModel.FACE_COLOR: faceColor,
        MissedModel.STATUS: "0",
        MissedModel.AGE: age,
        MissedModel.LAST_PLACE: lastPlace,
        MissedModel.GENDER: gender,
        MissedModel.HELTHY_STATUS: helthStatus,
        MissedModel.NAME: name,
      };
      await _missedServeces
          .updateMissedOrder(docId: id, data: data)
          .whenComplete(() {
        isLoading = false;
        notifyListeners();
      });

      return true;
    } catch (ex) {
      AddMissed2.error = ex.toString();
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteMissingOrder(
      {String? id, String? type, String? imageURL}) async {
    try {
      isLoading = true;
      notifyListeners();

      String imageName = imageURL!.split("/").last;

      print(imageName);

      await _missedServeces.deleteMissedOrder(docId: id).then((value) async {
        String type1 = (type == "missed" ? "missed images" : "found images");
        Map<String, String> postData = {"imagename": imageName, "type": type1};

        Map<String, dynamic> resultMap =
            await _ordersImageServices.uploadImageToServer(
                postData, Strings.serverName + "/mps_images/delete_photo.php");

        print(resultMap.toString());

        isLoading = false;
        notifyListeners();
      });

      return true;
    } catch (ex) {
      Fluttertoast.showToast(
          msg: ex.toString(), toastLength: Toast.LENGTH_LONG);
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<UserModel> getUserData(String userId) async {
    UserModel _userModel;
    _userModel = await UserServices().loadUserInformation(userId);
    notifyListeners();
    return _userModel;
  }
}
