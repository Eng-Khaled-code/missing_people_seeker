import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateWidget extends StatelessWidget {
  const DateWidget({Key? key,this.publishDate,this.textStyle}) : super(key: key);
  final String? publishDate;
  final TextStyle? textStyle;
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Text(
        "  تاريخ النشر: " +
            DateFormat("a").format(
                DateTime.fromMicrosecondsSinceEpoch(
                    int.parse(publishDate!))),
        style: textStyle,
      ),
      Text(
          "  " +
              DateTime.fromMicrosecondsSinceEpoch(
                  int.parse(publishDate!))
                  .hour
                  .toString() +
              ":" +
              DateTime.fromMicrosecondsSinceEpoch(
                  int.parse(publishDate!))
                  .minute
                  .toString() +
              "      " +
              DateTime.fromMicrosecondsSinceEpoch(
                  int.parse(publishDate!))
                  .day
                  .toString() +
              "/" +
              DateTime.fromMicrosecondsSinceEpoch(
                  int.parse(publishDate!))
                  .month
                  .toString() +
              "/" +
              DateTime.fromMicrosecondsSinceEpoch(
                  int.parse(publishDate!))
                  .year
                  .toString(),
          style: textStyle)
    ]);
  }
}
