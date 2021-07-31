import 'dart:convert';
import 'package:http/http.dart' as http;

class OrdersImageServices {

  Future<Map<String,dynamic>> uploadImageToServer(Map<String, String> data,String url) async {
    try {

      var uri = Uri.parse(url);
      var response = await http.post(uri, body: data);

        if (response.statusCode == 200) {
          var resultMap = jsonDecode(response.body);
          print("نجاح");

          return resultMap;
        } else {

          return {"status": "0", "message": "status code error : ${response.statusCode.toString()}"};
        }
    } catch (ex) {

      return {"status":"0","message":"try and catch error ${ex}"};
    }
  }}