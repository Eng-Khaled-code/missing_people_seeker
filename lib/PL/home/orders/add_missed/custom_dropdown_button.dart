import 'package:flutter/material.dart';
import 'package:finalmps/PL/home/orders/add_missed/add_missed_2.dart';

class CustomDropdownButton extends StatefulWidget {
  final List<String>? items;
  final String? lable;
  CustomDropdownButton({this.items, this.lable});

  _CustomDropdownButtonState createState() => _CustomDropdownButtonState();
}

class _CustomDropdownButtonState extends State<CustomDropdownButton> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.lable!,
          ),
          DropdownButton<String>(
            items: widget.items!
                .map((item) => DropdownMenuItem(
                      child: Text(item),
                      value: item,
                    ))
                .toList(),
            onChanged: (String? value) {
              setState(() {
                widget.lable == "لون البشرة"
                    ? AddMissed2.faceColor = value
                    : widget.lable == "لون العين"
                        ? AddMissed2.eyeColor = value
                        : AddMissed2.hairColor = value;
              });
            },
            value: widget.lable == "لون البشرة"
                ? AddMissed2.faceColor
                : widget.lable == "لون العين"
                    ? AddMissed2.eyeColor
                    : AddMissed2.hairColor,
            isExpanded: true,
          ),
        ],
      ),
    );
  }
}
