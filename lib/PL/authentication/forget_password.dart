import 'package:finalmps/PL/utilites/widgets/custom_button.dart';
import 'package:finalmps/PL/utilites/text_style/text_styles.dart';
import 'package:finalmps/provider/user_change.dart';
import 'package:flutter/material.dart';
import '../utilites/widgets/custom_text_field.dart';

// ignore: must_be_immutable
class ForgetPassword extends StatelessWidget {
  ForgetPassword({key, this.userChange, this.formKey}) : super(key: key);
  String? txtEmail;
  final GlobalKey<FormState>? formKey;
  final UserChange? userChange;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.04),
        Text(
          "نسيت كلمة المرور؟",
          style: TextStyles.title.copyWith(color: Colors.white),
        ),
        Text(
          "من فضلك إدخل الإيميل \nونحن سوف نرسل لك رابط لإستعادة حسابك",
          textAlign: TextAlign.center,
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.1),
        CustomTextField(
          icon: Icons.mail,
          onSave: (value) => txtEmail = value,
          label: "الإيميل",
          textInputType: TextInputType.emailAddress,
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.07),
        CustomButton(
          text: "إستمرار",
          onPress: () => onPress(),
        )
      ],
    );
  }

  onPress() {
    formKey!.currentState!.save();
    if (formKey!.currentState!.validate()) {}
  }
}
