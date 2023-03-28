import 'package:finalmps/models/missed_model.dart';
import 'package:flutter/material.dart';

class CardDetailsTable extends StatelessWidget {
  const CardDetailsTable({Key? key, this.missedModel, this.textStyle})
      : super(key: key);
  final MissedModel? missedModel;
  final TextStyle? textStyle;
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Flexible(
        child: Container(
      padding: EdgeInsets.all(10),
      width: screenWidth * 0.8,
      child: Table(
        defaultColumnWidth: FixedColumnWidth(140),
        children: [
          detailsRow(title: "الاسم بالكامل :", data: missedModel!.name),
          detailsRow(title: "الجنس :", data: missedModel!.gender),
          detailsRow(title: "السن :", data: missedModel!.age),
          detailsRow(title: "الحالة الصحية :", data: missedModel!.helthyStatus),
          detailsRow(title: "لون البشرة :", data: missedModel!.faceColor),
          detailsRow(title: "لون الشعر :", data: missedModel!.hairColor),
          detailsRow(title: "لون العين :", data: missedModel!.eyeColor),
          detailsRow(title: "اخر مكان وجد به :", data: missedModel!.lastPlace),
        ],
      ),
    ));
  }

  TableRow detailsRow({String? title, String? data}) {
    return TableRow(children: [
      Text(title!, style: textStyle),
      Text(data!, style: textStyle)
    ]);
  }
}
