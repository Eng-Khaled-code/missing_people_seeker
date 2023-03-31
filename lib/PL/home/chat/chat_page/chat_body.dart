import 'package:finalmps/models/chat_model.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalmps/provider/chat_change.dart';
import '../../../utilites/widgets/background_image.dart';
import 'input_message.dart';
import 'message.dart';

// ignore: must_be_immutable
class ChatScreenBody extends StatelessWidget {
  final String? userId;
  final String? adminId;
  final ChatChange? chatChange;

  ChatScreenBody({
    @required this.userId,
    @required this.adminId,
    @required this.chatChange,
   this.messageEditingController
  });

  final ScrollController listScrollController = ScrollController();
  final TextEditingController? messageEditingController;

  var listMessages;

  @override
  Widget build(BuildContext context) {
    
    
    chatChange!
        .updateToSeen(chatId: userId! + "&" + adminId!, adminId: adminId);

    return WillPopScope(
      onWillPop: () async {
        await closeChatPage();

        return true;
      },
      child: Container(
        child: Stack(
          children: <Widget>[
            BackgroundImage(),
            Column(
              children: <Widget>[
                listOfMessages(),
                chatChange!.inputStatus == ""
                    ? Container(
                        width: double.infinity,
                        height: 70,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : chatChange!.inputStatus == "0" ||
                            chatChange!.inputStatus == null
                        ? Container(
                            width: double.infinity,
                            height: 70,
                            child: Center(
                              child: Text(
                                "المحادثة مغلقة بواسطة المسئول",
                              ),
                            ),
                          )
                        : InputMessage(
                            chatChange: chatChange,
                            userId: userId,
                            adminId: adminId,
                            listScrollController: listScrollController,messageEditingController: messageEditingController),
              ],
            ),
          ],
        ),
      ),
    );
  }

  closeChatPage() async {
    if (!await chatChange!
        .closeChatPage(chatId: userId! + "&" + adminId!, userId: userId)) {
      await chatChange!.firstOpenOrClose(
          open: "no", chatId: userId! + "&" + adminId!, userId: userId);
    }
  }

  listOfMessages() {
    return Flexible(
        child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("chat")
                .doc(userId! + "&" + adminId!)
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
                ));
              else {
                listMessages = snapshot.data!.docs;

                return ListView.builder(
                  padding: EdgeInsets.all(10.0),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    ChatModel chatModel =
                        ChatModel.fromSnapshoot(snapshot.data!.docs[index]);
                    bool isLastLeft = isLastMessageLeft(index),
                        isLastRight = isLastMessageRight(index);
                    return Message(
                        isLastMessLeft: isLastLeft,
                        isLastMessRight: isLastRight,
                        userId: userId,
                        adminId: adminId,
                        index: index,
                        chatChange: chatChange,
                        messagesLength: snapshot.data!.docs.length,
                        message: chatModel);
                  },
                  reverse: true,
                  controller: listScrollController,
                );
              }
            }));
  }

  bool isLastMessageLeft(int index) {
    if ((index > 0 &&
            listMessages != null &&
            listMessages[index - 1]["idFrom"] != userId) ||
        index == 0)
      return true;
    else
      return false;
  }

  bool isLastMessageRight(int index) {
    if ((index > 0 &&
            listMessages != null &&
            listMessages[index - 1]["idFrom"] == userId) ||
        index == 0)
      return true;
    else
      return false;
  }
}
