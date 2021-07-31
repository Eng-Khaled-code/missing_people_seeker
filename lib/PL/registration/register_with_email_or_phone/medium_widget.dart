import 'dart:io';
import 'package:finalmps/PL/utilites/birthdate_widget.dart';
import 'package:finalmps/PL/registration/register_with_email_or_phone/last_widget.dart';
import 'package:finalmps/PL/utilites/custom_button.dart';
import 'package:finalmps/PL/utilites/custom_textfield.dart';
import 'package:finalmps/PL/utilites/error_dialog.dart';
import 'package:finalmps/provider/user_change.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class MediumWidget extends StatefulWidget {
  final XFile? imageFile;
  final String? fName;
  final String? lName;
  final String? gender;

  static String? error;

  MediumWidget({this.imageFile, this.fName, this.lName, this.gender});

  @override
  _MediumWidgetState createState() => _MediumWidgetState();
}

class _MediumWidgetState extends State<MediumWidget> {
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

    _txtPhone.dispose();
    CustomBirthdateState.selectedBirthDate = "";
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
                            CustomTextField(
                                lable: "الرقم القومي",
                                icon: Icons.person_outline,
                                controller: _txtSSN,
                                color: Colors.white),
                            SizedBox(height: 20.0),
                            CustomTextField(
                                lable: "رقم الهاتف",
                                icon: Icons.call,
                                controller: _txtPhone,
                                color: Colors.white),
                            SizedBox(height: 20.0),
                            CustomTextField(
                                lable: "العنوان",
                                icon: Icons.location_on,
                                controller: _txtaddress,
                                color: Colors.white),
                            SizedBox(height: 20.0),
                            CustomBirthdate(),
                            _buildingNextWidget(user)
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ]))));
  }

  navigateToNext(UserChange user) async {
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
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => LastWidget(
                    imageFile: widget.imageFile,
                    fName: widget.fName,
                    lName: widget.lName,
                    gender: widget.gender,
                    address: _txtaddress.text,
                    birthDate: CustomBirthdateState.selectedBirthDate,
                    PhoneNumber: _txtPhone.text,
                    SSN: _txtSSN.text)));
      }
    }
  }

  Widget _buildingNextWidget(UserChange user) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: CustomButton(
          color: [Color(0xFF1E88E5), Color(0xFF0D47A1)],
          text: "التالي",
          onPress: () => navigateToNext(user),
          textColor: Colors.white),
    );
  }
}
