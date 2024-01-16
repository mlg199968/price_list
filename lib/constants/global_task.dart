import 'dart:io';
import 'package:myket_iap/myket_iap.dart';
import 'package:price_list/constants/constants.dart';
import 'package:price_list/constants/private.dart';
import 'package:price_list/model/notice.dart';
import 'package:price_list/model/shop.dart';
import 'package:price_list/providers/ware_provider.dart';
import 'package:price_list/screens/notice_screen/services/notice_tools.dart';
import 'package:price_list/services/backend_services.dart';
import 'package:price_list/services/hive_boxes.dart';
import 'package:provider/provider.dart';

class GlobalTask {
  ///start up data
  Future<void> getStartUpData(context) async {
    //TODO:myket starter api
    if (Platform.isAndroid) {
      var iabResult = await MyketIAP.init(
          rsaKey: Private.rsaKeyMyket, enableDebugLogging: true);
    }

    ///get user level(vip)
    Provider.of<WareProvider>(context, listen: false).getVip();

    ///get shop info
    if (HiveBoxes.getShopInfo().isNotEmpty) {
      Shop shop = HiveBoxes.getShopInfo().values.first;
      Provider.of<WareProvider>(context, listen: false).getData(shop);
    } else {
      Shop shop = Shop();
      HiveBoxes.getShopInfo().add(shop);
    }
    await NoticeTools.readNotifications(context);
  }


}
