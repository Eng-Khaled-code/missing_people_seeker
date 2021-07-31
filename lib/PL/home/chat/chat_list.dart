import 'dart:ui';
import 'package:finalmps/PL/home/chat/chat_pge.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:finalmps/provider/chat_change.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:finalmps/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalmps/models/chat_model.dart';

class ChatList extends StatefulWidget {
  final String? userId;

  ChatList({this.userId});

  @override
  State createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  Map<String, ChatModel> lastMessagesMap = Map();
  Map<String, int> unSeenMessagesCountMap = Map();

  lastMessages(ChatChange chat) {
    if (chat.adminsIds != null || chat.adminsIds != []) {
      chat.adminsIds.forEach((element) async {
        //no admins element i put it for where filter and it is not admin id
        //and i must not use it becase he crachs the program
        if (element != "no admins") {
          String _docId = widget.userId! + "&" + element;
          ChatModel _chatModel = await chat.loadLastMessage(docId: _docId);

          lastMessagesMap[element] = _chatModel;
//
          int _count = await chat.loadUnSeenMessagesCount(
              docId: _docId, userId: widget.userId);

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
    chat.loadMyAdminsIs(widget.userId);
    lastMessages(chat);
    return WillPopScope(
        onWillPop: () async {
          Navigator.pop(context);
          return true;
        },
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            appBar: AppBar(
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF1E88E5),
                      Color(0xFF0D47A1),
                    ],
                    begin: Alignment.bottomRight,
                    end: Alignment.topLeft,
                  ),
                ),
              ),
              title: Text(
                "تواصل مع المسئولين",
                style: TextStyle(fontSize: 13, color: Colors.white),
              ),
            ),
            body: Container(
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
                  listBody(chat, width, height),
                ],
              ),
            ),
          ),
        ));
  }

  Widget listBody(ChatChange chatChange, double width, double height) {
    return chatChange.adminsIds.length == 0
        ? _begainBuildingCard()
        : chatChange.adminsIds.isEmpty || chatChange.adminsIds == null
            ? Center(child: CircularProgressIndicator())
            : StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection(UserModel.USER_REF)
                    .where(UserModel.ID, whereIn: chatChange.adminsIds)
                    .snapshots(),
                builder: (context, snapshot) {
                  return !snapshot.hasData
                      ? Center(child: CircularProgressIndicator())
                      : snapshot.data!.size == 0
                          ? _begainBuildingCard()
                          : ListView.builder(
                              itemCount: snapshot.data!.size,
                              itemBuilder: (context, position) {
                                String adminName = snapshot.data!.docs[position]
                                        .get(UserModel.F_NAME) +
                                    " " +
                                    snapshot.data!.docs[position]
                                        .get(UserModel.L_NAME);

                                return Column(
                                  children: [
                                    ListTile(
                                        onTap: () async {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ChatPage(
                                                          userId: widget.userId,
                                                          adminAvatar: snapshot
                                                              .data!
                                                              .docs[position]
                                                              .get(UserModel
                                                                  .IMAGE_URL),
                                                          adminName: adminName,
                                                          adminId: snapshot
                                                              .data!
                                                              .docs[position]
                                                              .get(UserModel
                                                                  .ID))));

                                          if (!await chatChange.openChatPage(
                                              chatId: widget.userId! +
                                                  "&" +
                                                  snapshot.data!.docs[position]
                                                      .get(UserModel.ID),
                                              userId: widget.userId)) {
                                            await chatChange.firstOpenOrClose(
                                                open: "yes",
                                                chatId: widget.userId! +
                                                    "&" +
                                                    snapshot
                                                        .data!.docs[position]
                                                        .get(UserModel.ID),
                                                userId: widget.userId);
                                          }
                                        },
                                        leading: Stack(children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(18.0),
                                            child: snapshot.data!.docs[position]
                                                        .get(UserModel
                                                            .IMAGE_URL) ==
                                                    "no image"
                                                ? Icon(
                                                    Icons.account_circle,
                                                    color: Colors.grey,
                                                    size: width * .02,
                                                  )
                                                : CachedNetworkImage(
                                                    placeholder:
                                                        (context, url) {
                                                      return Container(
                                                        width: width * .09,
                                                        height: width * .09,
                                                        padding: EdgeInsets.all(
                                                            10.0),
                                                        child:
                                                            CircularProgressIndicator(
                                                                strokeWidth:
                                                                    1.0),
                                                      );
                                                    },
                                                    imageUrl: snapshot
                                                        .data!.docs[position]
                                                        .get(UserModel
                                                            .IMAGE_URL),
                                                    width: width * .1,
                                                    height: width * .1,
                                                    fit: BoxFit.cover,
                                                    errorWidget: (a, x, d) =>
                                                        Image.asset(
                                                      "assets/images/errorimage.png",
                                                      fit: BoxFit.cover,
                                                      width: width * .1,
                                                      height: width * .1,
                                                    ),
                                                  ),
                                          ),
                                          snapshot.data!.docs[position].get(
                                                      UserModel.CONNECTED) ==
                                                  "no"
                                              ? Container(
                                                  width: 0,
                                                  height: 0,
                                                )
                                              : Positioned(
                                                  left: 0,
                                                  bottom: 0,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    child: Container(
                                                      width: 10,
                                                      height: 10,
                                                      color: Colors.green,
                                                    ),
                                                  ))
                                        ]),
                                        title: Text(
                                            snapshot.data!.docs[position]
                                                    .get(UserModel.F_NAME) +
                                                " " +
                                                snapshot.data!.docs[position]
                                                    .get(UserModel.L_NAME),
                                            maxLines: 1),
                                        subtitle: lastMessageWidget(
                                            width: width * .1,
                                            adminId: snapshot.data!.docs[position]
                                                .get(UserModel.ID),
                                            adminFName: snapshot
                                                .data!.docs[position]
                                                .get(UserModel.F_NAME)),
                                        trailing: unSeenMessagesCountWidget(
                                            width: width,
                                            adminId: snapshot
                                                .data!.docs[position]
                                                .get(UserModel.ID))),
                                    Divider()
                                  ],
                                );
                              },
                              shrinkWrap: true);
                });
  }

  _begainBuildingCard() {
    return Container(
      alignment: Alignment.topCenter,
      margin: EdgeInsets.all(20),
      child: Column(
        children: [
          Icon(
            Icons.insert_emoticon,
            size: 40,
            color: Colors.blue,
          ),
          SizedBox(height: 10),
          Text(
            "حتي الان لا يوجد مسئولين عن طلباتك",
            style: TextStyle(color: Colors.blue),
          )
        ],
      ),
    );
  }

  Widget lastMessageWidget(
      {String? adminId, String? adminFName, required double width}) {
    String firstPart = lastMessagesMap[adminId] == null
        ? ""
        : lastMessagesMap[adminId]!.idFrom == widget.userId
            ? "أنت: "
            : adminFName! + ": ";

    return lastMessagesMap == null
        ? Align(
            alignment: Alignment.bottomRight,
            child: Container(
                width: width * .07,
                height: width * .07,
                child: CircularProgressIndicator(
                  strokeWidth: .7,
                )))
        : lastMessagesMap[adminId] == null
            ? Container()
            : Container(
                child: Text(
                  firstPart + lastMessagesMap[adminId]!.content,
                  maxLines: 2,
                  style: TextStyle(
                      fontSize: width * .03,
                      color: lastMessagesMap[adminId]!.seen == "no"
                          ? Colors.blue
                          : Colors.black54),
                ),
              );
  }

  Widget unSeenMessagesCountWidget({String? adminId, double? width}) {
    return unSeenMessagesCountMap[adminId] == null
        ? Container(
            width: width! * .07,
            height: width * .07,
            child: Center(
                child: CircularProgressIndicator(
              strokeWidth: .7,
            )),
          )
        : unSeenMessagesCountMap[adminId] == 0
            ? Container(
                height: 1,
                width: 1,
              )
            : Container(
                width: width! * .07,
                height: width * .07,
                child: CircleAvatar(
                  backgroundColor: Colors.lightBlueAccent,
                  child: Text(
                      unSeenMessagesCountMap[adminId]! > 99
                          ? "+99"
                          : unSeenMessagesCountMap[adminId].toString(),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: unSeenMessagesCountMap[adminId]! > 9
                              ? width * .034
                              : unSeenMessagesCountMap[adminId]! > 99
                                  ? width * .028
                                  : width * .04)),
                ),
              );
  }
}
