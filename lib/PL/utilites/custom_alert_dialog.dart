import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  final String? title;
  final String? text;
  final Function()? onPress;

  CustomAlertDialog(
      {@required this.title, @required this.text, @required this.onPress});

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: Text(
            title!,
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("إلغاء")),
            TextButton(onPressed: onPress, child: Text("تأكيد"))
          ],
          content: Text(
            text!,
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
        ));
  }
}
