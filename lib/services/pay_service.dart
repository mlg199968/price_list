import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_poolakey/flutter_poolakey.dart';
// import 'package:myket_iap/myket_iap.dart';
// import 'package:myket_iap/util/iab_result.dart';
// import 'package:myket_iap/util/purchase.dart';
import 'package:price_list/constants/enums.dart';
import 'package:price_list/constants/error_handler.dart';
import 'package:price_list/constants/private.dart';
import 'package:price_list/constants/utils.dart';
import 'package:price_list/screens/ware_list/ware_list_screen.dart';
import 'package:price_list/providers/ware_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class PayService {

  static String basicAuth =
      'Basic ' + base64.encode(
          utf8.encode('${Private.licenseApiKey}:${Private.licenseApiPass}'));



  // static _activeLicense(context,String license)async{
  //   try {
  //     http.Response res = await http.get(
  //       Uri.parse("${Private.licenseApiAddress}/activate/$license"),
  //       headers: <String, String>{'authorization': basicAuth},);
  //     if (res.statusCode == 200) {
  //
  //     } else if (res.statusCode == 404) {
  //       showSnackBar(
  //           context, "اتمام تعداد دفعات استفاده از این لایسنس!", type: SnackType.warning);
  //       print("اتمام تعداد دفعات استفاده از این لایسنس!");
  //     }
  //   } catch (e) {
  //     showSnackBar(context, "مشکل ارتباط با سرور!", type: SnackType.error);
  //     print("مشکل ارتباط با سرور در اکتیو کردن لایسنس!");
  //     print(e);
  //   }
  // }

  static checkLicense(BuildContext context, String license) async {
    if (license == "") {
      license = "something";
    }

    try {
      http.Response res = await http.get(
        Uri.parse("${Private.licenseApiAddress}/activate/$license"),
        headers: <String, String>{'authorization': basicAuth},
      ).timeout(Duration(seconds: 10));

      Map result = jsonDecode(res.body);
      if (res.statusCode == 200 && result["data"]["timesActivated"]!=null) {
          Provider.of<WareProvider>(context, listen: false).setVip(true);
           Navigator.pushNamedAndRemoveUntil(context, WareListScreen.id,(route)=>false);
          showSnackBar(
              context, "لایسنس با موفقیت اعمال شد", type: SnackType.success);
      }
      else if(res.statusCode == 200 && result["data"]["errors"]!=null){
        ErrorHandler.errorManger(context, result["data"]["errors"],title:"خطا احراز لایسنس",showSnackbar: true);
      }
      else if (res.statusCode == 404) {
        String message=result["message"];
        ErrorHandler.errorManger(context,message,title:"404 error",showSnackbar: true);
      }
    } catch (e) {
      ErrorHandler.errorManger(context,e,title:"مشکل ارتباط با سرور!",showSnackbar: true);
    }
  }

//TODO: bazaar connect function
static connectToBazaar(BuildContext context) async {

  try {
    print("*****************");
    // CafebazaarFlutter _bazaar = CafebazaarFlutter.instance;
    // InAppPurchase inApp = _bazaar.inAppPurchase(Private.rsaKey);
    //
    //
    //
    //   PurchaseInfo? purchaseInfo = await inApp.purchase('3');
    //   if(purchaseInfo != null){
    //     print(purchaseInfo.toMap());
    //     Provider.of<WareProvider>(context,listen: false).setVip(true);
    //     Navigator.pushNamedAndRemoveUntil(context, WareListScreen.id,(route)=>false);
    //     showSnackBar(context, "برنامه با موفقیت فعال شد",type: SnackType.success,dialogMode: true);
    //   }

  bool connectionState=await FlutterPoolakey.connect(
    Private.rsaKey,
    onDisconnected: () {
      showSnackBar(context, "خطا در ارتباط با بازار");
      print("bazaar not connected");
    },
  );
  if(connectionState){
      PurchaseInfo purchaseInfo = await FlutterPoolakey.purchase('3');
      if(purchaseInfo.purchaseState==PurchaseState.PURCHASED){
        Provider.of<WareProvider>(context,listen: false).setVip(true);
        Navigator.pushNamedAndRemoveUntil(context, WareListScreen.id,(route)=>false);
        showSnackBar(context, "برنامه با موفقیت فعال شد",type: SnackType.success,dialogMode: true);
      }
  }



  }catch(e){
    ErrorHandler.errorManger(context, e,title: "روند پرداخت در بازار با مشکل مواجه شده است",showSnackbar: true);
    print(e);
  }
}
//TODO: myket connect function
static connectToMyket(BuildContext context)async{
    try{
      // Map result = await MyketIAP.launchPurchaseFlow(sku: "1", payload:"payload");
      // IabResult purchaseResult = result[MyketIAP.RESULT];
      // Purchase purchase = result[MyketIAP.PURCHASE];
      // print("وضعیت خرید");
      // print(purchase.toJson());
      // print("وضعیت خرید از مایکت");
      // print(purchaseResult.mMessage);
      // print(purchaseResult.mResponse);
      // if(purchaseResult.mMessage.toLowerCase().contains("success")){
      //   Provider.of<WareProvider>(context,listen: false).setVip(true);
      //   Navigator.pushNamedAndRemoveUntil(context, WareListScreen.id,(route)=>false);
      //   showSnackBar(context, "برنامه با موفقیت فعال شد!",type: SnackType.success,dialogMode: true);
      // }


    }catch(e){
      ErrorHandler.errorManger(context,e,title:"روند پرداخت با مشکل مواجه شده است!",showSnackbar: true);
    }


}
}


// {success: true,
// data: {
//   errors: {
//     lmfwc_rest_data_error: [License Key: 141 could not be found.]},
// error_data: {
//     lmfwc_rest_data_error: {status: 404}
//   }
// }
// }


// {
// success: true,
// data: {
//       id: 1,
//       orderId: null,
//       productId: null,
//       userId: 20,
//       licenseKey: pl-123456,
//       expiresAt: null,
//       validFor: 120,
//       source: 2,
//       status: 3,
//       timesActivated: 4,
//       timesActivatedMax: 100,
//       createdAt: 2023-09-10 07:59:45,
//       createdBy: 1,
//       updatedAt: 2024-01-15 05:19:15,
//       updatedBy: 1,
//       activationData: {
//               id: 5,
//               token: 7c23ef39f2e9f98e07b14387569374d80031566c,
//               license_id: 1,
//               label: null,
//               source: 2,
//               ip_address: 31.14.93.30,
//               user_agent: Dart/3.2 (dart:io),
//               meta_data: null,
//               created_at: 2024-01-15 05:19:15,
//               updated_at: null,
//               deactivated_at: null}
//             }
//           }