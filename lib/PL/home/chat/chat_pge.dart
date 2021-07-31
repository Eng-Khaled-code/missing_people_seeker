import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:finalmps/provider/chat_change.dart';

import 'chat_body.dart';

class ChatPage extends StatefulWidget {
  final String? adminId;
  final String? userId;
  final String? adminAvatar;
  final String? adminName;

  ChatPage(
      {@required this.userId,
      @required this.adminAvatar,
      @required this.adminName,
      @required this.adminId});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    ChatChange chat = Provider.of<ChatChange>(context);
    chat.loadAdminOpensMyChatPage(
        widget.userId! + "&" + widget.adminId!, widget.adminId!);
    chat.loadConnectStatus(widget.adminId!);
    return Scaffold(
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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              widget.adminName!,
              style: TextStyle(fontSize: 13, color: Colors.black54),
            ),
            chat.getConnectStatus == "no"
                ? Container()
                : Text(
                    "متصل الان  ",
                    style: TextStyle(
                        fontSize: 11,
                        color: chat.getOpensMyChatPage == "yes"
                            ? Colors.green
                            : Colors.black54),
                  ),
          ],
        ),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                clipBehavior: Clip.hardEdge,
                borderRadius: BorderRadius.circular(18.0),
                child: widget.adminAvatar == "no image"
                    ? Icon(
                        Icons.account_circle,
                        color: Colors.grey,
                        size: 35,
                      )
                    : CachedNetworkImage(
                        placeholder: (context, url) {
                          return Container(
                            width: 35.0,
                            height: 35.0,
                            padding: EdgeInsets.all(10.0),
                            child: CircularProgressIndicator(),
                          );
                        },
                        imageUrl: widget.adminAvatar!,
                        width: 35.0,
                        height: 35.0,
                        fit: BoxFit.cover,
                        errorWidget: (a, x, d) => Image.asset(
                          "assets/images/errorimage.png",
                          fit: BoxFit.cover,
                          width: 35,
                          height: 35,
                        ),
                      ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.arrow_forward),
            onPressed: () => Navigator.pop(context),
          )
        ],
        automaticallyImplyLeading: false,
      ),
      body: Directionality(
          textDirection: TextDirection.rtl,
          child: ChatScreenBody(
              userId: widget.userId,
              adminId: widget.adminId,
              chatChange: chat)),
    );
  }
}
