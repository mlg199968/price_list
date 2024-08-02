import 'dart:convert';
import 'dart:math';


import 'package:http/http.dart' as http;

import '../../../../constants/error_handler.dart';
import '../../../../constants/private.dart';

class PayamitoApi {
  static Future<Map?> sentMessage(context, String phoneNumber,{String bodyId=PrivateKeys.bodyIdPurchase}) async {
    try{
      Random random = Random();
      String authCode = (random.nextInt(8998) + 1001).toString();
      var messageBox = {
        "username": PrivateKeys.payamitoUserName,
        "password": PrivateKeys.payamitoPass,
        "text": "$authCode;",
        "to": phoneNumber,
        "bodyId": bodyId,
      };

      http.Response res = await http.post(
          Uri.parse(
              "https://rest.payamak-panel.com/api/SendSMS/BaseServiceNumber"),
          body: messageBox);
      if (res.statusCode == 200) {
        Map backData = jsonDecode(res.body);
        if (backData["RetStatus"] == 1 && context.mounted) {
          return {"isRight": true, "authCode": authCode};
        }
      }
    }catch(e){

      ErrorHandler.errorManger(context, e,title: "PayamitoApi -sendMessage error",showSnackbar: true);
    }
    return null;
  }
}
