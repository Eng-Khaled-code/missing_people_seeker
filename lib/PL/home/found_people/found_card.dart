import 'package:flutter/material.dart';
import 'package:finalmps/models/user_model.dart';
import 'package:finalmps/provider/missed_change.dart';
import 'package:provider/provider.dart';
import '../../../models/found_model.dart';

class FoundCard extends StatefulWidget {

  final  FoundModel? foundModel;
  final bool? myFound;
  FoundCard(
      {@required this.foundModel,this.myFound});

  @override
  _FoundCardState createState() => _FoundCardState();
}

class _FoundCardState extends State<FoundCard> {

  UserModel? userData;

  loadUserData(MissedChange missedChange) async {

   String personId= widget.myFound! ? widget.foundModel!.secondUserId : widget.foundModel!.mainUserId;
    UserModel userData1 = await missedChange.getUserData(personId);
    setState(() {
      userData = userData1;
    });
  }

  @override
  Widget build(BuildContext context) {
    MissedChange missedChange = Provider.of<MissedChange>(context);
    loadUserData(missedChange);
    String missImage=widget.myFound!
        ?widget.foundModel!.imageUrl1
        : widget.foundModel!.imageUrl2;
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * .55,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 2,
              )
            ]),
        padding: EdgeInsets.all(5.0),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              height: double.infinity,
              width: double.infinity,
              child: Opacity(
                  opacity: 0.5,
                  child: Image.network(
                    missImage,
                    fit: BoxFit.fill,
                    errorBuilder: (context, object, stackTrace) => Image.asset(
                      "assets/images/errorimage.png",
                      fit: BoxFit.fill,
                    ),
                  )),
            ),
            Column(
              children: [
                SizedBox(height: 10.0),
                Table(
                  defaultColumnWidth: FixedColumnWidth(140),
                  children: [
                    TableRow(children: [
                      Text("الوسيط :"),
                      userData == null
                          ? Center(
                              child: Container(
                                width: 10.0,
                                height: 10.0,
                                child: CircularProgressIndicator(
                                  strokeWidth: .7,
                                ),
                              ),
                            )
                          : Text(userData!.fName + " " + userData!.lName)
                    ]),
                    TableRow(children: [
                      Text("رقم التليفون :"),
                      userData == null
                          ? Center(
                              child: Container(
                                width: 10.0,
                                height: 10.0,
                                child: CircularProgressIndicator(
                                  strokeWidth: .7,
                                ),
                              ),
                            )
                          : Text(userData!.phoneNumber)
                    ]),
                    TableRow(children: [
                      Text("اسم المفقود :"),
                      Text(widget.foundModel!.name)
                    ]),
                    TableRow(children: [Text("الجنس :"), Text(widget.foundModel!.gender)]),
                    TableRow(children: [Text("السن :"), Text(widget.foundModel!.age)]),
                    TableRow(children: [
                      Text("المكان الحالي :"),
                      Text(widget.foundModel!.place)
                    ]),
                    TableRow(children: [
                      Text("تاريخ العثور علي الشخص :"),
                      Text(DateTime.fromMicrosecondsSinceEpoch(
                              int.tryParse(widget.foundModel!.id)!)
                          .toString())
                    ]),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
