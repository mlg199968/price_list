import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:price_list/components/custom_alert_dialog.dart';
import 'package:price_list/constants/constants.dart';
import 'package:price_list/constants/private.dart';
import 'package:price_list/constants/utils.dart';
import 'package:price_list/screens/ware_list/ware_list_screen.dart';
import 'package:price_list/ware_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class PayService {

  static String basicAuth =
      'Basic ' + base64.encode(
          utf8.encode('${Private.licenseApiKey}:${Private.licenseApiPass}'));



  static _activeLicense(context,String license)async{
    try {
      http.Response res = await http.get(
        Uri.parse("${Private.licenseApiAddress}/activate/$license"),
        headers: <String, String>{'authorization': basicAuth},);
      if (res.statusCode == 200) {

      } else if (res.statusCode == 404) {
        showSnackBar(
            context, "اتمام تعداد دفعات استفاده از این لایسنس!", type: SnackType.warning);
        print("اتمام تعداد دفعات استفاده از این لایسنس!");
      }
    } catch (e) {
      showSnackBar(context, "مشکل ارتباط با سرور!", type: SnackType.error);
      print("مشکل ارتباط با سرور در اکتیو کردن لایسنس!");
      print(e);
    }
  }

  static checkLicense(BuildContext context, String license) async {
    if (license == "") {
      license = "something";
    }

    try {
      http.Response res = await http.get(
        Uri.parse("${Private.licenseApiAddress}/activate/$license"),
        headers: <String, String>{'authorization': basicAuth},
      );

      Map data = jsonDecode(res.body);
      if (res.statusCode == 200) {
          Provider.of<WareProvider>(context, listen: false).setVip(true);
          Navigator.pushReplacementNamed(context, WareListScreen.id);
          showSnackBar(
              context, "لایسنس با موفقیت اعمال شد", type: SnackType.success);
      }
      else if (res.statusCode == 404) {
        String message=data["message"];
        showSnackBar(
            context,message, type: SnackType.warning);
        print(message);
      }
    } catch (e) {
      showSnackBar(context, "مشکل ارتباط با سرور!", type: SnackType.error);
      print("مشکل ارتباط با سرور!");
      print(e);
    }
  }


// static connectToBazaar(BuildContext context) async {
//
//   bool connectionState=await FlutterPoolakey.connect(
//     Private.rsaKey,
//     onDisconnected: () {
//     },
//   );
//
//   if(connectionState){
//
//     try {
//       PurchaseInfo purchaseInfo = await FlutterPoolakey.purchase('1');
//       Provider.of<WareProvider>(context,listen: false).setVip(true);
//     }catch(e){
//       showSnackBar(context, "روند پرداخت با مشکل مواجه شده است");
//       print(e);
//     }
//
//   }
// }
}
