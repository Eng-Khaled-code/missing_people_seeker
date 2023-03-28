import 'package:finalmps/PL/authentication/register/profile_image_widget.dart';
import 'package:finalmps/provider/user_change.dart';
import 'package:flutter/material.dart';
import '../../utilites/widgets/birthdate_widget.dart';
import '../../utilites/widgets/custom_button.dart';
import '../../utilites/strings.dart';
import '../../utilites/text_style/text_styles.dart';
import '../../utilites/widgets/custom_text_field.dart';
import '../../utilites/widgets/error_dialog.dart';
import '../../utilites/widgets/gender/gender_widget.dart';

// ignore: must_be_immutable
class RegisterPage extends StatelessWidget {
  RegisterPage({key, this.formKey, this.userChange}) : super(key: key);

  final GlobalKey<FormState>? formKey;
  final UserChange? userChange;

  String? txtUsername;

  String? txtPassword;
  String? txtFirstName;
  String? txtLastName;
  String? txtSSN;
  String? txtAddress;
  String? txtPhone;

  String? screenSizeDesign;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        title(),
        SizedBox(height: 25),
        ProfileImageWidget(userChange: userChange),
        SizedBox(height: 25),
        buildFirstNameTextFieldWidget(),
        SizedBox(height: 10),
        buildLastTextFieldWidget(),
        SizedBox(height: 10),
        buildAddressTextFieldWidget(),
        SizedBox(height: 10.0),
        buildSSNTextFieldWidget(),
        SizedBox(height: 10.0),
        buildPhoneTextFieldWidget(),
        SizedBox(height: 10),
        buildEmailTextFieldWidget(),
        SizedBox(height: 10),
        buildPasswordFieldWidget(),
        SizedBox(height: 10),
        CustomBirthdate(),
        SizedBox(height: 10),
        GenderRadioButton(),
        SizedBox(
          height: 25,
        ),
        CustomButton(
          color: [Color(0xFF1E88E5), Color(0xFF0D47A1)],
          text: Strings.addAccount,
          onPress: () async => onPressSignUp(context),
        )
      ],
    );
  }

  onPressSignUp(BuildContext context) async {
    formKey!.currentState!.save();

    if (userChange!.profileImage == null ||
        CustomBirthdateState.selectedBirthDate == "") {
      showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(
              message: "يجب ان تختار صورة وتاريخ الميلاد",
            );
          });
    } else if (formKey!.currentState!.validate()) {
      await userChange!.signInAndUpWithEmail(
          type: "sign up",
          firstName: txtFirstName,
          lastName: txtLastName,
          gender: GenderRadioButtonState.gender,
          ssn: txtSSN,
          phoneNumber: txtPhone,
          birthDate: CustomBirthdateState.selectedBirthDate,
          address: txtAddress,
          email: txtUsername,
          password: txtPassword);
    }
  }

  CustomTextField buildFirstNameTextFieldWidget() {
    return CustomTextField(
      icon: Icons.person,
      onSave: (value) => txtFirstName = value,
      label: "الاسم الاول",
      initialValue: txtFirstName,
    );
  }

  buildLastTextFieldWidget() {
    return CustomTextField(
      icon: Icons.person,
      onSave: (value) => txtLastName = value,
      label: "اسم العائلة",
      initialValue: txtLastName,
    );
  }

  CustomTextField buildEmailTextFieldWidget() {
    return CustomTextField(
      icon: Icons.email,
      onSave: (value) => txtUsername = value,
      label: "الإيميل",
      initialValue: txtUsername,
      textInputType: TextInputType.emailAddress,
    );
  }

  CustomTextField buildPasswordFieldWidget() {
    return CustomTextField(
      label: "كلمة المرور",
      icon: Icons.lock,
      onSave: (value) => txtPassword = value,
      initialValue: txtPassword,
      textInputType: TextInputType.emailAddress,
    );
  }

  Text title() {
    return Text(Strings.emailSignUp, style: TextStyles.logInLogo);
  }

  buildSSNTextFieldWidget() {
    return CustomTextField(
      label: "الرقم القومي",
      icon: Icons.person_outline,
      onSave: (value) => txtSSN = value,
      textInputType: TextInputType.number,
    );
  }

  CustomTextField buildAddressTextFieldWidget() {
    return CustomTextField(
      label: "العنوان",
      icon: Icons.location_on,
      onSave: (value) => txtAddress = value,
    );
  }

  CustomTextField buildPhoneTextFieldWidget() {
    return CustomTextField(
      label: "رقم الهاتف",
      icon: Icons.call,
      onSave: (value) => txtPhone = value,
      textInputType: TextInputType.phone,
    );
  }
}
