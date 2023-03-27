import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:finalmps/provider/chat_change.dart';
import 'package:finalmps/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalmps/models/chat_model.dart';
import '../../../utilites/widgets/background_image.dart';
import '../../../utilites/widgets/no_data_card.dart';
import 'chat_card.dart';

// ignore: must_be_immutable
class AdminsChatList extends StatelessWidget {
  final String? userId;
  AdminsChatList({this.userId});

  Map<String, ChatModel> lastMessagesMap = Map();
  Map<String, int> unSeenMessagesCountMap = Map();

  lastMessages(ChatChange chat) {
    if (chat.adminsIds != null || chat.adminsIds != []) {
      chat.adminsIds!.forEach((element) async {
        //no admins element i put it for where filter and it is not admin id
        //and i must not use it becase he crachs the program
        if (element != "no admins") {
          String _docId = userId! + "&" + element;
          ChatModel _chatModel = await chat.loadLastMessage(docId: _docId);

          lastMessagesMap[element] = _chatModel;
//
          int _count = await chat.loadUnSeenMessagesCount(
              docId: _docId, userId: userId);

          unSeenMessagesCountMap[element] = _count;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ChatChange chat = Provider.of<ChatChange>(context);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    chat.loadMyAdminsIds(userId);
    lastMessages(chat);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "تواصل مع المسئولين",
        ),
      ),
      body: Container(
        child: Stack(
          children: <Widget>[
            BackgroundImage(),
            listBody(chat, width, height),
          ],
        ),
      ),
    );
  }

  Widget listBody(ChatChange chatChange, double width, double height) {
    return
      chatChange.adminsIds == null
        ?
    Center(child: CircularProgressIndicator())
        :
      chatChange.adminsIds!.isEmpty
        ?
      NoDataCard(msg: "حتي الان لا يوجد مسئولين عن طلباتك")
        :
      StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection(UserModel.USER_REF)
                    .where(UserModel.ID, whereIn: chatChange.adminsIds)
                    .snapshots(),
                builder: (context, snapshot) {
                  return
                    !snapshot.hasData
                      ?
                    Center(child: CircularProgressIndicator())
                      :
                    snapshot.data!.size == 0
                        ?
                  NoDataCard(msg: "حتي الان لا يوجد مسئولين عن طلباتك")
                          :
                    ListView.builder(
                              itemCount: snapshot.data!.size,
                              itemBuilder: (context, position) {
                                UserModel adminModel=UserModel.fromSnapshoot(snapshot.data!.docs[position].data() as DocumentSnapshot<Map<String,dynamic>> );
                                return ChatCard(
                                  userId: userId,
                                  adminModel: adminModel,
                                  chatChange: chatChange,
                                  lastMessage: lastMessagesMap[adminModel.id],
                                  unSeenMessagesCount: unSeenMessagesCountMap[adminModel.id],
                                );
                              },
                              shrinkWrap: true);
                });
  }

}
