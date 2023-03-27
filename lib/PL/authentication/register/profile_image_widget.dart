import 'dart:io';
import 'package:finalmps/provider/user_change.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileImageWidget extends StatelessWidget {
  const ProfileImageWidget({key,this.userChange}):super (key:key);
  final UserChange? userChange;
  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap:()=> selectAndPickImage(),
      child: ClipOval(
    child:Container(
        color: Colors.white,
        width: 200,height: 200,child:
    userChange!.profileImage==null
    ?
    addPhotoIcon(context)
        :
    kIsWeb
    ?
    Image.network(userChange!.profileImage!.path,fit: BoxFit.cover,)
        :
    Image.file(userChange!.profileImage!,fit: BoxFit.cover)
    )));
  }

  addPhotoIcon(BuildContext context)
  {
    return Icon(
      Icons.add_photo_alternate,
      size: MediaQuery.of(context).size.width * 0.1,
    );
  }

  Future<void> selectAndPickImage() async {
    final image=await ImagePicker().pickImage(source: ImageSource.gallery);
    userChange!.setProfileImage(File(image!.path));
  }

}
