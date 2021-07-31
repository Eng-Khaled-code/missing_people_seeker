import 'package:finalmps/PL/utilites/custom_button.dart';
import 'package:finalmps/PL/utilites/custom_textfield.dart';
import 'package:finalmps/PL/utilites/error_dialog.dart';
import 'package:finalmps/PL/utilites/gender_widget.dart';
import 'package:finalmps/PL/utilites/birthdate_widget.dart';
import 'package:finalmps/provider/user_change.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';

class GoogleSignUpWidgets extends StatefulWidget {
  static String? error;

  @override
  _GoogleSignUpWidgetsState createState() => _GoogleSignUpWidgetsState();
}

class _GoogleSignUpWidgetsState extends State<GoogleSignUpWidgets> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController _txtaddress = TextEditingController();
  TextEditingController _txtSSN = TextEditingController();
  TextEditingController _txtPhone = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _txtaddress.dispose();
    _txtSSN.dispose();
    CustomBirthdateState.selectedBirthDate = "";
    _txtPhone.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    UserChange user = Provider.of<UserChange>(context);

    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              title: Text(
                "تسجيل مستخدم جديد",
                style: TextStyle(color: Colors.black, fontSize: 16.0),
              ),
            ),
            body: Container(
                child: Stack(alignment: Alignment.center, children: <Widget>[
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
                            GenderRadioButton(),
                            SizedBox(height: 20.0),
                            CustomTextField(
                                lable: "الرقم القومي",
                                icon: Icons.person_outline,
                                controller: _txtSSN,
                                color: Colors.white),
                            SizedBox(height: 20.0),
                            CustomTextField(
                                lable: "العنوان",
                                icon: Icons.location_on,
                                controller: _txtaddress,
                                color: Colors.white),
                            SizedBox(height: 20.0),
                            CustomBirthdate(),
                            SizedBox(height: 20.0),
                            CustomTextField(
                                lable: "رقم الهاتف",
                                icon: Icons.call,
                                controller: _txtPhone,
                                color: Colors.white),
                            SizedBox(height: 30.0),
                            CustomButton(
                                color: [Color(0xFF1E88E5), Color(0xFF0D47A1)],
                                text: "تسجيل جديد",
                                onPress: () async => onPressSignUp(user),
                                textColor: Colors.white),
                            SizedBox(height: 20.0),
                            CustomButton(
                                color: [Color(0xFF1E88E5), Color(0xFF0D47A1)],
                                text: "لدي حساب بالفعل",
                                onPress: () async => onPressIHaveAccount(user),
                                textColor: Colors.white),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ]))));
  }

  onPressSignUp(UserChange user) async {
    if (_formKey.currentState!.validate()) {
      if (CustomBirthdateState.selectedBirthDate == "") {
        showDialog(
            context: context,
            builder: (c) {
              return ErrorDialog(
                message: "من فضلك اختر تاريخ الميلاد",
              );
            });
      } else {
        if (!await user.googleSginUp(
            phone: _txtPhone.text,
            gender: GenderRadioButtonState.gender,
            birthDate: CustomBirthdateState.selectedBirthDate,
            address: _txtaddress.text,
            ssn: _txtSSN.text)) {
          print(GoogleSignUpWidgets.error! + " errrrrrrrrrrrrrrrrrrrrrr");

          String error;
          if (GoogleSignUpWidgets.error ==
              "We have blocked all requests from this device due to unusual activity. Try again later.")
            error =
                "ادخلت كلمة مرور غير صحيحة عدة مرات لهذا الإيميل من فضلك سجل  في وقت لاحق.";
          else if (GoogleSignUpWidgets.error ==
              "An internal error has occurred.")
            error = "انت غير متصل بالإنترنت";
          else {
            error = "خطا";
          }

          _scaffoldKey.currentState!
              .showSnackBar(SnackBar(content: Text(error)));
        } else {
          Navigator.pop(context);
          Fluttertoast.showToast(msg: "تم إضافة المستخدم بالفعل");
        }
      }
    }
  }

  onPressIHaveAccount(UserChange user) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        if (!await user.googleSginIn() && GoogleSignUpWidgets.error == "" ||
            GoogleSignUpWidgets.error == null) {
          _scaffoldKey.currentState!
              .showSnackBar(SnackBar(content: Text("انت غير مسجل لدينا")));
        } else {
          Navigator.pop(context);
          Fluttertoast.showToast(msg: "تم تسجيل الدخول بالفعل");
        }
      }
    } on SocketException catch (_) {
      _scaffoldKey.currentState!
          .showSnackBar(SnackBar(content: Text("تأكد من إتصالك بالإنترنت")));
    }
  }
}
