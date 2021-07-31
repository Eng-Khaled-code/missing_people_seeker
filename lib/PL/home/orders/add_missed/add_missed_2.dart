import 'dart:io';
import 'package:finalmps/PL/utilites/custom_button.dart';
import 'package:finalmps/PL/utilites/custom_textfield.dart';
import 'package:finalmps/PL/utilites/loding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:finalmps/PL/utilites/custom_dropdown_button.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:finalmps/provider/missed_change.dart';
import 'package:finalmps/PL/home/orders/orders.dart';
import 'package:finalmps/provider/user_change.dart';

class AddMissed2 extends StatefulWidget {
  final XFile? imageFile;
  final String? addOrUpdate;
  final String? fullName;
  final String? age;
  final String? gender;
  final String? type;
  final String? orderId;

  final String? lastPlace;
  final String? oldFaceColor;
  final String? oldHairColor;
  final String? oldEyeColor;
  final String? oldHelthyStatus;

  static String? selctedHairColor;
  static String? selctedFaceColor;
  static String? selctedEyeColor;
  static String? error;

  AddMissed2(
      {this.imageFile,
      this.addOrUpdate,
      this.orderId,
      this.fullName,
      this.lastPlace,
      this.age,
      this.gender,
      this.type,
      this.oldFaceColor,
      this.oldHairColor,
      this.oldEyeColor,
      this.oldHelthyStatus});

  @override
  _AddMissed2State createState() => _AddMissed2State();
}

class _AddMissed2State extends State<AddMissed2> {
  final _formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController? _txtLastPlace;
  TextEditingController? _txtHelthyStatus;

  List<String> faceColorList = ["اختر واحدة", "غامق", "أسمر", "أبيض"];
  List<String> hairColorList = ["اختر واحدة", "أسود", "أصفر", "يحتوي أبيضي"];
  List<String> eyeColorList = [
    "اختر واحدة",
    "أسود",
    "أزرق",
    "أخضر",
    "عسلي",
    "رمادي"
  ];

