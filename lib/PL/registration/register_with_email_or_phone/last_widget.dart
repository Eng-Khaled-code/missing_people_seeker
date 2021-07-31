import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:finalmps/PL/utilites/custom_button.dart';
import 'package:finalmps/PL/utilites/custom_textfield.dart';
import 'package:finalmps/PL/utilites/error_dialog.dart';
import 'package:finalmps/PL/utilites/loding_screen.dart';
import 'package:finalmps/PL/utilites/password_text_field.dart';
import 'package:finalmps/provider/user_change.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class LastWidget extends StatefulWidget {
  final XFile? imageFile;
  final String? fName;
  final String? lName;
  final String? gender;
  final String? SSN;
  final String? PhoneNumber;
  final String? address;
  final String? birthDate;

  LastWidget(
      {this.imageFile,
      this.fName,
      this.lName,
      this.gender,
      this.SSN,
      this.PhoneNumber,
      this.address,
      this.birthDate});

  @override
  LastWidgetState createState() => LastWidgetState();
}

class LastWidgetState extends State<LastWidget> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  static String? error;
  TextEditingController _txtUsername = TextEditingController();
  TextEditingController _txtPassword = TextEditingController();
  TextEditingController _txtConfermPassword = TextEditingController();

  @override
  void dispose() {
    _txtUsername.dispose();
    _txtPassword.dispose();
    _txtConfermPassword.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserChange>(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              "تسجيل مستخدم جديد",
              style: TextStyle(color: Colors.black, fontSize: 16.0),
            ),
          ),
          key: _scaffoldKey,
          body: user.status == Status.Authenticating
              ? LoadingScreen()
              : Container(
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
                                      horizontal: 20.0, vertical: 30.0),
                                  child: _buildingBodyWidget(user)),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )),
    );
  }

  Widget _buildingBodyWidget(UserChange user) {
    return Column(children: [
      CustomTextField(
          lable: "الإيميل",
          icon: Icons.mail_outline,
          controller: _txtUsername,
          color: Colors.white),
      SizedBox(height: 20.0),
      PasswordTextField(
          lable: "كلمة المرور", controller: _txtPassword, color: Colors.white),
      SizedBox(height: 20.0),
      PasswordTextField(
        lable: "تاكيد كلمة المرور",
        controller: _txtConfermPassword,
        color: Colors.white,
        mainPassword: _txtPassword.text,
      ),
      _buildingRegisterWidget(user)
    ]);
  }

  onRegisterButtonPressed(UserChange user) async {
    if (_txtPassword.text != _txtConfermPassword.text) {
      showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(
              message: "كلمتا المرور غير متطابقتان",
            );
          });
    } else if (_formKey.currentState!.validate() &&
        _txtPassword.text == _txtConfermPassword.text) {
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          if (!await user.signUpWithEmail(
              firstName: widget.fName,
              lastName: widget.lName,
              gender: widget.gender,
              profileImage: widget.imageFile,
              SSN: widget.SSN,
              phoneNumber: widget.PhoneNumber,
              birthDate: widget.birthDate,
              address: widget.address,
              password: _txtPassword.text,
              email: _txtUsername.text)) {
            _scaffoldKey.currentState!.showSnackBar(
                SnackBar(content: Text(" فشل التسجيل لان " + "$error")));
          } else {
            //back to screen controller to automatic navigate to home screen
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.pop(context);
            Fluttertoast.showToast(
                msg: "تم تسجيل المستخدم بالفعل",
                toastLength: Toast.LENGTH_LONG,
                backgroundColor: Colors.grey);
          }
        }
      } on SocketException catch (_) {
        _scaffoldKey.currentState!.showSnackBar(
            SnackBar(content: Text("تأكد من إتصالك بالإنترنت" + "$error")));
      }
    }
  }

  Widget _buildingRegisterWidget(UserChange user) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: CustomButton(
          color: [Color(0xFF1E88E5), Color(0xFF0D47A1)],
          text: "تسجيل",
          onPress: () => onRegisterButtonPressed(user),
          textColor: Colors.white),
    );
  }
}
