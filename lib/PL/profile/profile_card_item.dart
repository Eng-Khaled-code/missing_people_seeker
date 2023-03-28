import 'package:flutter/material.dart';
import 'package:finalmps/PL/utilites/widgets/gender/gender_widget.dart';
import 'package:finalmps/provider/user_change.dart';
import '../../models/user_model.dart';
import '../utilites/text_style/text_styles.dart';
import '../utilites/widgets/cancel_button.dart';
import '../utilites/widgets/custom_text_field.dart';

// ignore: must_be_immutable
class CardItem extends StatelessWidget {
  final String title;
  final UserChange? userChange;
  String? data;

  CardItem({Key? key, required this.title, this.data, this.userChange})
      : super(key: key);

  IconData? cardIcon;
  @override
  Widget build(BuildContext context) {
    cardIcon = title == "الاسم"
        ? Icons.person
        : title == "رقم الهاتف"
            ? Icons.phone
            : title == "الرقم القومي"
                ? Icons.confirmation_num
                : title == "الجنس"
                    ? Icons.group_add
                    : title == "العنوان"
                        ? Icons.location_on
                        : Icons.date_range;

    if (title == "الجنس") GenderRadioButtonState.gender = data;

    return InkWell(
      onTap: () => onPress(context),
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 1),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 21.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(children: [
                Icon(cardIcon, color: Colors.blue),
                SizedBox(width: 24.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      "$title",
                      style: TextStyles.title.copyWith(fontSize: 18),
                    ),
                    SizedBox(height: 4.0),
                    Text(data!, maxLines: 1),
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
    );
  }

  CustomTextField buildTextFieldWidget() {
    return CustomTextField(
      icon: cardIcon,
      label: title,
      onSave: (value) => data = value,
      initialValue: data,
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    String _selectedBirthDate = "";
    List dateList = data!.split("/");
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

      await userChange!.updateUserField(
          field: UserModel.BIRTH_DATE, value: _selectedBirthDate);
    }
  }

  Future<void> updateToFirestore() async {
    if (title == "الاسم") {
      List names = data!.trim().split(" ");
      String fName = names.first;
      String lName = names.length > 1
          ? data!.substring(
              fName.length + 1,
              data!.length,
            )
          : "";

      await userChange!.updateUserName(fName: fName, lName: lName);
    }
    {
      if (title == "الجنس") {
        data = GenderRadioButtonState.gender;
      }

      String field = title == "الرقم القومي"
          ? UserModel.SSN
          : title == "رقم الهاتف"
              ? UserModel.PHONE_NUMBER
              : title == "الجنس"
                  ? UserModel.GENDER
                  : title == "العنوان"
                      ? UserModel.ADDRESS
                      : "";

      await userChange!.updateUserField(field: field, value: data);
    }
  }

  onPress(BuildContext context) {
    if (title == "تاريخ الميلاد") {
      _selectDate(context);
    } else {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            final _formKey = GlobalKey<FormState>();

            return Directionality(
              textDirection: TextDirection.rtl,
              child: AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                title: Text("تعديل $title"),
                content: Form(
                    key: _formKey,
                    child: title == "الجنس"
                        ? GenderRadioButton()
                        : buildTextFieldWidget()),
                actions: <Widget>[
                  TextButton(
                      onPressed: () async {
                        _formKey.currentState!.save();
                        if (_formKey.currentState!.validate()) {
                          Navigator.pop(context);
                          await updateToFirestore();
                        }
                      },
                      child: Text("تعديل")),
                  CancelButton(),
                ],
              ),
            );
          });
    }
  }
}
