
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/theme_change.dart';
import '../../provider/user_change.dart';
import '../utilites/widgets/custom_alert_dialog.dart';
import '../utilites/helper/helper.dart';
import '../utilites/strings.dart';

// ignore: must_be_immutable
class CustomDrawerTile extends StatelessWidget {
   CustomDrawerTile({Key? key,this.text,this.to,this.icon,this.userChange}) : super(key: key);
  final IconData? icon;
  final String? text;
  final Widget? to;
  late UserChange? userChange;


  @override
  Widget build(BuildContext context) {

     Color color= text=="تسجيل الخروج"?Colors.red:text=="سياسة الخصوصية"?Colors.greenAccent:Colors.blueAccent;
    return ListTile(
    title: Text(text!),
    leading: Icon(
    icon,
    color:color,
    ),
    onTap: ()=>text=="تسجيل الخروج"?onPressLogOut(context):text=="الوضع المظلم"?(){}
        :
    text=="الرئيسية"?goToHome()
        :
    Helper().goTo(to: to,context: context),
      trailing: text=="الوضع المظلم"?switchMode():null,
    );
  }

Consumer switchMode(){

  return Consumer<ThemeProvider>(
      builder: (context, theme, _)=>
          Switch(
              value:theme.themeMode==Strings.darkMode ,
              onChanged: (value){
                String newValue=value ?Strings.darkMode:Strings.lightMode;
                theme.setThemeMode(newValue);

              }));
}

  onPressLogOut(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => CustomAlertDialog(
          title: "تنبيه",
          onPress: ()async {
            Navigator.pop(context);
            await userChange!.signOut();},
          text: "هل تريد تسجيل الخروج بالفعل",
        ));
  }

  goToHome() {
    userChange!.navigateToHome();
  }


}
