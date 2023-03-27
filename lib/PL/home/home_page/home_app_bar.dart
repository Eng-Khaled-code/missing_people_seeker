import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../provider/notify_change.dart';
import 'custom_chat_or_notify.dart';
import '../../utilites/helper/helper.dart';
import '../../utilites/text_style/text_styles.dart';
import '../chat/admins_chat_list/admins_chat_list.dart';
import '../notifications/notifications.dart';


class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  HomeAppBar({Key? key,this.userId,this.notifyChange,this.title="الرئيسية"})
      : super(key: key);
final String? userId;
final NotifyChange? notifyChange;
final String? title;
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
      title!,
      style: TextStyles.title.copyWith(color: Colors.white),
    ),
      actions: [
        notificationWidget(
            context: context,
          ),
        chatWidget(
          context: context,
        )
      ],
    );
  }


  Widget notificationWidget(
      {BuildContext? context}) {
    return CustomChatNotifyWidget(
        icon: Icons.notifications_none,
        onPress: () async {
          Helper().goTo(context :context, to:NotificationPage(userId: userId,notifyChange: notifyChange));
          await notifyChange!.updateLastDate(userId: userId);
        },
        count: int.tryParse(notifyChange!.notifyCount));
  }

  Widget chatWidget({BuildContext? context, String? userId}) {
    return CustomChatNotifyWidget(
        icon: CupertinoIcons.chat_bubble_2,
        onPress: () =>Helper().goTo(context :context, to:AdminsChatList(userId: userId,)),
        count: 0);
    // count: chatChange.getRecentMessagesCount);
  }

}