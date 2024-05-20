import 'package:flutter/material.dart';
import 'package:price_list/model/ware.dart';
import 'package:price_list/screens/ware_list/add_ware_screen.dart';
import 'package:price_list/screens/purchase_screen/bazaar_purchase_screen.dart';
import 'package:price_list/screens/bug_screen/bug_list_screen.dart';
import 'package:price_list/screens/group_management_screen.dart';
import 'package:price_list/screens/notice_screen/notice_screen.dart';
import 'package:price_list/screens/purchase_screen/purchase_screen.dart';
import 'package:price_list/screens/shop_info_screen/shop_info_screen.dart';
import 'package:price_list/screens/ware_list/panels/ware_action_panel.dart';
import 'package:price_list/screens/ware_list/ware_list_screen.dart';
import 'package:price_list/screens/setting/setting_screen.dart';

Route generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case AddWareScreen.id:
      Ware? wareHive = routeSettings.arguments as Ware?;
      return MaterialPageRoute(
          builder: (_) => AddWareScreen(
                oldWare: wareHive,
              ));

    case WareListScreen.id:
      Key? key = routeSettings.arguments as Key?;
      return MaterialPageRoute(
          builder: (_) => WareListScreen(
                key: key,
              ));

    case SettingScreen.id:
      return MaterialPageRoute(builder: (_) => SettingScreen());

    case WareActionsPanel.id:
      return MaterialPageRoute(
          builder: (_) => WareActionsPanel(wares: [], subGroup: "subGroup"));

    case GroupManagementScreen.id:
      return MaterialPageRoute(builder: (_) => GroupManagementScreen());

    case PurchaseScreen.id:
      return MaterialPageRoute(builder: (_) => PurchaseScreen());

    case BazaarPurchaseScreen.id:
         return MaterialPageRoute(builder: (_) => BazaarPurchaseScreen());


    case NoticeScreen.id:
         return MaterialPageRoute(builder: (_) => NoticeScreen());

    case BugListScreen.id:
         return MaterialPageRoute(builder: (_) => BugListScreen());

    case ShopInfoScreen.id:
         return MaterialPageRoute(builder: (_) => ShopInfoScreen());

    default:
      return MaterialPageRoute(
          builder: (_) => const Scaffold(
                body: Center(
                  child: Column(
                    children: [
                      Text('the Screen is not exist.'),
                      SizedBox(height: 10,),
                      BackButton()
                    ],
                  ),
                ),
              ));
  }
}
