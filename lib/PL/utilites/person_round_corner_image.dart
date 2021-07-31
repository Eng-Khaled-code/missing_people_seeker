import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class MissingImage extends StatefulWidget {
  MissingImageState createState() => MissingImageState();
}

class MissingImageState extends State<MissingImage> {
  static XFile? imageFile;
  static String? imagePath;
  bool isLoading = false;
  ui.Image? _image;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
          height: MediaQuery.of(context).size.height * 0.6,
          width: double.infinity,
          child: isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : imageFile != null
                  ? InkWell(
                      onTap: ontap,
                      child:
                          Image.file(File(imageFile!.path), fit: BoxFit.cover))
                  : imageFile == null && imagePath == ""
                      ? Padding(
                          padding: EdgeInsets.all(8.0),
                          child: OutlineButton(
                            onPressed: ontap,
                            borderSide: BorderSide(
                                color: Colors.grey.withOpacity(0.5), width: 1),
                            child: Icon(Icons.add_a_photo,
                                size: 80, color: Colors.grey.withOpacity(.5)),
                          ))
                      : InkWell(
                          onTap: ontap,
                          child: Image.network(
                            imagePath!,
                            fit: BoxFit.fill,
                          ))),
    );
  }

  ontap() async {
    final XFile? image =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      imageFile = image;
    });
  }

//  ontapFaceDetect() async {
//    try {
//      final result = await InternetAddress.lookup('google.com');
//      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
//        final XFile? image =
//            await ImagePicker().pickImage(source: ImageSource.gallery);
//        setState(() {
//          isLoading = true;
//        });
//        if (image != null) {
//          final firebaseVisionImage =
//              FirebaseVisionImage.fromFile(File(image.path));
//          final faceDetector = FirebaseVision.instance.faceDetector();
//          List<Face> _innerFaces =
//              await faceDetector.processImage(firebaseVisionImage);
//
//          if (mounted) {
//            setState(() {
//              imageFile = image;
//              faces = _innerFaces;
//              _loadImage(File(image.path));
//            });
//          }
//        } else {
//          setState(() {
//            isLoading = false;
//          });
//        }
//      }
//    } on SocketException catch (_) {
//      Fluttertoast.showToast(
//          msg: "تأكد من إتصالك بالإنترنت", toastLength: Toast.LENGTH_LONG);
//    }
//  }

  _loadImage(File file) async {
    final data = await file.readAsBytes();
    await decodeImageFromList(data).then((value) {
      setState(() {
        _image = value;
        isLoading = false;
      });
    });
  }
}
//
//class FacePainter extends CustomPainter {
//  final ui.Image image;
//  final List<Face> faces;
//  final List<Rect> rects = [];
//
//  FacePainter(this.image, this.faces) {
//    faces.forEach((element) {
//      rects.add(element.boundingBox);
//    });
//  }
//
//  @override
//  void paint(Canvas canvas, Size size) {
//    final Paint paint = Paint()
//      ..style = PaintingStyle.stroke
//      ..strokeWidth = 10.0
//      ..color = Colors.yellow;
//
//    canvas.drawImage(image, Offset.zero, paint);
//    for (int i = 0; i < faces.length; i++) {
//      canvas.drawRect(rects[i], paint);
//    }
//  }
//
//  @override
//  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
//}
