import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomBirthdate extends StatefulWidget {
  CustomBirthdateState createState() => CustomBirthdateState();
}

class CustomBirthdateState extends State<CustomBirthdate> {
  static String selectedBirthDate = "";
  DateTime initialDate = DateTime(1999, 7, 11);
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 15.0),
        child: GestureDetector(
          onTap: () => _selectDate(context),
          child: Container(
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 2,
                )
              ], color: Colors.white, borderRadius: BorderRadius.circular(5)),
              padding: const EdgeInsets.only(right: 10.0),
              width: MediaQuery.of(context).size.width,
              height: 67.0,
              child: Row(
                children: [
                  Icon(Icons.date_range, color: Colors.black54),
                  SizedBox(width: 20.0),
                  Text(
                    selectedBirthDate == ""
                        ? 'تاريخ الميلاد'
                        : selectedBirthDate,
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.035,
                        color: Colors.black54),
                  ),
                ],
              )),
        ));
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime(1920, 1),
        lastDate: DateTime.now());

    if (picked != null)
      setState(() {
        initialDate = picked;
        selectedBirthDate = picked.year.toString() +
            "/" +
            picked.month.toString() +
            "/" +
            picked.day.toString();
      });
  }
}
