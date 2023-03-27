import 'package:finalmps/PL/utilites/helper/helper.dart';
import 'package:finalmps/models/missed_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../../../../provider/missed_change.dart';
import '../../../../../provider/notify_change.dart';
import '../../../../../provider/user_change.dart';
import '../../../../utilites/widgets/custom_button.dart';
import '../../add_missed/add_missed_1.dart';
import 'order_suggestions.dart';
class CardBottomSheet extends StatelessWidget {
  const CardBottomSheet({Key? key,this.missedModel,this.missedChange,this.type}) : super(key: key);

  final MissedChange? missedChange;
  final MissedModel? missedModel;
  final String? type;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text("ما الذي تريد فعله بهذا الطلب؟"),
        ),
        missedModel!.status == "1" &&type == "missed"
            ? Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 20.0, vertical: 5),
          child: CustomButton(
              text: "عرض",
              onPress: () => navigateToSuggestionPage(context),),
        )
            : Container(),
        Padding(
          padding:
          const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
          child: CustomButton(
              text: "تعديل",
              onPress: () => navigateToUpdatePage(context),),
        ),
        Padding(
          padding:
          const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
          child: CustomButton(
              text: "حذف",
              onPress: () => deleteOrder(context: context)),
        ),
        Padding(
          padding:
          const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
          child: CustomButton(
              text: "إغلاق",
              onPress: () => Navigator.pop(context),
             ),
        ),
      ],
    );
  }


navigateToUpdatePage(BuildContext context) {
  Helper().goTo(context: context, to: AddMissed1(
              orderId: missedModel!.id,
              type: type == "mayBe" ? "شك" : "فقد",
              addOrUpdate: "تعديل",
              imagePath: missedModel!.imageUrl,
              helthyStatus: missedModel!.helthyStatus,
              fullName: missedModel!.name,
              age: missedModel!.age,
              gender: missedModel!.gender,
              lastPlace: missedModel!.lastPlace,
              faceColor: missedModel!.faceColor,
              hairColor: missedModel!.hairColor,
              eyeColor:missedModel!. eyeColor));
}

navigateToSuggestionPage(BuildContext context) {
  Helper().goTo(context: context, to:  OrderSuggestions(missedModel: missedModel,missedChange: missedChange,));
}

deleteOrder({BuildContext? context}) async {
      UserChange userChange = Provider.of<UserChange>(context!, listen: false);
      NotifyChange notifyChange = Provider.of<NotifyChange>(context,listen: false);

      Navigator.pop(context);

      if (await missedChange!.deleteMissingOrder(id: missedModel!.id, type: type, imageURL: missedModel!.imageUrl) &&
          await notifyChange.deleteNotifyByOrder(
              userId: userChange.userData!.id, orderId: missedModel!.id)) {
        Fluttertoast.showToast(msg: "تم حذف الطلب بالفعل", toastLength: Toast.LENGTH_LONG);
      }

}

}
