import 'package:finalmps/provider/user_change.dart';
import 'package:flutter/material.dart';

import '../../utilites/strings.dart';
import '../../utilites/text_style/text_styles.dart';

class ForgetPasswordWidget extends StatelessWidget {
  const ForgetPasswordWidget({Key? key,this.userChange}) : super(key: key);
  final UserChange? userChange;
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      child:TextButton(
        child: Text(
          Strings.forgetPassword,
          style: TextStyles.title.copyWith(color: Colors.white),
        ),
        onPressed: ()=>userChange!.setAuthPage(AuthPage.FORGET_PASSWORD),
      ),
    );
  }
}
