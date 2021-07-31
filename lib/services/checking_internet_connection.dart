import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';

Future<void>checkingInternetConnection(Function executeBody)async
{

  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      executeBody();

    }} on SocketException catch (_) {

    Fluttertoast.showToast(msg:"تأكد من إتصالك بالإنترنت",toastLength: Toast.LENGTH_LONG);

  }


}
