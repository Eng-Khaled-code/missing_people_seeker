import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileImage extends StatefulWidget {
  @override
  ProfileImageState createState() => ProfileImageState();
}

class ProfileImageState extends State<ProfileImage> {
  static XFile? imageFile;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _selectAndPickImage,
      child: CircleAvatar(
          backgroundColor: Colors.blueGrey,
          radius: MediaQuery.of(context).size.width * 0.2,
          backgroundImage:
              imageFile == null ? null : FileImage(File(imageFile!.path)),
          child: imageFile == null
              ? Icon(
                  Icons.add_photo_alternate,
                  size: MediaQuery.of(context).size.width * 0.15,
                  color: Colors.white,
                )
              : null),
    );
  }

  Future<void> _selectAndPickImage() async {
    final XFile? file =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      imageFile = file;
    });
  }
}
