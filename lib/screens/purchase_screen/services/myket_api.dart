

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:price_list/constants/global_task.dart';
import '../../../constants/error_handler.dart';

// import 'dart:io';
// import 'package:price_list/screens/purchase_screen/services/purchase_tools.dart';
// import 'package:provider/provider.dart';
// import '../../../constants/enums.dart';
//
// import '../../../constants/private.dart';
// import '../../../constants/utils.dart';
// import '../../../providers/user_provider.dart';
// import '../../ware_list/ware_list_screen.dart';

// import 'package:myket_iap/myket_iap.dart';
// import 'package:myket_iap/util/iab_result.dart';
// import 'package:myket_iap/util/inventory.dart';
// import 'package:myket_iap/util/purchase.dart';

//TODO: myket connect function
class MyketApi {
  BuildContext get globalContext => GlobalTask.navigatorState.currentContext!;
  ///init
 static Future<bool> init() async {
    try{
      // if (Platform.isAndroid) {
      //   var iabResult = await MyketIAP.init(
      //       rsaKey: PrivateKeys.rsaKeyMyket, enableDebugLogging: false);
      //   if (iabResult != null && iabResult.isSuccess()) {
      //     return true;
      //   }
      //   else {
      //     ErrorHandler.errorManger(null, iabResult,
      //         title: "عدم برقراری ارتباط با برنامه مایکت", showSnackbar: true);
      //   }
      //   print(iabResult?.toJson());
      // }
    }
    catch(e,stacktrace){
      ErrorHandler.errorManger(null, e,
          stacktrace: stacktrace,
          route: "MyketApi.init error",
          title: "خطا در برقراری ارتباط با برنامه مایکت", showSnackbar: true);
    };
    return false;
  }

  ///purchase
  Future purchase(BuildContext context, String productId) async {
    try {
      // Map result =
      //     await MyketIAP.launchPurchaseFlow(sku: productId, payload: "");
      // IabResult purchaseResult = result[MyketIAP.RESULT];
      // Purchase purchase = result[MyketIAP.PURCHASE];
      // if (purchaseResult.isSuccess()) {
      //   Provider.of<UserProvider>(context, listen: false).setUserLevel(1);
      //   int days= PurchaseTools.convertPlan(purchase.mSku)["days"] ?? 0;
      //   int sec= PurchaseTools.convertPlan(purchase.mSku)["sec"] ?? 0;
      //   DateTime purchasedDate=DateTime.fromMillisecondsSinceEpoch(purchase.mPurchaseTime);
      //   DateTime expirationDate = purchasedDate.add(Duration(days: days,seconds: sec));
      //   Provider.of<UserProvider>(context, listen: false).setExpirationDate(expirationDate);
      //
      //   Navigator.pushNamedAndRemoveUntil(
      //       context, WareListScreen.id, (route) => false);
      //   showSnackBar(context, "برنامه با موفقیت فعال شد!",
      //       type: SnackType.success, dialogMode: true);
      // }
    } catch (e, stacktrace) {
      ErrorHandler.errorManger(context, e,
          stacktrace: stacktrace,
          title: "روند پرداخت با مشکل مواجه شده است!",
          showSnackbar: true);
    }
  }

/// get purchases list
  Future<List?> getPurchasesList() async {
    bool isConnected= await MyketApi.init();
    try {
      // if (isConnected) {
      //   Map result = await MyketIAP.queryInventory(querySkuDetails: false);
      //   IabResult purchaseResult = result[MyketIAP.RESULT];
      //   Inventory inventory = result[MyketIAP.INVENTORY];
      //   return inventory.mPurchaseMap.values.toList();
      // }
    } catch (e, stacktrace) {
      ErrorHandler.errorManger(globalContext, e,
          stacktrace: stacktrace,
          title: "خطا در دریافت لیست خریدهای کاربری!",);
    }
    return null;
  }

  /// fetch myket info
  Future<List?> fetchMyketInfo() async {
    bool isConnected= await MyketApi.init();
    // List<Purchase>? purchases = await getPurchasesList() as List<Purchase>?;
    try {
      // if (isConnected && purchases!=null && purchases.isNotEmpty) {
      //   for(Purchase purchase in purchases){
      //     int days= PurchaseTools.convertPlan(purchase.mSku)["days"] ?? 0;
      //     int sec= PurchaseTools.convertPlan(purchase.mSku)["sec"] ?? 0;
      //     DateTime purchasedDate=DateTime.fromMillisecondsSinceEpoch(purchase.mPurchaseTime);
      //     DateTime expirationDate = purchasedDate.add(Duration(days: days,seconds: sec));
      //     if(expirationDate.isBefore(DateTime.now())){
      //       await consumePurchase(purchase);
      //       purchases.remove(purchase);
      //     }
      //   }
      //
      //   DateTime lastExDate=DateTime.now();
      //   purchases.forEach((purchase) {
      //     int days= PurchaseTools.convertPlan(purchase.mSku)["days"];
      //     int sec= PurchaseTools.convertPlan(purchase.mSku)["sec"] ?? 0;
      //     DateTime purchasedDate=DateTime.fromMillisecondsSinceEpoch(purchase.mPurchaseTime);
      //     DateTime expirationDate = purchasedDate.add(Duration(days: days,seconds: sec));
      //
      //     if (lastExDate.isBefore(expirationDate)) {
      //       lastExDate = expirationDate;
      //     }
      //   });
      //   Provider.of<UserProvider>(globalContext, listen: false).setExpirationDate(lastExDate);
      //   if (lastExDate.isAfter(DateTime.now())) {
      //     Provider.of<UserProvider>(globalContext, listen: false)
      //         .setUserLevel(1);
      //   }
      //   return purchases;
      // }
    } catch (e, stacktrace) {
      ErrorHandler.errorManger(globalContext, e,
          stacktrace: stacktrace,
          route:  "MyketApi.fetchMyketInfo error",
          title: "خطا در دریافت داده ها از مایکت",);
    }
    return null;
  }

/// consume purchase(or delete purchase subscription)
//   Future consumePurchase(Purchase purchase) async {
//     try {
//       var consumeResultMap = await MyketIAP.consume(purchase: purchase);
//       IabResult? consumeResult = consumeResultMap[MyketIAP.RESULT];
//       Purchase? consumePurchase = consumeResultMap[MyketIAP.PURCHASE];
//       print(
//           "Consumption finished. Purchase: $consumePurchase, result: $consumeResult");
//
//       // We know this is the "gas" sku because it's the only one we consume,
//       // so we don't check which sku was consumed. If you have more than one
//       // sku, you probably should check...
//       if (true == consumeResult?.isSuccess()) {
//         debugPrint("Consumption successful. Provisioning.");
//       } else {
//         ErrorHandler.errorManger(globalContext,
//             consumeResult,
//             title: "عدم موفقیت در کانسوم کردن خرید در مایکت!",
//             route: "failed consuming: MyketApi.consumePurchase");
//
//       }
//       print("End consumption flow.");
//     } catch (e,stacktrace) {
//       ErrorHandler.errorManger(globalContext, e,
//           route: "Error while consuming: MyketApi.consumePurchase",
//           stacktrace: stacktrace,
//           title: "خطا در کانسوم کردن خرید در مایکت!",);
//     }
//   }

}
