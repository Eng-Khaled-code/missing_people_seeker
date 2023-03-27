import 'package:finalmps/models/chat_model.dart';
import 'package:finalmps/provider/chat_change.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Message extends StatelessWidget {
  const Message({Key? key,this.isLastMessLeft,this.isLastMessRight,this.chatChange,this.message,this.index,this.messagesLength,this.adminId,this.userId}) : super(key: key);
  final ChatChange? chatChange;
  final int? index;
  final ChatModel? message;
  final int? messagesLength;
  final String? userId;
  final String? adminId;
  final bool? isLastMessLeft;
  final bool? isLastMessRight;
  @override
  Widget build(BuildContext context) {
    double width =MediaQuery.of(context).size.width;
    double height =MediaQuery.of(context).size.height;

    return createMessageItem(width,height);
  }


  Widget createMessageItem(double width,double height) {

    //My Messages right side
    if (message!.idFrom == userId) {
      return myMessage(width,height);
    }

    //Reciever messages Left side
    else {
      return adminMessage(width,height);
    }
  }
  Row myMessage(double width, double height) {
    bool seen=message!.seen == "yes",
      connected=chatChange!.connectStatus == "yes";
    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
      Icon( seen||connected
          ? Icons.done_all
          : Icons.done,
        color: seen  ? Colors.lightBlueAccent : Colors
            .grey,size: 20,),
      Flexible(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
          decoration: BoxDecoration(
              color: Colors.lightBlueAccent,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18.0),
                topRight: Radius.circular(18.0),
                bottomLeft: Radius.circular(18.0),
                bottomRight: Radius.circular(
                    isLastMessRight!||index==messagesLength?18.0:0.0),

              )),
          margin: EdgeInsets.only(
              bottom: isLastMessLeft!
                  ? height * 0.05
                  : 10.0,
              right: 5.0,
              left: width * .3),
          child:messageAndDate()
        ),
      )
    ]);
  }

  Container adminMessage(double width, double height) {
    return Container(
      margin: EdgeInsets.only(
          bottom:
          isLastMessRight! ? height * 0.05 : 10.0,
          right: width * .3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          //displaying Message
          //Text Message
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(18.0),
                    topRight: Radius.circular(18.0),
                    bottomRight: Radius.circular(18.0),
                    bottomLeft: Radius.circular(isLastMessLeft!||index==messagesLength?18.0:0.0),

                  )),
              margin: EdgeInsets.only(left: 10.0),
              child: messageAndDate()
            ),
          )
        ],
      ),
    );
  }

  messageAndDate() {
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          message!.content,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        Text(
          DateFormat("hh:mm").format(
              DateTime.fromMillisecondsSinceEpoch(
                  int.parse(message!.timestanp))),
          style: TextStyle(
              color: Colors.grey,
              fontSize: 12.0,
              fontStyle: FontStyle.italic),
        ),
      ],
    );
  }

}
