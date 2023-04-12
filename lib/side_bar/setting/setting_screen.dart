import 'package:flutter/material.dart';
import 'package:price_list/components/custom_button.dart';
import 'package:price_list/components/drop_list_model.dart';
import 'package:price_list/constants/constants.dart';
import 'package:price_list/permission_handler.dart';
import 'package:price_list/side_bar/setting/backup/backup_tools.dart';
import 'package:price_list/ware_provider.dart';

import 'package:provider/provider.dart';

class SettingScreen extends StatefulWidget {
  static const String id = "/SettingScreen";
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  late String selectedValue;
  late WareProvider provider;

  // void storeInfoShop() {
  //   ShopHive? shopInfo = HiveBoxes.getShopInfo().get(0);
  //   if (shopInfo != null) {
  //     shopInfo.currency = selectedValue;
  //     provider.getData(shopInfo);
  //    // HiveBoxes.getShopInfo().put(0, shopInfo);
  //   }
  // }

  // void getData() {
  //   ShopHive? shopInfo = HiveBoxes.getShopInfo().get(0);
  //   if (shopInfo != null) {
  //     selectedValue = shopInfo.currency;
  //   }
  // }

  @override
  void initState() {
    selectedValue = kCurrencyList[0];
    super.initState();
  }

  @override
  void didChangeDependencies() {
    provider = Provider.of<WareProvider>(context, listen: false);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // storeInfoShop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("تنظیمات"),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          children: [
            Card(
              child: Container(
                padding: const EdgeInsets.all(15),
                margin: const EdgeInsets.all(15),
                decoration: BoxDecoration(border: Border.all(color: Colors.blue)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomButton(
                      text: "پشتیبان گیری",
                      color: Colors.red.withRed(250),
                      onPressed: () async {
                        await storagePermission(context, Allow.externalStorage);
                        // ignore: use_build_context_synchronously
                        await storagePermission(context, Allow.storage);
                        await BackupTools.createBackup();
                      },
                    ),
                    CustomButton(
                      text: "بارگیری فایل پشتیبان",
                      color: Colors.green,
                      onPressed: () async {
                        await storagePermission(context, Allow.storage);
                        await BackupTools.restoreBackup();
                      },
                    ),
                  ],
                ),
              ),
            ),
            DropListItem(
                title: "واحد پول",
                selectedValue: selectedValue,
                listItem: kCurrencyList,
                onChange: (val) {
                  selectedValue = val;
                  setState(() {});
                }),
            //SwitchItem(title: "title", onChange: (val) {}),
          ],
        ),
      ),
    );
  }
}

class SwitchItem extends StatelessWidget {
  const SwitchItem({
    super.key,
    required this.title,
    required this.onChange,
  });

  final String title;
  final void Function(bool) onChange;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title),
            Switch(value: false, onChanged: onChange),
          ],
        ),
      ),
    );
  }
}

class DropListItem extends StatelessWidget {
  const DropListItem({
    super.key,
    required this.title,
    required this.selectedValue,
    required this.listItem,
    required this.onChange,
  });

  final String title;
  final String selectedValue;
  final List<String> listItem;
  final void Function(String) onChange;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title),
            DropListModel(
                elevation: 0,
                width: 80,
                height: 30,
                listItem: listItem,
                selectedValue: selectedValue,
                onChanged: onChange),
          ],
        ),
      ),
    );
  }
}
