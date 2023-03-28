import 'package:finalmps/PL/home/orders/orders_page/order_card/status_row.dart';
import 'package:finalmps/models/missed_model.dart';
import 'package:flutter/material.dart';
import 'package:finalmps/provider/missed_change.dart';
import 'package:provider/provider.dart';
import 'accept_dialog.dart';
import 'bottom_sheet.dart';
import 'card_details.dart';
import 'date_widget.dart';

// ignore: must_be_immutable
class OrderCard extends StatelessWidget {
  OrderCard({key, this.missedModel, this.mainOrderId = "", this.type})
      : super(key: key);

  // mainOrderId for the missing order not my be missed that i pass it from the suggestion page  when the suggestion is true
  final String? mainOrderId;
  final MissedModel? missedModel;
  final String? type;

  TextStyle textStyle = TextStyle(color: Colors.white);

  @override
  Widget build(BuildContext context) {
    MissedChange missedChange = Provider.of<MissedChange>(context);

    return InkWell(
      onTap: () {
        if (type == "missed" || type == "mayBe")
          showCustomBottomSheet(context: context, missedChange: missedChange);
        else if (type == "suggest") {
          onPressSuggestionTrue(
            context: context,
            missedChange: missedChange,
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          width: double.infinity,
          decoration: cardDecoration(),
          padding: EdgeInsets.all(5.0),
          child: Column(
            children: [
              DateWidget(
                publishDate: missedModel!.publishDate,
                textStyle: textStyle,
              ),
              SizedBox(height: 10),
              image(),
              SizedBox(height: 10.0),
              type == "suggest"
                  ? Container()
                  : StatusRow(
                      status: missedModel!.status,
                      textStyle: textStyle,
                    ),
              CardDetailsTable(
                missedModel: missedModel,
                textStyle: textStyle,
              )
            ],
          ),
        ),
      ),
    );
  }

  onPressSuggestionTrue({
    BuildContext? context,
    MissedChange? missedChange,
  }) {
    showDialog(
        context: context!,
        builder: (context) => AcceptDialog(
              missedOrderId: mainOrderId,
              mayBeMissedOrderId: missedModel!.id,
              missedChange: missedChange,
            ));
  }

  showCustomBottomSheet({
    BuildContext? context,
    MissedChange? missedChange,
  }) {
    showModalBottomSheet(
        isDismissible: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        context: context!,
        builder: (context) {
          return CardBottomSheet(
              missedChange: missedChange, missedModel: missedModel, type: type);
        });
  }

  ClipRRect image() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: FadeInImage.assetNetwork(
        placeholder: 'assets/images/glow.gif',
        imageErrorBuilder: (e, r, t) => Image.asset(
          "assets/images/errorimage.png",
          fit: BoxFit.fill,
        ),
        image: missedModel!.imageUrl,
        width: double.infinity,
        height: 250,
        fit: BoxFit.fill,
      ),
    );
  }

  BoxDecoration cardDecoration() {
    return BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF1E88E5),
            Color(0xFF0D47A1),
          ],
        ),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 2,
          )
        ]);
  }
}
