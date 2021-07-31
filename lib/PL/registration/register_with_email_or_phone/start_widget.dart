import 'package:finalmps/PL/utilites/custom_box.dart';
import 'package:finalmps/PL/utilites/custom_button.dart';
import 'package:finalmps/PL/utilites/custom_textfield.dart';
import 'package:finalmps/PL/utilites/gender_widget.dart';
import 'package:finalmps/PL/utilites/profile_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'medium_widget.dart';

class StartWidget extends StatefulWidget {
  @override
  _StartWidgetState createState() => _StartWidgetState();
}

class _StartWidgetState extends State<StartWidget> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _txtFname = TextEditingController();
  TextEditingController _txtLname = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    ProfileImageState.imageFile = null;
    GenderRadioButtonState.gender = "ذكر";
    _txtFname.dispose();
    _txtLname.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                                horizontal: 20.0, vertical: 30.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ProfileImage(),
                                SizedBox(height: 20.0),
                                CustomTextField(
                                    lable: "الاسم الاول",
                                    icon: Icons.person_outline,
                                    controller: _txtFname,
                                    color: Colors.white),
                                SizedBox(height: 20.0),
                                CustomTextField(
                                    lable: "اسم العائلة",
                                    icon: Icons.person_outline,
                                    controller: _txtLname,
                                    color: Colors.white),
                                SizedBox(height: 20.0),
                                GenderRadioButton(),
                                _buildingNextWidget(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )));
  }

  navigateToNext() {
    if (_formKey.currentState!.validate()) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MediumWidget(
                  imageFile: ProfileImageState.imageFile,
                  fName: _txtFname.text,
                  lName: _txtLname.text,
                  gender: GenderRadioButtonState.gender)));
    }
  }

  Widget _buildingNextWidget() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: CustomButton(
          color: [Color(0xFF1E88E5), Color(0xFF0D47A1)],
          text: "التالي",
          onPress: () => navigateToNext(),
          textColor: Colors.white),
    );
  }
}
