
import 'package:finalmps/provider/user_change.dart';
import 'package:flutter/material.dart';
import '../../utilites/widgets/custom_button.dart';
import '../../utilites/helper/helper.dart';
import '../../utilites/strings.dart';
import '../../utilites/text_style/text_styles.dart';
import '../../utilites/widgets/app_icon.dart';
import '../../utilites/widgets/custom_text_field.dart';
import 'forget_password_widget.dart';

class LogIn extends StatelessWidget {
   LogIn({Key? key,this.formKey,this.userChange}) : super(key: key);
  String? txtUsername ;
  String? txtPassword ;
   String? screenSizeDesign;
  final GlobalKey<FormState>? formKey;
  final UserChange?  userChange;

   @override
  Widget build(BuildContext context) {
    screenSizeDesign=Helper().getDesignSize(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        icon(),
        title(),
        SizedBox(height:25),
        buildEmailTextFieldWidget(),
        SizedBox(height:10),
        buildPasswordFieldWidget(),
        SizedBox(height:10),
        ForgetPasswordWidget(userChange: userChange),
        SizedBox(height:15),
        CustomButton(
            text: Strings.logIn,
            onPress: () async=>await onPressLogInButton()),
        SizedBox(height: 10),
        lineSeparator(),
        SizedBox(height:10),
        CustomButton(
            text: Strings.googleSignUp,
            onPress: () {}),
        SizedBox(height:10),
        dontHaveAccountButton()
      ],
    );
  }

   onPressLogInButton() async {
     formKey!.currentState!.save();
     if (formKey!.currentState!.validate())
       await userChange!.signInAndUpWithEmail(email: txtUsername,password: txtPassword);

   }

   Widget title(){

     return Text(Strings.logIn, style: TextStyles.logInLogo);
   }

   AppIcon icon(){
     Size iconSize=screenSizeDesign==Strings.largeDesign
         ?Size(250,250)
         :Size(100,100);
     return AppIcon(size: iconSize);
   }

   CustomTextField buildEmailTextFieldWidget() {
    return  CustomTextField(
      icon: Icons.person,
      onSave: (value)=>txtUsername=value,
      label: "الإيميل",
      initialValue: txtUsername,
      textInputType: TextInputType.emailAddress,
    );
  }

   CustomTextField buildPasswordFieldWidget(){
    return CustomTextField(
      label: "كلمةالمرور",
      icon: Icons.lock,
      onSave: (value)=>txtPassword=value,
      initialValue: txtPassword,
      textInputType: TextInputType.emailAddress,
    );
  }

   InkWell dontHaveAccountButton() {
     return InkWell(
         onTap: ()=>userChange!.setAuthPage(AuthPage.EMAIL_SIGN_UP),
    child:Text(Strings.dontHaveAccount,style: TextStyles.title,));
  }

   Container lineSeparator(){
     return Container(
       alignment: Alignment.center,
       child: Text(
         " Or sign in with ",
         style: TextStyles.title,
       ),
     );
  }


}