  @override
  void initState() {
    super.initState();
    _txtLastPlace = TextEditingController(
        text: widget.addOrUpdate == "تعديل" ? widget.lastPlace : "");
    _txtHelthyStatus = TextEditingController(
        text: widget.addOrUpdate == "تعديل" ? widget.oldHelthyStatus : "");
    AddMissed2.selctedFaceColor =
        widget.addOrUpdate == "تعديل" ? widget.oldFaceColor : "اختر واحدة";
    AddMissed2.selctedHairColor =
        widget.addOrUpdate == "تعديل" ? widget.oldHairColor : "اختر واحدة";
    AddMissed2.selctedEyeColor =
        widget.addOrUpdate == "تعديل" ? widget.oldEyeColor : "اختر واحدة";
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _txtLastPlace!.dispose();
    _txtHelthyStatus!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    MissedChange missedChange = Provider.of<MissedChange>(context);
    UserChange user = Provider.of<UserChange>(context);

    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
            key: scaffoldKey,
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
            body: missedChange.isLoading
                ? LoadingScreen()
                : Container(
                    child:
                        Stack(alignment: Alignment.center, children: <Widget>[
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
                                  horizontal: 20.0, vertical: 30.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomTextField(
                                      lable: "اخر مكان وجد به",
                                      icon: Icons.location_on,
                                      controller: _txtLastPlace!,
                                      color: Colors.white),
                                  SizedBox(height: 20.0),
                                  CustomTextField(
                                      lable: "الحالة الصحية",
                                      icon: Icons.add_box,
                                      controller: _txtHelthyStatus!,
                                      color: Colors.white),
                                  CustomDropdownButton(
                                      items: faceColorList,
                                      lable: "لون البشرة"),
                                  CustomDropdownButton(
                                      items: hairColorList, lable: "لون الشعر"),
                                  CustomDropdownButton(
                                      items: eyeColorList, lable: "لون العين"),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: CustomButton(
                                        color: [
                                          Color(0xFF1E88E5),
                                          Color(0xFF0D47A1)
                                        ],
                                        text: "تسجيل",
                                        onPress: () => onRegisterButtonPressed(
                                            missedChange, user),
                                        textColor: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ]))));
  }

  onRegisterButtonPressed(MissedChange missedChange, UserChange user) async {
    if (_formKey.currentState!.validate()) {
      if (AddMissed2.selctedFaceColor == "اختر واحدة")
        scaffoldKey.currentState!
            .showSnackBar(SnackBar(content: Text("إختر لون البشرة")));
      else if (AddMissed2.selctedHairColor == "اختر واحدة")
        scaffoldKey.currentState!
            .showSnackBar(SnackBar(content: Text("إختر لون الشعر")));
      else if (AddMissed2.selctedEyeColor == "اختر واحدة")
        scaffoldKey.currentState!
            .showSnackBar(SnackBar(content: Text("إختر لون العين")));
      else {
        try {
          final result = await InternetAddress.lookup('google.com');
          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            if (widget.addOrUpdate == "تعديل") {
              //updating

              if (widget.imageFile == null) {
                if (!await missedChange.updateMissingOrderWithNoImage(
                    id: widget.orderId,
                    gender: widget.gender,
                    name: widget.fullName,
                    age: widget.age,
                    eyeColor: AddMissed2.selctedEyeColor,
                    faceColor: AddMissed2.selctedFaceColor,
                    hairColor: AddMissed2.selctedHairColor,
                    helthStatus: _txtHelthyStatus!.text,
                    lastPlace: _txtLastPlace!.text)) {
                  scaffoldKey.currentState!.showSnackBar(
                      SnackBar(content: Text("${AddMissed2.error}")));
                } else {
                  Fluttertoast.showToast(msg: "تم تعديل طلبك بنجاح");
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              Orders(widget.type == "فقد" ? "0" : "1")));
                }
              } else {
                if (!await missedChange.updateMissingOrderWithImage(
                    id: widget.orderId,
                    type: widget.type,
                    gender: widget.gender,
                    name: widget.fullName,
                    age: widget.age,
                    eyeColor: AddMissed2.selctedEyeColor,
                    faceColor: AddMissed2.selctedFaceColor,
                    hairColor: AddMissed2.selctedHairColor,
                    helthStatus: _txtHelthyStatus!.text,
                    lastPlace: _txtLastPlace!.text,
                    imageFile: widget.imageFile)) {
                  scaffoldKey.currentState!.showSnackBar(
                      SnackBar(content: Text("${AddMissed2.error}")));
                } else {
                  Fluttertoast.showToast(msg: "تم تعديل طلبك بنجاح");
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              Orders(widget.type == "فقد" ? "0" : "1")));
                }
              }
            } else {
              //addition

              if (!await missedChange.addMissingOrder(
                  userId: user.userInformation.id,
                  type: widget.type,
                  gender: widget.gender,
                  name: widget.fullName,
                  age: widget.age,
                  eyeColor: AddMissed2.selctedEyeColor,
                  faceColor: AddMissed2.selctedFaceColor,
                  hairColor: AddMissed2.selctedHairColor,
                  helthStatus: _txtHelthyStatus!.text,
                  lastPlace: _txtLastPlace!.text,
                  imageFile: widget.imageFile)) {
                scaffoldKey.currentState!.showSnackBar(
                    SnackBar(content: Text("${AddMissed2.error}")));
              } else {
                Fluttertoast.showToast(msg: "تم إضافة طلبك بنجاح");
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            Orders(widget.type == "فقد" ? "0" : "1")));
              }
            }
          }
        } on SocketException catch (_) {
          scaffoldKey.currentState!.showSnackBar(
              SnackBar(content: Text("تأكد من إتصالك بالإنترنت")));
        }
      }
    }
  }
}
