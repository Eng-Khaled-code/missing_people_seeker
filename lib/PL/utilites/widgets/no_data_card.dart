import 'package:flutter/material.dart';

class NoDataCard extends StatelessWidget {

  final String? msg;


  NoDataCard({Key? key,@required this.msg}):super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 50.0),
        child: Container(
          height: MediaQuery.of(context).size.height*0.2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                msg == "لا توجد إشعارات"
                    ? Icons.notifications_none
                    : msg == "حتي الان لا يوجد مسئولين عن طلباتك"
                    ? Icons.admin_panel_settings_outlined
                    : msg == "لا توجد طلبات تم إيجادها"
                    ?
                Icons.no_accounts
                    : msg=="لا توجد إقتراحات في الوقت الحالي"
                    ?
                    Icons.library_books_sharp
                    :
                Icons.library_books_sharp,
                color: Colors.grey,
                size: 50.0,
              ),
              Text(msg!, style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}
