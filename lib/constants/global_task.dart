
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:price_list/constants/error_handler.dart';
import 'package:price_list/constants/utils.dart';
import 'package:price_list/model/shop.dart';
import 'package:price_list/screens/purchase_screen/services/bazaar_api.dart';
import 'package:price_list/screens/ware_list/services/ware_tools.dart';
import 'package:price_list/services/hive_boxes.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../screens/notice_screen/services/notice_tools.dart';
import '../screens/purchase_screen/services/myket_api.dart';
import '../services/backend_services.dart';

class GlobalTask {
  static final GlobalKey<NavigatorState> navigatorState = GlobalKey<NavigatorState>();
  ///start up data
  Future<void> getInitData(context) async {
    try {

      WareTools.wareNullFixer();
      ///get shop info
      Shop shop=Shop();
      if(HiveBoxes.getShopInfo().values.isNotEmpty){
        shop = HiveBoxes.getShopInfo().values.single;
        Provider.of<UserProvider>(context, listen: false).getData(shop);
      }
      else{
        HiveBoxes.getShopInfo().add(shop);
      }

      ///get app version
      final deviceInfo=await PackageInfo.fromPlatform();
      Provider.of<UserProvider>(context, listen: false).setAppVersion(deviceInfo.version);
      ///
      checkNetworkConnection().then((check) {
        if (check)
        {
          //TODO:bazaar fetch data
          //TODO:myket fetch data
          if(Platform.isAndroid) {
            BazaarApi().fetchBazaarInfo(context);
            MyketApi().fetchMyketInfo();
          }
          /// fetch subscription data
          BackendServices().fetchSubs(context);
          ///get notifications
          NoticeTools.readNotifications(context,timeout: 5);
        }
      });


    }catch(e,stacktrace){
      if(context.mounted)
      ErrorHandler.errorManger(context, e,stacktrace:stacktrace,title: "GlobalTask getInitData function error");
    }
  }


}
