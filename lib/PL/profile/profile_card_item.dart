import 'package:flutter/material.dart';
import 'package:finalmps/PL/utilites/gender_widget.dart';
import 'package:finalmps/provider/user_change.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';

class CardItem extends StatefulWidget {
  final String title;
  final String data;
  static String? error;

  final String userId;

  CardItem(
      {Key? key, required this.title, required this.data, required this.userId})
      : super(key: key);

  @override
  _CardItemState createState() => _CardItemState();
}

class _CardItemState extends State<CardItem> {
  @override
  Widget build(BuildContext context) {
    UserChange user = Provider.of<UserChange>(context);

    final _formKey = GlobalKey<FormState>();
    TextEditingController? _controller;
    widget.title == "الجنس"
        ? GenderRadioButtonState.gender = "${widget.data}"
        : _controller = TextEditingController(text: "${widget.data}");

    return InkWell(
      onTap: () {
        if (widget.title == "تاريخ الميلاد") {
          _selectDate(context, user);
        } else {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                UserChange user1 = Provider.of<UserChange>(context);
                return Directionality(
                  textDirection: TextDirection.rtl,
                  child: AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    title: Text("تعديل ${widget.title}"),
                    content: Form(
                      key: _formKey,
                      child: widget.title == "الجنس"
                          ? GenderRadioButton()
                          : TextFormField(
                              controller: _controller,
                              validator: (value) {
                                bool isNumber;
                                //checking is number or not
                                try {
                                  int.parse(value!);
                                  isNumber = true;
                                } catch (ex) {
                                  isNumber = false;
                                }

                                if (value!.isEmpty)
                                  return "لا يمكن ان يكون ${widget.title} فارغ";
                                else if (widget.title == "الرقم القومي" &&
                                    value.length != 14)
                                  return "الرقم القومي غير صحيح";
                                else if (widget.title == "الرقم القومي" &&
                                    isNumber == false)
                                  return "الرقم القومي غير صحيح";
                                else if ((widget.title == "رقم الهاتف" &&
                                        isNumber == false) ||
                                    (widget.title == "رقم الهاتف" &&
                                        value.length != 11) ||
                                    (widget.title == "رقم الهاتف" &&
                                        !value.startsWith("01")))
                                  return "رقم الهاتف غير صحيح";
                              },
                              decoration: InputDecoration(
                                labelText: "${widget.title}",
                              ),
                            ),
                    ),
                    actions: <Widget>[
                      user1.isLoading
                          ? Container(
                              width: 17,
                              height: 17,
                              child: CircularProgressIndicator(
                                strokeWidth: 0.7,
                              ))
                          : TextButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  try {
                                    final result = await InternetAddress.lookup(
                                        'google.com');
                                    if (result.isNotEmpty &&
                                        result[0].rawAddress.isNotEmpty) {
                                      await updateToFirestore(
                                          user: user,
                                          text: widget.title == "الجنس"
                                              ? GenderRadioButtonState.gender
                                              : _controller!.text);
                                    }
                                  } on SocketException catch (_) {
                                    Fluttertoast.showToast(
                                        msg: "تأكد من إتصالك بالإنترنت",
                                        toastLength: Toast.LENGTH_LONG);
                                  }
                                }
                              },
                              child: Text("تعديل")),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("إلغاء")),
                    ],
                  ),
                );
              });
        }
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 21.0,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(children: [
                  Icon(
                    widget.title == "الاسم"
                        ? Icons.person
                        : widget.title == "رقم الهاتف"
                            ? Icons.phone
                            : widget.title == "الرقم القومي"
                                ? Icons.confirmation_num
                                : widget.title == "الجنس"
                                    ? Icons.group_add
                                    : widget.title == "العنوان"
                                        ? Icons.location_on
                                        : Icons.date_range,
                    size: MediaQuery.of(context).size.width * .08,
                    color: Colors.blue,
                  ),
                  SizedBox(width: 24.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        "${widget.title}",
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                      SizedBox(height: 4.0),
                      Text(
                        "${widget.data}",
                        maxLines: 1,
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 12.0,
                        ),
                      ),
                    ],
                  ),
                ]),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 30.0,
                  color: Colors.blue,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, UserChange user) async {
    String _selectedBirthDate = "";
    List dateList = widget.data.split("/");
    int year = int.parse(dateList[0]);
    int month = int.parse(dateList[1]);
    int day = int.parse(dateList[2]);

    DateTime initialDate = DateTime(year, month, day);

    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime(1920, 1),
        lastDate: DateTime(DateTime.now().year - 10, 1));

    if (picked != null) {
      _selectedBirthDate = picked.year.toString() +
          "/" +
          picked.month.toString() +
          "/" +
          picked.day.toString();
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          if (!await user.updateBirthdate(
              birthdate: _selectedBirthDate, userId: widget.userId))
            Fluttertoast.showToast(msg: "${CardItem.error}");
          else {
            Fluttertoast.showToast(msg: "تم تحديث ${widget.title} بنجاح ");
          }

          Fluttertoast.showToast(msg: "تم تحديث ${widget.title} بنجاح ");
        }
      } on SocketException catch (_) {
        Fluttertoast.showToast(msg: "تأكد من الاتصال بالإنترنت");
      }
    }
  }

  Future<void> updateToFirestore({String? text, UserChange? user}) async {
    GenderRadioButtonState.gender = "ذكر";
    if (widget.title == "الاسم") {
      List names = text!.trim().split(" ");
      String fName = names.first;
      String lName = names.length > 1
          ? text.substring(
              fName.length + 1,
              text.length,
            )
          : "";

      if (!await user!
          .updateUserName(fName: fName, lName: lName, userId: widget.userId))
        Fluttertoast.showToast(msg: "${CardItem.error}");
      else {
        Fluttertoast.showToast(msg: "تم تحديث ${widget.title} بنجاح ");
        Navigator.pop(context);
      }
    } else if (widget.title == "الرقم القومي") {
      if (!await user!.updateSSN(SSN: text, userId: widget.userId))
        Fluttertoast.showToast(msg: "${CardItem.error}");
      else {
        Fluttertoast.showToast(msg: "تم تحديث ${widget.title} بنجاح ");
        Navigator.pop(context);
      }
    } else if (widget.title == "رقم الهاتف") {
      if (!await user!
          .updatePhoneNumber(phoneNumber: text, userId: widget.userId))
        Fluttertoast.showToast(msg: "${CardItem.error}");
      else {
        Fluttertoast.showToast(msg: "تم تحديث ${widget.title} بنجاح ");
        Navigator.pop(context);
      }
    } else if (widget.title == "الجنس") {
      if (!await user!.updateGender(gender: text, userId: widget.userId))
        Fluttertoast.showToast(msg: "${CardItem.error}");
      else {
        Fluttertoast.showToast(msg: "تم تحديث ${widget.title} بنجاح ");
        Navigator.pop(context);
      }
    } else if (widget.title == "العنوان") {
      if (!await user!.updateAddress(address: text, userId: widget.userId))
        Fluttertoast.showToast(msg: "${CardItem.error}");
      else {
        Fluttertoast.showToast(msg: "تم تحديث ${widget.title} بنجاح ");
        Navigator.pop(context);
      }
    }
  }
}
