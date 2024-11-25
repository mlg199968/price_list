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

}
