import 'package:finalmps/PL/utilites/helper/helper.dart';
import 'package:finalmps/models/chat_model.dart';
import 'package:finalmps/models/user_model.dart';
import 'package:finalmps/provider/chat_change.dart';
import 'package:flutter/material.dart';

import '../chat_page/chat_pge.dart';

class ChatCard extends StatelessWidget {
  const ChatCard(
      {Key? key,
      this.userId,
      this.adminModel,
      this.chatChange,
      this.lastMessage,
      this.unSeenMessagesCount})
      : super(key: key);

  final String? userId;
  final UserModel? adminModel;
  final ChatChange? chatChange;
  final ChatModel? lastMessage;
  final int? unSeenMessagesCount;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        ListTile(
            onTap: () => onTap(context),
            leading: image(),
            title:
                Text(adminModel!.fName + " " + adminModel!.lName, maxLines: 1),
            subtitle: lastMessageWidget(width),
            trailing: unSeenMessagesCountWidget(width: width)),
        Divider()
      ],
    );
  }

  Widget lastMessageWidget(double width) {
    String firstPart = lastMessage == null
        ? ""
        : lastMessage!.idFrom == userId
            ? "أنت: "
            : adminModel!.fName + ": ";

    return lastMessage == null
        ? Align(
            alignment: Alignment.bottomRight,
            child: Container(
                width: width * .02,
                height: width * .02,
                child: CircularProgressIndicator(
                  strokeWidth: .7,
                )))
        : Container(
            child: Text(
              firstPart + lastMessage!.content,
              maxLines: 2,
              style: TextStyle(
                  fontSize: width * .03,
                  color: lastMessage!.seen == "no"
                      ? Colors.green
                      : Colors.black54),
            ),
          );
  }

  Widget unSeenMessagesCountWidget({double? width}) {
    return CircleAvatar(
      backgroundColor: (unSeenMessagesCount !=null&&unSeenMessagesCount!=0)?Colors.green:Colors.transparent,
              child: unSeenMessagesCount == null
                  ?
              CircularProgressIndicator(strokeWidth: .7)
                  :
              unSeenMessagesCount == 0
                  ?
              Container(color: Colors.transparent,):Text(
                  unSeenMessagesCount! > 99
                      ? "+99"
                      : unSeenMessagesCount.toString(),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: unSeenMessagesCount! > 9
                          ? width! * .034
                          : unSeenMessagesCount! > 99
                              ? width! * .028
                              : width! * .04)),
            );
  }

  onTap(BuildContext context) async {
    Helper().goTo(
        context: context,
        to: ChatPage(
            userId: userId,
            adminAvatar: adminModel!.imageUrl,
            adminName: adminModel!.fName + " " + adminModel!.lName,
            adminId: adminModel!.id,
            chatChange: chatChange));

    String chatId = userId! + "&" + adminModel!.id;

    if (!await chatChange!.openChatPage(chatId: chatId, userId: userId)) {
      await chatChange!
          .firstOpenOrClose(open: "yes", chatId: chatId, userId: userId);
    }
chatChange!.loadInputStatus(userId!, adminId!);
 chatChange!.loadAdminOpensMyChatPage(chatId , adminId!);
    chatChange!.loadConnectStatus(adminId!);

  }

  Stack image() {
    return Stack(children: [
      CircleAvatar(
          backgroundImage: NetworkImage(adminModel!.imageUrl), radius: 20),
      adminModel!.connected == "no"
          ? Container(
              width: 0,
              height: 0,
            )
          : Positioned(
              left: 0,
              bottom: 0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: 10,
                  height: 10,
                  color: Colors.green,
                ),
              ))
    ]);
  }
}
