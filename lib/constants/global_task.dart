
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:price_list/constants/error_handler.dart';
import 'package:price_list/model/shop.dart';
import 'package:price_list/providers/ware_provider.dart';
import 'package:price_list/services/hive_boxes.dart';
import 'package:provider/provider.dart';

class GlobalTask {
  static final GlobalKey<NavigatorState> navigatorState = GlobalKey<NavigatorState>();
  ///start up data
  Future<void> getStartUpData(context) async {
    try {
      ///get user level(vip)
      Provider.of<WareProvider>(context, listen: false).getVip();

      ///get shop info
      if (HiveBoxes
          .getShopInfo()
          .isNotEmpty) {
        Shop shop = HiveBoxes
            .getShopInfo()
            .values
            .first;
        Provider.of<WareProvider>(context, listen: false).getData(shop);
      } else {
        Shop shop = Shop();
        HiveBoxes.getShopInfo().add(shop);
      }

      ///get notifications
      if(context.mounted)
      await Provider.of<WareProvider>(context, listen: false).loadNotification(
          context);
    }catch(e){
      if(context.mounted)
      ErrorHandler.errorManger(context, e,title: "GlobalTask getStartUpData function error");
    }
  }


}
