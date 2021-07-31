import 'package:finalmps/PL/profile/profile_card_item.dart';
import 'package:finalmps/PL/profile/top_container.dart';
import 'package:finalmps/PL/utilites/drawer.dart';
import 'package:flutter/material.dart';
import 'package:finalmps/PL/utilites/loding_screen.dart';
import 'package:provider/provider.dart';
import 'package:finalmps/PL/home/home_page.dart';
import 'package:finalmps/provider/user_change.dart';
class ProfilePage extends StatefulWidget {

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {



  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserChange>(context);

    return WillPopScope(
      onWillPop: (){
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => HomePage()));

        return Future.delayed(Duration(seconds: 0));
      },
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF1E88E5),Color(0xFF0D47A1),],
                  begin: Alignment.bottomRight,
                  end: Alignment.topLeft,
                ),
              ),
            ),
            title: Text(
              "الصفحة الشخصية",
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
            actions: [
              IconButton(
                  icon: Icon(Icons.arrow_forward_ios),
                  onPressed: () => Navigator.pop(context))
            ],
          ),
          body:user.userInformation==null?LoadingScreen() :Stack(
            alignment: Alignment.center,
            children: <Widget>[
            Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Opacity(
                opacity: 0.5,
                child: Image.asset(
                  'assets/images/splach_bg.png',
                  fit: BoxFit.fill,
                )),
          ),SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    TopContainer(userModel: user.userInformation),
                    ListView(
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        CardItem(title:"الاسم", data:"${user.userInformation.fName} "+"${user.userInformation.lName}",userId: user.userInformation.id),
                        CardItem(title:"رقم الهاتف", data:"${user.userInformation.phoneNumber}",userId: user.userInformation.id),
                        CardItem(title:"الرقم القومي", data:"${user.userInformation.ssn}",userId: user.userInformation.id),
                        CardItem(title:"الجنس", data:"${user.userInformation.gender}",userId: user.userInformation.id),
                        CardItem(title:"العنوان", data:"${user.userInformation.address}",userId: user.userInformation.id),
                        CardItem(title:"تاريخ الميلاد", data:"${user.userInformation.birthDate}",userId: user.userInformation.id),


                      ],
                      shrinkWrap: true,
                    )
                  ],
                ),
              ),
            ]),
          drawer: CustomDrawer(),
        ),
      ),
    );
  }
}
