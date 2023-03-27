import 'package:flutter/material.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  ChatAppBar({Key? key,this.adminOpensChatPage,this.connectStatus,this.adminName,this.adminAvatar})
      : super(key: key);
  final String? connectStatus;
  final String? adminName;
  final String? adminOpensChatPage;
  final String? adminAvatar;

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(adminName!),
          connectStatus == "no"
              ? Container()
              : Text(
            "متصل الان  ",
            style: TextStyle(
                fontSize: 11,
                color: adminOpensChatPage == "yes"
                    ?
                Colors.green
                    : Colors.grey),
          ),
        ],
      ),
      actions: [
        Center(
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child:CircleAvatar(backgroundImage: NetworkImage(adminAvatar!))
            )),
        IconButton(
          icon: Icon(Icons.arrow_forward),
          onPressed: () => Navigator.pop(context),
        )
      ],
      automaticallyImplyLeading: false,
    );
  }}