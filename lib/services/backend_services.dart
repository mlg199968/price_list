import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:price_list/constants/constants.dart';
import 'package:price_list/constants/error_handler.dart';
import 'package:price_list/model/notice.dart';


class BackendServices {



///read Notifications from host
  Future<List<Notice?>?> readNotice(context,{int timeout=10 ,String appName=kAppName,}) async {
    try {

      http.Response res = await http.post(
          Uri.parse("$hostUrl/notification/read_notice.php"),
          body: {"app-name": appName}).timeout(Duration(seconds: timeout));
      if (res.statusCode == 200) {
        var backData = jsonDecode(res.body);
        if (backData["success"] == true) {
          List<Notice> notices =(backData["notification-list"] as List).map((e) => Notice().fromJson(e["notice_object"])).toList() ;

          debugPrint("notifications successfully being read!");
          return notices;

        } else {
          debugPrint("error in backendServices.readNotice php api error error");
          return null;

        }
      }
    } catch (e) {
      ErrorHandler.errorManger(context, e,title: "BackendServices-readSubscription error");
    }
    return null;
  }



///get the options from mysql like the price of the app
  Future readOption(String optionName)async{
final res=await http.post(
    Uri.parse("$hostUrl/user/read_options.php"),
    body:{"option_name":optionName});
if(res.statusCode==200){
  var backData=jsonDecode(res.body);
  if (backData["success"] == true){
    return backData["values"]["option_value"];
  }
}
  }

}
