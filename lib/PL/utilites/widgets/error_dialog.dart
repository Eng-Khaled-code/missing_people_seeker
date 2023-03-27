import 'package:flutter/material.dart';
import '../helper/helper.dart';
import '../strings.dart';
import '../text_style/text_styles.dart';
import 'cancel_button.dart';

class ErrorDialog extends StatelessWidget {
  final String? message;

  ErrorDialog({Key? key, @required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    bool isLargeDesignSize=Helper().getDesignSize(context)==Strings.largeDesign;
    return Dialog(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        height: 270,
        width: isLargeDesignSize?MediaQuery.of(context).size.width*.5:double.infinity,
        decoration: decoration(),
        child: Column(
          children: [
            topWidget(),
            SizedBox(height: 20),
            messageWidget(),
            SizedBox(height: 20),
           CancelButton()
          ],
        ),
      ),
    );
  }

  BoxDecoration decoration() {
    return BoxDecoration(
        color: Colors.lightBlue,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(15));
  }

  Container topWidget() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          )),
      width: double.infinity,
      child: Column(
        children: [
          SizedBox(height: 20),
          Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 80,
          ),
          SizedBox(height: 20),

        ],
      ),
    );
  }

  Text messageWidget() {
    return Text(
        message!,textAlign: TextAlign.center,
        style: TextStyles.errorDialog,);

    }

}
