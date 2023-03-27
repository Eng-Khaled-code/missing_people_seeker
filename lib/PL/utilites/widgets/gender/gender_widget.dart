import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'custom_box.dart';

class GenderRadioButton extends StatefulWidget {
  GenderRadioButtonState createState() => GenderRadioButtonState();
}

class GenderRadioButtonState extends State<GenderRadioButton> {
  static String? gender = "ذكر";

  @override
  Widget build(BuildContext context) {
    return CustomBox(items: [
      Row(
        children: [
          SizedBox(width: 10.0),
          Icon(CupertinoIcons.person_2),
          SizedBox(width: 10.0),
          Text(
            "الجنس",
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.035,
                color: Colors.black54),
          ),
        ],
      ),
      SizedBox(height: 10.0),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
              child: Row(children: [
            Radio(
              value: "ذكر",
              groupValue: gender,
              onChanged: (String? value) {
                setState(() {
                  gender = value;
                });
              },
            ),
            Text('ذكر')
          ])),
          Container(
              child: Row(children: [
            Radio(
              value: "أنثي",
              groupValue: gender,
              onChanged: (String? value) {
                setState(() {
                  gender = value;
                });
              },
            ),
            Text('أنثي')
          ]))
        ],
      ),
    ]);
  }
}
