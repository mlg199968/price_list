import 'package:flutter/material.dart';
import 'package:flutter_poolakey/flutter_poolakey.dart';
import 'package:price_list/constants/private.dart';
import 'package:provider/provider.dart';

import '../../../constants/enums.dart';
import '../../../constants/error_handler.dart';
import '../../../constants/utils.dart';
import '../../../providers/user_provider.dart';
import '../../ware_list/ware_list_screen.dart';

class BazaarApi {
  //TODO: bazaar connect function
  static connectToBazaar2(BuildContext context) async {
    try {
      bool connectionState = await FlutterPoolakey.connect(
        PrivateKeys.rsaKey,
        onDisconnected: () {
          showSnackBar(context, "خطا در ارتباط با بازار");
          print("bazaar not connected");
        },
      );
      if (connectionState) {
        PurchaseInfo purchaseInfo = await FlutterPoolakey.purchase('p1');
        if (purchaseInfo.purchaseState == PurchaseState.PURCHASED) {
          Provider.of<UserProvider>(context, listen: false).setUserLevel(1);
          Navigator.pushNamedAndRemoveUntil(
              context, WareListScreen.id, (route) => false);
          showSnackBar(context, "برنامه با موفقیت فعال شد",
              type: SnackType.success, dialogMode: true);
        }
      }
    } catch (e) {
      ErrorHandler.errorManger(context, e,
          title: "روند پرداخت در بازار با مشکل مواجه شده است",
          showSnackbar: true);
      print(e);
    }
  }

//TODO: bazaar connect function
  static connectToBazaar(BuildContext context, String productId) async {
    try {
      bool connectionState = await FlutterPoolakey.connect(
        PrivateKeys.rsaKey,
        onDisconnected: () {
          showSnackBar(context, "خطا در ارتباط با بازار");
          print("bazaar not connected");
        },
      );
      if (connectionState) {
        PurchaseInfo purchaseInfo = await FlutterPoolakey.subscribe(productId);
        if (purchaseInfo.purchaseState == PurchaseState.PURCHASED) {
          Provider.of<UserProvider>(context, listen: false).setUserLevel(1);
          Navigator.pushNamedAndRemoveUntil(
              context, WareListScreen.id, (route) => false);
          showSnackBar(context, "برنامه با موفقیت فعال شد",
              type: SnackType.success, dialogMode: true);
        }
      }
    } catch (e, stacktrace) {
      ErrorHandler.errorManger(context, e,
          stacktrace: stacktrace,
          title: "روند پرداخت در بازار با مشکل مواجه شده است",
          showSnackbar: true);
    }
  }

//TODO: bazaar fetch info function
  fetchBazaarInfo(BuildContext context) async {
    try {
      bool? isSubscribe = await checkSubscribe(
          context, await getPurchasesList());
      print(isSubscribe);
      if (isSubscribe == true) {
        Provider.of<UserProvider>(context, listen: false).setUserLevel(1);
      } else if (isSubscribe == false) {
        Provider.of<UserProvider>(context, listen: false).setUserLevel(0);
      }
    }catch(e,stacktrace){
      ErrorHandler.errorManger(context, e,
          stacktrace: stacktrace,
          route: "BazaarApi fetchBazaarInfo function error",
          title: "خواندن داده های  بازار با مشکل مواجه شده است");
    }
  }

  ///
  static Future<List<PurchaseInfo>?> getPurchasesList() async {
    bool connection = await FlutterPoolakey.connect(PrivateKeys.rsaKey,onDisconnected: (){
      debugPrint("failed to connect to bazaar");
    }).timeout(Duration(seconds: 6));
    if (connection) {
      List<PurchaseInfo> purchaseList =
          await FlutterPoolakey.getAllPurchasedProducts();
      List<PurchaseInfo> subsList =
          await FlutterPoolakey.getAllSubscribedProducts();
      return purchaseList + subsList;
    }
    return null;
  }

  ///
  bool? checkSubscribe(BuildContext context, List<PurchaseInfo>? subscribes) {
    try {
      if (subscribes != null) {
        ///old purchase is for that people were purchased before new payment method
        // PurchaseInfo? oldPurchaseInfo =subscribes.firstWhere((subs) => subs.productId=="3");
        if (subscribes.isNotEmpty) {
          for (PurchaseInfo purchaseInfo in subscribes) {
            if (purchaseInfo.purchaseState == PurchaseState.PURCHASED) {
              return true;
            } else if (purchaseInfo.purchaseState != PurchaseState.PURCHASED) {
              return false;
            }
          }
        } else {
            return false;
        }
      }
    } catch (e, stacktrace) {
      ErrorHandler.errorManger(context, e,
          stacktrace: stacktrace,
          title: "خواندن داده های  بازار با مشکل مواجه شده است");
    }
    return null;
  }
}
