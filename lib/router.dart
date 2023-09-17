import 'package:flutter/material.dart';
import 'package:price_list/add_ware/add_ware_screen.dart';
import 'package:price_list/model/ware_hive.dart';
import 'package:price_list/screens/group_management_screen.dart';
import 'package:price_list/screens/purchase_screen.dart';
import 'package:price_list/screens/ware_list/panels/ware_action_panel.dart';
import 'package:price_list/screens/ware_list/ware_list_screen.dart';
import 'package:price_list/side_bar/setting/setting_screen.dart';

Route generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case AddWareScreen.id:
      WareHive? wareHive = routeSettings.arguments as WareHive?;
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

    default:
      return MaterialPageRoute(
          builder: (_) => const Scaffold(
                body: Center(
                  child: Text('the Screen is not exist.'),
                ),
              ));
  }
}
