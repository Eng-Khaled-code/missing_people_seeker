import 'package:finalmps/PL/utilites/widgets/custom_button.dart';
import 'package:finalmps/PL/utilites/widgets/error_dialog.dart';
import 'package:finalmps/PL/utilites/widgets/gender/gender_widget.dart';
import 'package:finalmps/PL/utilites/widgets/birthdate_widget.dart';
import 'package:finalmps/provider/user_change.dart';
import 'package:flutter/material.dart';
import '../../utilites/strings.dart';
import '../../utilites/widgets/custom_text_field.dart';

// ignore: must_be_immutable
class GoogleSignUpWidgets extends StatelessWidget {
  String? txtAddress;
  String? txtSSN;
  String? txtPhone;

  final GlobalKey<FormState>? formKey;
  final UserChange? userChange;

  GoogleSignUpWidgets({key, this.userChange, this.formKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GenderRadioButton(),
        SizedBox(height: 20.0),
        CustomBirthdate(),
        SizedBox(height: 20.0),
        CustomTextField(
          label: "الرقم القومي",
          icon: Icons.person_outline,
          onSave: (value) => txtSSN = value,
          textInputType: TextInputType.number,
        ),
        SizedBox(height: 20.0),
        CustomTextField(
          label: "العنوان",
          icon: Icons.location_on,
          onSave: (value) => txtAddress = value,
        ),
        SizedBox(height: 20.0),
        CustomTextField(
          label: "رقم الهاتف",
          icon: Icons.call,
          onSave: (value) => txtPhone = value,
          textInputType: TextInputType.phone,
        ),
        SizedBox(height: 30.0),
        CustomButton(
          color: [Color(0xFF1E88E5), Color(0xFF0D47A1)],
          text: Strings.addAccount,
          onPress: () async => onPressSignUp(context),
        ),
      ],
    );
  }

  onPressSignUp(BuildContext context) async {
    formKey!.currentState!.save();
    if (formKey!.currentState!.validate()) {
      if (CustomBirthdateState.selectedBirthDate == "") {
        showDialog(
            context: context,
            builder: (c) {
              return ErrorDialog(
                message: "من فضلك اختر تاريخ الميلاد",
              );
            });
      } else {
        await userChange!.googleSignUp(
            phone: txtPhone,
            gender: GenderRadioButtonState.gender,
            birthdate: CustomBirthdateState.selectedBirthDate,
            address: txtAddress,
            ssn: txtSSN);
      }
    }
  }
}
