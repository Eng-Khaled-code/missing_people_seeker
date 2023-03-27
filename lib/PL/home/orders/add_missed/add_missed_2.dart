import 'dart:io';
import 'package:finalmps/PL/utilites/helper/helper.dart';
import 'package:finalmps/PL/utilites/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:finalmps/PL/home/orders/add_missed/custom_dropdown_button.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:finalmps/provider/missed_change.dart';
import 'package:finalmps/PL/home/orders/orders_page/orders.dart';
import 'package:finalmps/provider/user_change.dart';
import '../../../authentication/loding_screen.dart';
import '../../../utilites/text_style/text_styles.dart';
import '../../../utilites/widgets/background_image.dart';
import '../../../utilites/widgets/custom_text_field.dart';

class AddMissed2 extends StatelessWidget {
  final File? imageFile;
  final String? addOrUpdate;
  final String? fullName;
  final String? age;
  final String? gender;
  final String? type;
  final String? orderId;

   String? lastPlace;
  static String? faceColor;
  static String? hairColor;
  static String? eyeColor;
  static String? error;

  String? helthyStatus;

  AddMissed2(
      {this.imageFile,
      this.addOrUpdate,
      this.orderId,
      this.fullName,
      this.lastPlace,
      this.age,
      this.gender,
      this.type,
      this.helthyStatus});

  final _formKey = GlobalKey<FormState>();

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
  Widget build(BuildContext context) {
    MissedChange missedChange = Provider.of<MissedChange>(context);
    UserChange user = Provider.of<UserChange>(context);

    faceColor = addOrUpdate == "تعديل" ? faceColor : "اختر واحدة";
    hairColor = addOrUpdate == "تعديل" ? hairColor : "اختر واحدة";
    eyeColor =addOrUpdate == "تعديل" ? eyeColor : "اختر واحدة";

    return Scaffold(
        appBar: AppBar(
          title: Text(
            "$addOrUpdate" + " طلب " + "$type",
            style: TextStyles.title,
          ),
        ),
        body: missedChange.isLoading
            ? LoadingScreen(progressColor: Colors.blue)
            : Container(
                child:
                    Stack(alignment: Alignment.center, children: <Widget>[
                BackgroundImage(),
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
                                  label: "اخر مكان وجد به",
                                  icon: Icons.location_on,
                                  onSave:(value)=> lastPlace=value,
                                  initialValue: lastPlace),
                              SizedBox(height: 20.0),
                              CustomTextField(
                                  label: "الحالة الصحية",
                                  icon: Icons.add_box,
                                  onSave:(value)=> helthyStatus=value,
                                  initialValue: helthyStatus),
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
                                    text: "تسجيل",
                                    onPress: () => onRegisterButtonPressed(missedChange, user,context),
                                 ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ])));
  }

  onRegisterButtonPressed(MissedChange missedChange, UserChange user,BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      if (faceColor == "اختر واحدة")
        Fluttertoast.showToast(msg: "إختر لون البشرة",toastLength: Toast.LENGTH_LONG);
      else if (hairColor == "اختر واحدة")
        Fluttertoast.showToast(msg: "إختر لون الشعر",toastLength: Toast.LENGTH_LONG);
      else if (eyeColor == "اختر واحدة")
        Fluttertoast.showToast(msg: "إختر لون العين",toastLength: Toast.LENGTH_LONG);
      else {

            if (addOrUpdate == "تعديل") {
              //updating

              if (imageFile == null) {
                if (!await missedChange.updateMissingOrderWithNoImage(
                    id: orderId,
                    gender: gender,
                    name: fullName,
                    age: age,
                    eyeColor: eyeColor,
                    faceColor: faceColor,
                    hairColor: hairColor,
                    helthStatus:helthyStatus,
                    lastPlace: lastPlace)) {
                  Fluttertoast.showToast(msg:error!);
                } else {
                  Fluttertoast.showToast(msg: "تم تعديل طلبك بنجاح");
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Helper().goTo(context: context,to: Orders(type == "فقد" ? "0" : "1"));
                }
              } else {
                if (!await missedChange.updateMissingOrderWithImage(
                    id: orderId,
                    type: type,
                    gender: gender,
                    name: fullName,
                    age: age,
                    eyeColor: eyeColor,
                    faceColor: faceColor,
                    hairColor: hairColor,
                    helthStatus:helthyStatus,
                    lastPlace: lastPlace,
                    imageFile:imageFile)) {
                  Fluttertoast.showToast(msg:error!);

                } else {
                  Fluttertoast.showToast(msg: "تم تعديل طلبك بنجاح");
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Helper().goTo(context: context,to:Orders(type == "فقد" ? "0" : "1"));
                }
              }
            } else {
              //addition

              if (!await missedChange.addMissingOrder(
                  userId: user.userData!.id,
                  type: type,
                  gender: gender,
                  name: fullName,
                  age:age,
                  eyeColor: eyeColor,
                  faceColor: faceColor,
                  hairColor: hairColor,
                  helthStatus:helthyStatus,
                  lastPlace: lastPlace,
                  imageFile: imageFile)) {
                Fluttertoast.showToast(msg:error!);

              } else {
                Fluttertoast.showToast(msg: "تم إضافة طلبك بنجاح");
                Navigator.pop(context);
                Navigator.pop(context);
                Helper().goTo(context: context,to: Orders(type == "فقد" ? "0" : "1"));
              }
            }

      }
    }
  }
}
