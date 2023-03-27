import 'package:finalmps/provider/missed_change.dart';
import 'package:flutter/material.dart';

import '../../../../utilites/helper/helper.dart';
import '../../../../utilites/widgets/custom_alert_dialog.dart';
import '../../../notifications/notify_details.dart';

class AcceptDialog extends StatelessWidget {
  const AcceptDialog({Key? key,this.missedChange,this.mayBeMissedOrderId,this.missedOrderId}) : super(key: key);
  final MissedChange? missedChange;
  final String? missedOrderId;
  final String? mayBeMissedOrderId;
  @override
  Widget build(BuildContext context) {
    return CustomAlertDialog(
        title: "تنبيه",
        text: "هل انت متاكد من ان هذا الشخص هو الذي تبحث عنه",
        onPress: () async {

          String docId =
          DateTime.now().millisecondsSinceEpoch.toString();

          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);

          await firestoreSuggestionTrueOperations(
              context: context,
              docId: docId);

          Helper().goTo(context: context, to:NotifyDetails(
            type: "found",
            orderId: docId,
          ));

        });
  }

  firestoreSuggestionTrueOperations(
      { BuildContext? context, docId}) async {
    await missedChange!.addFoundOrder(
        missedOrderId: missedOrderId,
        mayBeMissedOrderId: mayBeMissedOrderId,
        foundOrderId: docId);
  }
}
