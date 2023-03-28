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
        child: InkWell(
          onTap: () => _selectDate(context),
          child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background ==
                          Color(0xff90caf9)
                      ? Colors.white
                      : Colors.black45,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 2,
                    )
                  ],
                  borderRadius: BorderRadius.circular(5)),
              padding: const EdgeInsets.only(right: 10.0),
              width: MediaQuery.of(context).size.width,
              height: 70.0,
              child: Row(
                children: [
                  Icon(Icons.date_range, color: Colors.black54),
                  SizedBox(width: 20.0),
                  Text(
                    selectedBirthDate == ""
                        ? 'تاريخ الميلاد'
                        : selectedBirthDate,
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
