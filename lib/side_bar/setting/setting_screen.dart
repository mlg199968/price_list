import 'package:flutter/material.dart';
import 'package:price_list/components/custom_button.dart';
import 'package:price_list/components/drop_list_model.dart';
import 'package:price_list/permission_handler.dart';
import 'package:price_list/screens/ware_list/ware_list_screen.dart';
import 'package:price_list/side_bar/setting/backup/backup_tools.dart';
import 'package:price_list/ware_provider.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingScreen extends StatefulWidget {
  static const String id = "/SettingScreen";

  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  late final SharedPreferences prefs;
  late String selectedValue;
  late WareProvider provider;
  bool showCostPrice = false;
  bool showQuantity = false;

  void storeInfoShop() {
    prefs.setBool("showCast", showCostPrice);
    prefs.setBool("showQuantity", showQuantity);
    provider.updateSetting(showCostPrice, showQuantity);

  }

  void getData()async {
    prefs = await SharedPreferences.getInstance();
    showCostPrice=provider.showCostPrice;
    showQuantity=provider.showQuantity;
  setState(() {});
  }

  @override
  void initState() {
    //selectedValue = kCurrencyList[0];
    getData();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    provider = Provider.of<WareProvider>(context, listen: false);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
     //storeInfoShop();
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                ///backup part
                Card(
                  margin: EdgeInsets.all(15),
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.blue)),
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
                            await BackupTools.createBackup(context);
                          },
                        ),
                        CustomButton(
                          text: "بارگیری فایل پشتیبان",
                          color: Colors.green,
                          onPressed: () async {
                            await storagePermission(context, Allow.storage);
                            await BackupTools.restoreBackup(context);
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                ///unit drop list
                // DropListItem(
                //     title: "واحد پول",
                //     selectedValue: selectedValue,
                //     listItem: kCurrencyList,
                //     onChange: (val) {
                //       selectedValue = val;
                //       setState(() {});
                //     }),
                SwitchItem(
                  title: "نمایش قیمت خرید",
                  value: showCostPrice,
                  onChange: (val) {
                    showCostPrice=val;
                    setState(() {});
                  },
                ),
                SwitchItem(
                  title: "نمایش موجودی",
                  value: showQuantity,
                  onChange: (val) {
                    showQuantity=val;
                    setState(() {});
                  },
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomButton(
                  text: "اعمال تغییرات",
                  onPressed: (){
                    storeInfoShop();
                Navigator.pushNamed(context, WareListScreen.id);

              }),
            )
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
    required this.value,
  });

  final String title;
  final bool value;
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
            Switch(value: value, onChanged: onChange),
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
