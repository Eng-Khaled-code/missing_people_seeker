import 'package:finalmps/PL/home/orders/add_missed/add_missed_2.dart';
import 'package:finalmps/PL/utilites/helper/helper.dart';
import 'package:finalmps/PL/utilites/widgets/custom_button.dart';
import 'package:finalmps/PL/utilites/widgets/error_dialog.dart';
import 'package:finalmps/PL/utilites/widgets/gender/gender_widget.dart';
import 'package:finalmps/PL/home/orders/add_missed/person_round_corner_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../utilites/text_style/text_styles.dart';
import '../../../utilites/widgets/background_image.dart';
import '../../../utilites/widgets/custom_text_field.dart';

// ignore: must_be_immutable
class AddMissed1 extends StatelessWidget {
  final String? addOrUpdate;

  String? imagePath;
  String? orderId;
  String? type;
  String? helthyStatus;
  String? fullName;
  String? age;
  String? gender;
  String? lastPlace;
  String? faceColor;
  String? hairColor;
  String? eyeColor;

  AddMissed1(
      {@required this.addOrUpdate,
      this.type,
      this.orderId,
      this.imagePath,
      this.helthyStatus,
      this.fullName,
      this.age,
      this.gender,
      this.lastPlace,
      this.faceColor,
      this.hairColor,
      this.eyeColor});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    GenderRadioButtonState.gender = addOrUpdate == "تعديل" ? gender! : "ذكر";
    MissingImageState.imagePath = addOrUpdate == "تعديل" ? imagePath! : "";
    return Directionality(
        textDirection: TextDirection.rtl,
        child: WillPopScope(
          onWillPop: () {
            if (addOrUpdate == "تعديل") {
              Navigator.pop(context);
              Navigator.pop(context);
            } else
              Navigator.pop(context);

            return Future.delayed(Duration(seconds: 0));
          },
          child: Scaffold(
              appBar: AppBar(
                title: Text(
                  "$addOrUpdate" + " طلب " + "$type",
                  style: TextStyles.title,
                ),
              ),
              body: Container(
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
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
                                  horizontal: 20.0, vertical: 10.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  MissingImage(),
                                  SizedBox(height: 20.0),
                                  CustomTextField(
                                    label: type != "فقد"
                                        ? "الاسم بالكامل (إن أمكن)"
                                        : "الاسم بالكامل",
                                    icon: Icons.person_outline,
                                    onSave: (value) => fullName = value,
                                    initialValue: fullName,
                                  ),
                                  SizedBox(height: 20.0),
                                  CustomTextField(
                                    label: type != "فقد"
                                        ? "السن (إن أمكن)"
                                        : "السن",
                                    icon: Icons.person_outline,
                                    initialValue: age,
                                    onSave: (value) => age = value,
                                  ),
                                  SizedBox(height: 20.0),
                                  GenderRadioButton(),
                                  Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 20),
                                      child: CustomButton(
                                        text: "التالي",
                                        onPress: () => navigateToNext(context),
                                      )),
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

  navigateToNext(BuildContext context) {
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
      _formKey.currentState!.save();
      if (addOrUpdate == "تعديل") {
        AddMissed2.eyeColor = eyeColor;
        AddMissed2.faceColor = faceColor;
        AddMissed2.hairColor = hairColor;
      }
      Helper().goTo(
          context: context,
          to: addOrUpdate == "تعديل"
              ? AddMissed2(
                  orderId: orderId,
                  addOrUpdate: addOrUpdate,
                  imageFile: MissingImageState.imageFile,
                  fullName: fullName,
                  age: age,
                  gender: GenderRadioButtonState.gender,
                  type: type,
                  helthyStatus: helthyStatus,
                  lastPlace: lastPlace,
                )
              : AddMissed2(
                  addOrUpdate: addOrUpdate,
                  imageFile: MissingImageState.imageFile,
                  fullName: fullName,
                  age: age,
                  gender: GenderRadioButtonState.gender,
                  type: type));
      //  }
    }
  }
}
