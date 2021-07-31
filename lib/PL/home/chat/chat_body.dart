import 'dart:ui';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalmps/provider/chat_change.dart';

class ChatScreenBody extends StatefulWidget {
  final String? userId;
  final String? adminId;
  final ChatChange? chatChange;

  ChatScreenBody({
    @required this.userId,
    @required this.adminId,
    @required this.chatChange,
  });

  @override
  State createState() => ChatScreenBodyState();
}

class ChatScreenBodyState extends State<ChatScreenBody> {
  final ScrollController listScrollController = ScrollController();

  final TextEditingController messageEditingController =
  TextEditingController();
  final FocusNode focusNode = FocusNode();
  bool isLoading = false;
  var listMessages;


  closeChatPage() async {
    if (!await widget.chatChange!.closeChatPage(
        chatId: "${widget.userId}" + "&" + "${widget.adminId}", userId: widget.userId)) {
      await widget.chatChange!.firstOpenOrClose(
          open: "no",
          chatId: widget.userId! + "&" + widget.adminId!,
          userId: widget.userId);
    }
  }

  @override
  void dispose() {
    messageEditingController.dispose();

    closeChatPage();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery
        .of(context)
        .size
        .width;
    double height = MediaQuery
        .of(context)
        .size
        .height;
    widget.chatChange!.loadInputStatus(widget.userId!, widget.adminId!);
    widget.chatChange!.loadAdminOpensMyChatPage(
        widget.userId! + "&" + widget.adminId!, widget.adminId!);
    widget.chatChange!.loadConnectStatus(widget.adminId!);
    widget.chatChange!.updateToSeen(
        chatId: widget.userId! + "&" +widget.adminId!, adminId:widget.adminId);

    return Container(
      child: Stack(
        children: <Widget>[
          Container(
            height: height,
            width: width,
            child: Opacity(
                opacity: 0.5,
                child: Image.asset(
                  'assets/images/splach_bg.png',
                  fit: BoxFit.fill,
                )),
          ),
          Column(
            children: <Widget>[
              listOfMessages(width, height),
              widget.chatChange!.getInputStatus == ""
                  ? Container(
                width: double.infinity,
                height: 70,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
                  : widget.chatChange!.getInputStatus == "0"||widget.chatChange!.getInputStatus==null
                  ? Container(
                width: double.infinity,
                height: 70,
                child: Center(
                  child: Text(
                    "المحادثة مغلقة بواسطة المسئول",
                    style:
                    TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ),
              )
                  : inputController(),
            ],
          ),
        ],
      ),
    );
  }

  inputController() {
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
                maxLengthEnforced: true,
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
                onPressed: () {
                  onSendMessage(
                    message: messageEditingController.text,
                  );
                }),
          )
        ],
      ),
    );
  }

  listOfMessages(double width, double height) {
    return Flexible(
        child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("chat")
                .doc(widget.userId! + "&" + widget.adminId!)
                .collection("messages")
                .orderBy("timestanp", descending: true)
                .limit(20)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Center(child: CircularProgressIndicator());
              else if (snapshot.data!.docs.length == 0)
                return Center(
                    child: Text(
                        "لا توجد رسائل\n حيث يمكنك التواصل معنا عندما يتيح لك احد المسئولين",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black54, fontSize: width * 0.03)));
              else {
                listMessages = snapshot.data!.docs;

                return ListView.builder(
                  padding: EdgeInsets.all(10.0),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) =>
                      createMessageItem(
                          index, snapshot.data!.docs[index], width, height,snapshot.data!.docs.length),
                  reverse: true,
                  controller: listScrollController,
                );
              }
            }));
  }

  bool isLastMessageLeft(int index, String userId) {
    if ((index > 0 &&
        listMessages != null &&
        listMessages[index - 1]["idFrom"] != userId) ||
        index == 0)
      return true;
    else
      return false;
  }

  bool isLastMessageRight(int index, String userId) {
    if ((index > 0 &&
        listMessages != null &&
        listMessages[index - 1]["idFrom"] == userId) ||
        index == 0)
      return true;
    else
      return false;
  }

  Widget createMessageItem(int index, DocumentSnapshot document, double width,
      double height,int messagesLength) {
    //My Messages right side
    if (document["idFrom"] == widget.userId) {
      return Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
        Icon(document["seen"] == "yes" || widget.chatChange!.getConnectStatus == "yes"
            ? Icons.done_all
            : Icons.done,
            color: document["seen"] == "yes" ? Colors.lightBlueAccent : Colors
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
                  bottomRight: Radius.circular(isLastMessageRight(index,widget.adminId!)||index==messagesLength?18.0:0.0),

                )),
            margin: EdgeInsets.only(
                bottom: isLastMessageLeft(index, widget.userId!)
                    ? height * 0.05
                    : 10.0,
                right: 5.0,
                left: width * .3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  document["content"],
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                Text(
                  DateFormat("hh:mm").format(
                      DateTime.fromMillisecondsSinceEpoch(
                          int.parse(document["timestanp"]))),
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12.0,
                      fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
        )
      ]);
    }

    //Reciever messages Left side
    else {
      return Container(
        margin: EdgeInsets.only(
            bottom:
            isLastMessageRight(index, widget.userId!) ? height * 0.05 : 10.0,
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
                      bottomLeft: Radius.circular(isLastMessageLeft(index,widget.adminId!)||index==messagesLength?18.0:0.0),

                    )),
                margin: EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      document["content"],
                      style: TextStyle(color: Colors.black),
                    ),
                    Row(
                      children: [
                        Text(
                          DateFormat("hh:mm").format(
                              DateTime.fromMillisecondsSinceEpoch(
                                  int.parse(document["timestanp"]))),
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12.0,
                              fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      );
    }
  }

  onSendMessage({String? message}) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        if (message != "") {
          messageEditingController.clear();

          widget.chatChange!.sendMessage(
              userId: widget.userId,
              message: message,
              chatID: widget.userId! + "&" + widget.adminId!,
              seen:widget.chatChange!.getOpensMyChatPage=="yes"&&widget.chatChange!.getConnectStatus=="yes"?"yes":"no" );

          listScrollController.animateTo(0.0,
              duration: Duration(milliseconds: 300), curve: Curves.easeOut);
        } else {
          Fluttertoast.showToast(msg: "من فضلك إدخل رسالتك");
        }
      }
    } on SocketException catch (_) {
      Fluttertoast.showToast(
          msg: "تأكد من إتصالك بالإنترنت", toastLength: Toast.LENGTH_LONG);
    }
  }
}
