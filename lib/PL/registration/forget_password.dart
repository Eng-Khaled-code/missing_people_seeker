import 'package:finalmps/PL/utilites/custom_button.dart';
import 'package:finalmps/PL/utilites/custom_textfield.dart';
import 'package:flutter/material.dart';

class ForgetPassWord extends StatefulWidget {
  @override
  _ForgetPassWordState createState() => _ForgetPassWordState();
}

class _ForgetPassWordState extends State<ForgetPassWord> {
  TextEditingController _txtUsername = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _txtUsername.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(
            "إعادة تعيين كلمة المرور",
            style: TextStyle(color: Colors.black, fontSize: 16.0),
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
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * .1),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.04),
                        Text(
                          "نسيت كلمة المرور؟",
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "من فضلك إدخل الإيميل \nونحن سوف نرسل لك رابط لإستعادة حسابك",
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.1),
                        CustomTextField(
                            icon: Icons.mail,
                            color: Colors.white,
                            controller: _txtUsername,
                            lable: "الإيميل"),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.07),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                  left: 20.0,
                  right: 20.0,
                  bottom: 20.0,
                  child: CustomButton(
                      color: [Color(0xFF1E88E5), Color(0xFF0D47A1)],
                      text: "إستمرار",
                      onPress: () => onPress(),
                      textColor: Colors.white))
            ],
          ),
        ),
      ),
    );
  }

  onPress() {
    if (_formKey.currentState!.validate()) {}
  }
}
