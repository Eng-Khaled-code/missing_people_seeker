import 'package:finalmps/provider/chat_change.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class InputMessage extends StatelessWidget {
   InputMessage({Key? key ,this.chatChange,this.userId,this.adminId,this.listScrollController}) : super(key: key);

  final TextEditingController messageEditingController =
  TextEditingController();
  final FocusNode focusNode = FocusNode();
  final ChatChange? chatChange;
  final String? userId;
  final String? adminId;
   final ScrollController? listScrollController;
  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: 70.0,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
                top: BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                ))),
        child: Row(
          children: <Widget>[
            //text Felid message
            Flexible(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 15.0),
                child: TextField(
                  focusNode: focusNode,
                  controller: messageEditingController,
                  enableSuggestions: true,
                  decoration: InputDecoration.collapsed(
                      hintText: "اكتب هنا ...",
                      hintStyle: TextStyle(color: Colors.grey)),
                  style: TextStyle(color: Colors.black, fontSize: 15.0),
                ),
              ),
            ),

            //sent button

            Container(
              margin: EdgeInsets.symmetric(horizontal: 8.0),
              child: IconButton(
                  icon: Icon(Icons.send),
                  color: Colors.lightBlueAccent,
                  onPressed: ()async=> onSendMessage()),
            )
          ],
        ),
      );
    }


onSendMessage() async {
      if (messageEditingController.text != "") {
        messageEditingController.clear();

        chatChange!.sendMessage(
            userId: userId,
            message: messageEditingController.text,
            chatID: userId! + "&" + adminId!,
            seen:chatChange!.opensChatPage=="yes"&&chatChange!.connectStatus=="yes"?"yes":"no" );

        listScrollController!.animateTo(0.0,
            duration: Duration(milliseconds: 300), curve: Curves.easeOut);
      } else {
        Fluttertoast.showToast(msg: "من فضلك إدخل رسالتك");
      }

}

}
