import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
      @required this.chatChange
      });

  @override
  Widget build(BuildContext context) {
    chatChange!.loadAdminOpensMyChatPage(
       userId! + "&" + adminId!, adminId!);
    chatChange!.loadConnectStatus(adminId!);
    return Scaffold(
      appBar: ChatAppBar(
        adminAvatar: adminAvatar,
        adminName: adminName,
        adminOpensChatPage: chatChange!.opensChatPage,
        connectStatus: chatChange!.connectStatus,),
      body: ChatScreenBody(
          userId: userId,
          adminId: adminId,
          chatChange: chatChange),
    );
  }
}
