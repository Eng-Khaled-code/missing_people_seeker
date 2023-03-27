import 'package:finalmps/provider/user_change.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class CustomDrawerHeader extends StatelessWidget {
  const CustomDrawerHeader({Key? key,this.userChange}) : super(key: key);
  final UserChange? userChange;

  @override
  Widget build(BuildContext context) {
    return
      userChange!.userData==null
        ?
    Center(child: CircularProgressIndicator(),)
        :
    UserAccountsDrawerHeader(
      currentAccountPicture: GestureDetector(
        child: CircleAvatar(
          backgroundImage: NetworkImage(userChange!.userData!.imageUrl),
          backgroundColor: Colors.grey,
        ),
      ),
      accountEmail: Text( userChange!.userData!.email,
        style: TextStyle(color: Colors.white),
      ),
      accountName: Text( userChange!.userData!.fName+" "+userChange!.userData!.lName,
          style: TextStyle(color: Colors.white)),
      decoration: BoxDecoration(color: Colors.blue),
    );
  }
}
