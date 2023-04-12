import 'package:flutter/material.dart';
import 'package:price_list/add_ware/add_ware_screen.dart';
import 'package:price_list/model/ware_hive.dart';
import 'package:price_list/side_bar/setting/setting_screen.dart';
import 'package:price_list/ware_list/ware_list_screen.dart';

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

    default:
      return MaterialPageRoute(
          builder: (_) => const Scaffold(
                body: Center(
                  child: Text('the Screen is not exist.'),
                ),
              ));
  }
}
