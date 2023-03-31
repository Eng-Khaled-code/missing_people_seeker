import 'package:flutter/material.dart';
import 'package:finalmps/provider/chat_change.dart';

import 'chat_app_bar.dart';
import 'chat_body.dart';

class ChatPage extends StatelessWidget {
  final String? adminId;
  final String? userId;
  final String? adminAvatar;
  final String? adminName;
  final ChatChange? chatChange;
  ChatPage(
      {@required this.userId,
      @required this.adminAvatar,
      @required this.adminName,
      @required this.adminId,
      @required this.chatChange});
final TextEditingController messageEditingController=TextEditingController();

  @override
  Widget build(BuildContext context) {
   
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: ChatAppBar(
          adminAvatar: adminAvatar,
          adminName: adminName,
          adminOpensChatPage: chatChange!.opensChatPage,
          connectStatus: chatChange!.connectStatus,
        ),
        body: ChatScreenBody(
            userId: userId, adminId: adminId, chatChange: chatChange,messageEditingController: messageEditingController),
      ),
    );
  }
}
