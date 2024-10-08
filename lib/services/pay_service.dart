import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:myket_iap/myket_iap.dart';
// import 'package:myket_iap/util/iab_result.dart';
// import 'package:myket_iap/util/purchase.dart';
import 'package:price_list/constants/enums.dart';
import 'package:price_list/constants/error_handler.dart';
import 'package:price_list/constants/private.dart';
import 'package:price_list/constants/utils.dart';
import 'package:price_list/screens/ware_list/ware_list_screen.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../providers/user_provider.dart';

class PayService {
  static String basicAuth = 'Basic ' +
      base64.encode(utf8.encode(
          '${PrivateKeys.licenseApiKey}:${PrivateKeys.licenseApiPass}'));

  ///
  static checkLicense(BuildContext context, String license) async {
    if (license == "") {
      license = "something";
    }
    try {
      http.Response res = await http.get(
        Uri.parse("${PrivateKeys.licenseApiAddress}/activate/$license"),
        headers: <String, String>{'authorization': basicAuth},
      ).timeout(Duration(seconds: 10));

      Map result = jsonDecode(res.body);
      if (res.statusCode == 200 && result["data"]["timesActivated"] != null) {
        Provider.of<UserProvider>(context, listen: false).setUserLevel(1);
        Navigator.pushNamedAndRemoveUntil(
            context, WareListScreen.id, (route) => false);
        showSnackBar(context, "لایسنس با موفقیت اعمال شد",
            type: SnackType.success);
      } else if (res.statusCode == 200 && result["data"]["errors"] != null) {
        ErrorHandler.errorManger(context, result["data"]["errors"],
            title: "خطا احراز لایسنس", showSnackbar: true);
      } else if (res.statusCode == 404) {
        String message = result["message"];
        ErrorHandler.errorManger(context, message,
            title: "404 error", showSnackbar: true);
      }
    } catch (e) {
      ErrorHandler.errorManger(context, e,
          title: "مشکل ارتباط با سرور!", showSnackbar: true);
    }
  }



//TODO: myket connect function
  static connectToMyket(BuildContext context) async {
    try {
      // Map result = await MyketIAP.launchPurchaseFlow(sku: "1", payload:"payload");
      // IabResult purchaseResult = result[MyketIAP.RESULT];
      // Purchase purchase = result[MyketIAP.PURCHASE];
      // print("وضعیت خرید");
      // print(purchase.toJson());
      // print("وضعیت خرید از مایکت");
      // print(purchaseResult.mMessage);
      // print(purchaseResult.mResponse);
      // if(purchaseResult.mMessage.toLowerCase().contains("success")){
      //   Provider.of<UserProvider>(context,listen: false).setUserLevel(1);
      //   Navigator.pushNamedAndRemoveUntil(context, WareListScreen.id,(route)=>false);
      //   showSnackBar(context, "برنامه با موفقیت فعال شد!",type: SnackType.success,dialogMode: true);
      // }
    } catch (e) {
      ErrorHandler.errorManger(context, e,
          title: "روند پرداخت با مشکل مواجه شده است!", showSnackbar: true);
    }
  }
}
