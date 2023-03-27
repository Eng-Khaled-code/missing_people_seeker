import 'dart:io';

import 'package:finalmps/PL/profile/profile_card_item.dart';
import 'package:finalmps/PL/profile/top_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:finalmps/provider/user_change.dart';
import '../utilites/text_style/text_styles.dart';
import '../utilites/widgets/background_image.dart';
class ProfilePage extends StatelessWidget {
  File? profileImage;

  @override
  Widget build(BuildContext context) {
    final UserChange userChange = Provider.of<UserChange>(context);

    return  Scaffold(
      appBar: appBar(),
      body:
      userChange.userData==null||userChange.isLoading
          ?
      Center(child: CircularProgressIndicator())
          :
      Stack(
        alignment: Alignment.center,
        children: <Widget>[
        BackgroundImage(),
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TopContainer(),
                ListView(
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    CardItem(title:"الاسم", data:"${userChange.userData!.fName} "+"${userChange.userData!.lName}",userChange: userChange),
                    CardItem(title:"رقم الهاتف", data:"${userChange.userData!.phoneNumber}" ,userChange: userChange),
                    CardItem(title:"الرقم القومي", data:"${userChange.userData!.ssn}" ,userChange: userChange),
                    CardItem(title:"الجنس", data:"${userChange.userData!.gender}" ,userChange: userChange),
                    CardItem(title:"العنوان", data:"${userChange.userData!.address}",userChange: userChange ),
                    CardItem(title:"تاريخ الميلاد", data:"${userChange.userData!.birthDate}",userChange: userChange ),

                  ],
                  shrinkWrap: true,
                )
              ],
            ),
          ),
        ]),
    );
  }

  AppBar appBar() {
    return AppBar(
      title: Text(
        "الصفحة الشخصية",
        style: TextStyles.title.copyWith(color: Colors.white),
      ),
    );
  }
}
