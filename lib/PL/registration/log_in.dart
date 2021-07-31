import 'package:finalmps/PL/registration/forget_password.dart';
import 'package:finalmps/PL/registration/register_with_email_or_phone/start_widget.dart';
import 'package:finalmps/PL/utilites/custom_button.dart';
import 'package:finalmps/PL/utilites/custom_textfield.dart';
import 'package:finalmps/PL/utilites/loding_screen.dart';
import 'package:finalmps/PL/utilites/password_text_field.dart';
import 'package:finalmps/provider/user_change.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:finalmps/PL/registration/google_phone_sign_up/google_sign_up.dart';

class LogIn extends StatefulWidget {
  static String? logInErrorMessage;

  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _txtUsername = TextEditingController();
  TextEditingController _txtPassword = TextEditingController();

  @override
  void dispose() {
    _txtUsername.dispose();
    _txtPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserChange>(context);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(
            "تسجيل الدخول",
            style: TextStyle(
              fontSize: width * .05,
            ),
          ),
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
        ),
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
                                  horizontal: 20.0, vertical: 40.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomTextField(
                                      icon: Icons.mail,
                                      color: Colors.white,
                                      controller: _txtUsername,
                                      lable: "الإيميل"),
                                  SizedBox(height: 15.0),
                                  PasswordTextField(
                                      lable: "كلمة المرور",
                                      color: Colors.white,
                                      controller: _txtPassword),
                                  SizedBox(height: 15.0),
                                  __buildForgetPasswordWidget(),
                                  SizedBox(height: 15.0),
                                  CustomButton(
                                      color: [
                                        Color(0xFF1E88E5),
                                        Color(0xFF0D47A1),
                                      ],
                                      text: "تسجيل الدخول",
                                      onPress: () async =>
                                          onPressLogInButton(user),
                                      textColor: Colors.white),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              .1),
                                  _buildLineSeparatorWidget(),
                                  SizedBox(height: 15.0),
                                  CustomButton(
                                      color: [
                                        Color(0xFF1E88E5),
                                        Color(0xFF0D47A1),
                                      ],
                                      text: "GOOGLE",
                                      onPress: () async =>
                                          onPressGoogleButton(),
                                      textColor: Colors.white),
                                  SizedBox(height: 40.0),
                                  _buildSignUpButtonWidget()
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }

  Widget __buildForgetPasswordWidget() {
    return Container(
      alignment: Alignment.centerRight,
      child: FlatButton(
        child: Text(
          "هل نسيت كلمة المرور؟",
          style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * .03,
              color: Colors.blue),
        ),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ForgetPassWord()));
        },
      ),
    );
  }

  Widget _buildLineSeparatorWidget() {
    return Container(
      child: Row(
        children: [
          Expanded(
              child: Container(
            height: 1,
            color: Colors.black,
          )),
          Text(
            "  او سجل بواسطة  ",
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * .044,
            ),
          ),
          Expanded(
              child: Container(
            height: 1,
            color: Colors.black,
          )),
        ],
      ),
    );
  }

  Widget _buildSignUpButtonWidget() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => StartWidget()));
      },
      child: RichText(
          text: TextSpan(children: [
        TextSpan(
            text: "ليس لديك حساب؟",
            style: TextStyle(
              fontFamily: "main_font",
              color: Colors.black,
              fontSize: 18,
            )),
        TextSpan(
            text: " تسجيل",
            style: TextStyle(
              fontFamily: "main_font",
              color: Colors.pink,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ))
      ])),
    );
  }

  onPressLogInButton(UserChange user) async {
    if (_formKey.currentState!.validate()) {
      if (!await user.signInWithEmailAndPassword(
          _txtUsername.text, _txtPassword.text)) {
        print(LogIn.logInErrorMessage);

        String? error;
        if (LogIn.logInErrorMessage ==
            "We have blocked all requests from this device due to unusual activity. Try again later.")
          error =
              "ادخلت كلمة مرور غير صحيحة عدة مرات لهذا الإيميل من فضلك سجل الدخول في وقت لاحق.";
        else if (LogIn.logInErrorMessage ==
            "The password is invalid or the user does not have a password.")
          error = "كلمة مرور خاطئة";
        else if (LogIn.logInErrorMessage ==
            "There is no user record corresponding to this identifier. The user may have been deleted.")
          error = "هذا الإيميل غير مسجل لدينا";
        else if (LogIn.logInErrorMessage == "An internal error has occurred.")
          error = "انت غير متصل بالإنترنت";
        else {
          setState(() {
            error = LogIn.logInErrorMessage;
          });
        }

        _scaffoldKey.currentState!.showSnackBar(
            SnackBar(content: Text("فشل تسجيل الدخول لان " + "${error}")));
      }
    }
  }

  onPressGoogleButton() async {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => GoogleSignUpWidgets()));
  }
}
