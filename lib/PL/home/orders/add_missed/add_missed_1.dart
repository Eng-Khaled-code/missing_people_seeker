import 'package:finalmps/PL/home/orders/add_missed/add_missed_2.dart';
import 'package:finalmps/PL/utilites/custom_button.dart';
import 'package:finalmps/PL/utilites/custom_textfield.dart';
import 'package:finalmps/PL/utilites/error_dialog.dart';
import 'package:finalmps/PL/utilites/gender_widget.dart';
import 'package:finalmps/PL/utilites/person_round_corner_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddMissed1 extends StatefulWidget {
  final String? orderId;
  final String? type;
  final String? addOrUpdate;
  final String? imagePath;
  final String? helthyStatus;
  final String? fullName;
  final String? age;
  final String? gender;
  final String? lastPlace;
  final String? faceColor;
  final String? hairColor;
  final String? eyeColor;

  AddMissed1(
      {@required this.addOrUpdate,
      @required this.type,
      @required this.orderId,
      @required this.imagePath,
      @required this.helthyStatus,
      @required this.fullName,
      @required this.age,
      @required this.gender,
      @required this.lastPlace,
      @required this.faceColor,
      @required this.hairColor,
      @required this.eyeColor});

  @override
  _AddMissed1State createState() => _AddMissed1State();
}

class _AddMissed1State extends State<AddMissed1> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController? _txtFullname;
  TextEditingController? _txtage;

  @override
  void initState() {
    super.initState();
    _txtFullname = TextEditingController(
        text: widget.addOrUpdate == "تعديل" ? widget.fullName : "");
    _txtage = TextEditingController(
        text: widget.addOrUpdate == "تعديل" ? widget.age : "");

    setState(() {
      GenderRadioButtonState.gender =
          widget.addOrUpdate == "تعديل" ? widget.gender! : "ذكر";
      MissingImageState.imagePath =
          widget.addOrUpdate == "تعديل" ? widget.imagePath! : "";
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    MissingImageState.imageFile = null;
    MissingImageState.imagePath = null;

    GenderRadioButtonState.gender = "ذكر";
    _txtFullname!.dispose();
    _txtage!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Directionality(
        textDirection: TextDirection.rtl,
        child: WillPopScope(
          onWillPop: () {
            if (widget.addOrUpdate == "تعديل") {
              Navigator.pop(context);
              Navigator.pop(context);
            } else
              Navigator.pop(context);

            return Future.delayed(Duration(seconds: 0));
          },
          child: Scaffold(
              appBar: AppBar(
                flexibleSpace: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF1E88E5),
                        Color(0xFF0D47A1),
                      ],
                      begin: Alignment.bottomRight,
                      end: Alignment.topLeft,
                    ),
                  ),
                ),
                title: Text(
                  "${widget.addOrUpdate}" + " طلب " + "${widget.type}",
                  style: TextStyle(color: Colors.white, fontSize: 16.0),
                ),
              ),
              body: Container(
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Container(
                      height: height,
                      width: width,
                      child: Opacity(
                          opacity: 0.5,
                          child: Image.asset(
                            'assets/images/splach_bg.png',
                            fit: BoxFit.fill,
                          )),
                    ),
                    Form(
                      key: _formKey,
                      child: AnnotatedRegion<SystemUiOverlayStyle>(
                        value: SystemUiOverlayStyle.light,
                        child: GestureDetector(
                          onTap: () => FocusScope.of(context).unfocus(),
                          child: Container(
                            height: double.infinity,
                            child: SingleChildScrollView(
                              physics: AlwaysScrollableScrollPhysics(),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  MissingImage(),
                                  SizedBox(height: 20.0),
                                  CustomTextField(
                                      lable: widget.type != "فقد"
                                          ? "الاسم بالكامل (إن أمكن)"
                                          : "الاسم بالكامل",
                                      icon: Icons.person_outline,
                                      controller: _txtFullname!,
                                      color: Colors.white),
                                  SizedBox(height: 20.0),
                                  CustomTextField(
                                      lable: widget.type != "فقد"
                                          ? "السن (إن أمكن)"
                                          : "السن",
                                      icon: Icons.person_outline,
                                      controller: _txtage!,
                                      color: Colors.white),
                                  SizedBox(height: 20.0),
                                  GenderRadioButton(),
                                  Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 20),
                                      child: CustomButton(
                                          color: [
                                            Color(0xFF1E88E5),
                                            Color(0xFF0D47A1)
                                          ],
                                          text: "التالي",
                                          onPress: () => navigateToNext(),
                                          textColor: Colors.white)),
                                  SizedBox(height: 70.0)
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ));
  }

  navigateToNext() {
    //MissingImageState.imageFile ==null the user has not update the image
    if (MissingImageState.imageFile == null &&
        (MissingImageState.imagePath == null ||
            MissingImageState.imagePath == "")) {
      showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(
              message: "من فضلك اختر صورة للشخص المفقود",
            );
          });
    } else if (_formKey.currentState!.validate()) {
//      if (MissingImageState.faces == null ||
//          MissingImageState.faces.length == 0) {
//        showDialog(
//            context: context,
//            builder: (c) {
//              return ErrorDialog(
//                message: "من فضلك اختر صورة تحتوي علي شخص",
//              );
//            });
//      } else if (MissingImageState.faces.length > 1) {
//        showDialog(
//            context: context,
//            builder: (c) {
//              return ErrorDialog(
//                message: "من فضلك اختر صورة تحتوي علي شخص واحد",
//              );
//            });
//      } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => widget.addOrUpdate == "تعديل"
                  ? AddMissed2(
                      orderId: widget.orderId,
                      addOrUpdate: widget.addOrUpdate,
                      imageFile: MissingImageState.imageFile,
                      fullName: _txtFullname!.text,
                      age: _txtage!.text,
                      gender: GenderRadioButtonState.gender,
                      type: widget.type,
                      oldEyeColor: widget.eyeColor,
                      oldFaceColor: widget.faceColor,
                      oldHairColor: widget.hairColor,
                      oldHelthyStatus: widget.helthyStatus,
                      lastPlace: widget.lastPlace,
                    )
                  : AddMissed2(
                      addOrUpdate: widget.addOrUpdate,
                      imageFile: MissingImageState.imageFile,
                      fullName: _txtFullname!.text,
                      age: _txtage!.text,
                      gender: GenderRadioButtonState.gender,
                      type: widget.type)));
      //  }
    }
  }
}
