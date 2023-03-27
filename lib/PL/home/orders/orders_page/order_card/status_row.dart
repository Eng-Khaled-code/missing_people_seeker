import 'package:flutter/material.dart';

class StatusRow extends StatelessWidget {
   StatusRow({Key? key,this.status,this.textStyle}) : super(key: key);
  final String? status;
   final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return  //0 for waitting
      //1 for success
      //2 for faild
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("الحالة", style: textStyle),
            Text(
                status == "0"
                    ? "أنتظر"
                    : status == "1"
                    ? "مقبول"
                    : "مرفوض",
                style: textStyle),
            Icon(
              status == "0"
                  ? Icons.more_horiz
                  : status == "1"
                  ? Icons.check
                  : Icons.clear,
              color: status == "0"
                  ? Colors.white
                  : status == "1"
                  ? Colors.green
                  : Colors.red,
              size: 30,
            )
          ],
        ),
      );
  }
}
