


import 'dart:io';

import 'package:flutter/material.dart';
import 'package:myket_iap/myket_iap.dart';
import 'package:price_list/constants/private.dart';
import 'package:price_list/model/shop.dart';
import 'package:price_list/providers/ware_provider.dart';
import 'package:price_list/services/hive_boxes.dart';
import 'package:provider/provider.dart';

class GlobalTask{

  Future<void>getStartUpData(context)async{
    ///myket starter api
    if(Platform.isAndroid){
      var iabResult = await MyketIAP.init(
          rsaKey: Private.rsaKeyMyket, enableDebugLogging: true);
    }
     Provider.of<WareProvider>(context,listen: false).getVip();
    if(HiveBoxes.getShopInfo().isNotEmpty) {
      Shop shop = HiveBoxes
          .getShopInfo()
          .values.first;
        Provider.of<WareProvider>(context, listen: false).getData(shop);

    }else{
      Shop shop=Shop();
      HiveBoxes.getShopInfo().add(shop);
    }
  }
}