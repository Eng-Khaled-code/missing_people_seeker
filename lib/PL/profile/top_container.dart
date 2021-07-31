import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:finalmps/models/user_model.dart';
import 'package:finalmps/provider/user_change.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TopContainer extends StatefulWidget {
  final UserModel? userModel;
  static String? error;

  TopContainer({this.userModel});

  @override
  _TopContainerState createState() => _TopContainerState();
}

class _TopContainerState extends State<TopContainer> {
  XFile? _imageFile;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    UserChange user = Provider.of<UserChange>(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(height: 20.0),
        InkWell(
            onTap: () async {
              try {
                final result = await InternetAddress.lookup('google.com');
                if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                  onPressPhotoButton(context, user);
                }
              } on SocketException catch (_) {
                Fluttertoast.showToast(
                    msg: "تأكد من إتصالك بالإنترنت",
                    toastLength: Toast.LENGTH_LONG);
              }
            },
            child: ClipRRect(
                borderRadius: BorderRadius.circular(60),
                child: user.isImageLoading == true
                    ? Container(
                        width: width * .2,
                        height: height * 0.1,
                        child: Center(child: CircularProgressIndicator()))
                    : Container(
                        color: "${widget.userModel?.imageUrl}" == "no image"
                            ? Colors.transparent
                            : Colors.grey,
                        width: height * .16,
                        height: height * .16,
                        child: _imageFile != null
                            ? Image.file(
                                File(_imageFile!.path),
                                fit: BoxFit.cover,
                              )
                            : "${widget.userModel!.imageUrl}" == "no image"
                                ? Icon(
                                    Icons.account_circle,
                                    size: height * .17,
                                  )
                                : Image.network(
                                    "${widget.userModel!.imageUrl}",
                                    fit: BoxFit.cover,
                                  ),
                      ))),
        SizedBox(height: 4.0),
        Text(
          "${widget.userModel!.fName} " + "${widget.userModel!.lName}",
          style: TextStyle(
            fontSize: height * .02,
          ),
        ),
        Text(
          "${widget.userModel!.email}",
          style: TextStyle(
            fontSize: height * .02,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }

  onPressPhotoButton(BuildContext context, UserChange user) {
    return showDialog(
        context: context,
        builder: (con) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: SimpleDialog(
              title: Text(
                "تعديل صورة الملف الشخصي",
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold),
              ),
              children: [
                SimpleDialogOption(
                  child: Text("التقاط بالكاميرا"),
                  onPressed: () async {
                    Navigator.pop(context);
                    final XFile? image = await ImagePicker().pickImage(
                        source: ImageSource.camera,
                        maxHeight: 680.0,
                        maxWidth: 970.0);

                    if (!await user.updateProfilePicture(
                        imageFile: image, userId: user.userInformation.id))
                      Fluttertoast.showToast(msg: "${TopContainer.error}");
                    else {
                      setState(() {
                        _imageFile = image;
                      });

                      Fluttertoast.showToast(msg: "تم تحديث الصورة بنجاح ");
                    }
                  },
                ),
                SimpleDialogOption(
                  child: Text("إختيار من المعرض"),
                  onPressed: () async {
                    Navigator.pop(context);
                    final XFile? image = await ImagePicker()
                        .pickImage(source: ImageSource.gallery);
                    if (!await user.updateProfilePicture(
                        imageFile: image, userId: user.userInformation.id))
                      Fluttertoast.showToast(msg: "${TopContainer.error}");
                    else {
                      setState(() {
                        _imageFile = image;
                      });

                      Fluttertoast.showToast(msg: "تم تحديث الصورة بنجاح ");
                    }
                  },
                ),
                SimpleDialogOption(
                  child: Text("إلغاء"),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          );
        });
  }
}
