import 'package:flutter/material.dart';
import 'package:price_list/components/action_button.dart';
import 'package:price_list/components/custom_text.dart';
import 'package:price_list/components/custom_textfield.dart';
import 'package:price_list/components/drop_list_model.dart';
import 'package:price_list/components/hide_keyboard.dart';
import 'package:price_list/constants/constants.dart';
import 'package:price_list/model/shop.dart';
import 'package:price_list/permission_handler.dart';
import 'package:price_list/screens/bug_screen/bug_list_screen.dart';
import 'package:price_list/screens/setting/backup/backup_tools.dart';
import 'package:price_list/screens/side_bar/sidebar_panel.dart';
import 'package:price_list/providers/ware_provider.dart';
import 'package:price_list/services/hive_boxes.dart';

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
  String selectedCurrency=kCurrencyList[0];
  String selectedFont = kFonts[0];
  String? backupDirectory;

  void storeInfoShop() {
    Shop dbShop=HiveBoxes.getShopInfo().values.first.copyWith(
      showCost: showCostPrice,
      showQuantity: showQuantity,
      fontFamily: selectedFont,
      currency: selectedCurrency,
      backupDirectory: backupDirectory,
    );
    provider.getData(dbShop);
    HiveBoxes.getShopInfo().putAt(0, dbShop);
  }

  void getData()async {
    prefs = await SharedPreferences.getInstance();
    showCostPrice=provider.showCostPrice;
    showQuantity=provider.showQuantity;
    selectedFont=provider.fontFamily;
    selectedCurrency=provider.currency;
    backupDirectory=provider.backupDirectory;
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
     storeInfoShop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return HideKeyboard(
      child: Consumer<WareProvider>(
        builder: (context,wareProvider,child) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              title: const Text("تنظیمات"),
            ),
            extendBodyBehindAppBar: true,
            body: Container(
              padding: EdgeInsets.only(top: 80),
              alignment: Alignment.topCenter,
              decoration: BoxDecoration(gradient: kMainGradiant),
              child: Stack(
                children: [
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: SingleChildScrollView(
                      child: SizedBox(
                        width: 450,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Flexible(
                                    child: ActionButton(
                                      label: "پشتیبان گیری",
                                      icon: Icons.backup,
                                      bgColor: Colors.red.withRed(250),
                                      onPress: () async {
                                        await BackupTools.createBackup(context,directory: backupDirectory);
                                      },
                                    ),
                                  ),
                                  ActionButton(
                                    label: "بارگیری فایل پشتیبان",
                                    icon: Icons.settings_backup_restore,
                                    bgColor: Colors.teal,
                                    onPress: () async {
                                      await storagePermission(
                                          context, Allow.externalStorage);
                                      await storagePermission(context, Allow.storage);

                                        // await BackupTools.restoreBackup(context);
                                        await BackupTools.readZipFile(context);
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerRight,
                                padding: EdgeInsets.all(10),
                                child: CText("انتخاب مسیر ذخیره سازی فایل پشتیبان :",color: Colors.white,textDirection: TextDirection.rtl,)),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                margin: EdgeInsets.all(5),
                                padding: EdgeInsets.all(5),
                                alignment: Alignment.centerRight,
                                height: 40,
                                decoration: BoxDecoration(gradient: kBlackWhiteGradiant,borderRadius: BorderRadius.circular(20)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(child: CText(backupDirectory ?? "مسیری انتخاب نشده است")),
                                      SizedBox(width: 8,),
                                      ActionButton(
                                        label: "انتخاب",
                                        icon: Icons.folder_open_rounded,
                                        onPress: ()async{
                                          await storagePermission(context, Allow.externalStorage);
                                          await storagePermission(context, Allow.storage);
                                          String? newDir=await BackupTools.chooseDirectory();
                                          if(newDir!=null) {
                                            backupDirectory = newDir;
                                          }
                                          setState(() {});
                                        },),
                                    ],
                                  )),
                            ),
                            SizedBox(height: 30,),
                            ///currency unit
                            DropListItem(
                                title: "واحد پول",
                                selectedValue: selectedCurrency,
                                listItem: kCurrencyList,
                                onChange: (val) {
                                  selectedCurrency = val;
                                  setState(() {});
                                }),
                            SwitchItem(
                              title: "نمایش قیمت خرید",
                              value: showCostPrice,
                              onChange: (val) {
                                showCostPrice=val;
                                provider.updateSetting(val, showQuantity);
                                setState(() {});
                              },
                            ),
                            SwitchItem(
                              title: "نمایش موجودی",
                              value: showQuantity,
                              onChange: (val) {
                                showQuantity=val;
                                provider.updateSetting(showCostPrice, val);
                                setState(() {});
                              },
                            ),

                            ///change font family entire app
                            DropListItem(
                              title: "نوع فونت نمایشی",
                              selectedValue: selectedFont,
                              listItem: kFonts,
                              dropWidth: 120,
                              onChange: (val) {
                                selectedFont = val;
                                wareProvider.getFontFamily(val);
                                setState(() {});
                              },
                            ),

                            ///developer section
                            const CText(
                              "توسعه دهنده",
                              fontSize: 16,
                              color: Colors.white60,
                            ),
                            ButtonTile(onPress: (){
                              Navigator.pushNamed(context, BugListScreen.id);
                            }, label: "error List", buttonLabel:"see"),
                          ],
                        ),
                      ),
                    ),
                  ),
///*********************** show purchase part if not purchased **************************************
                  if(!wareProvider.isVip)
                      Container(
                    padding: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height ,
                    //height: MediaQuery.of(context).size.height,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Text(
                            "برای استفاده از این پنل نسخه پرو برنامه را فعال کنید.",
                            textDirection: TextDirection.rtl,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 18),

                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        PurchaseButton(),
                      ],
                    ),
                    color: Colors.black87.withOpacity(.7),
                  ),
                ],
              ),
            ),
          );
        }
      ),
    );
  }
}

///switch field
class SwitchItem extends StatelessWidget {
  const SwitchItem({
    super.key,
    required this.title,
    required this.onChange, required this.value,
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

///drop list field
class DropListItem extends StatelessWidget {
  const DropListItem({
    super.key,
    required this.title,
    required this.selectedValue,
    required this.listItem,
    required this.onChange,
    this.dropWidth = 80,
  });

  final String title;
  final String selectedValue;
  final List<String> listItem;
  final void Function(String) onChange;
  final double dropWidth;

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
                width: dropWidth,
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

///text field field
class InputItem extends StatelessWidget {
  const InputItem(
      {Key? key,
        required this.controller,
        this.onChange,
        this.width = 150,
        required this.label,
        required this.inputLabel})
      : super(key: key);

  final String label;
  final String inputLabel;
  final TextEditingController controller;
  final double width;
  final Function(String val)? onChange;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            CustomTextField(
                label: inputLabel,
                controller: controller,
                width: width,
                textFormat: TextFormatter.number,
                onChange: onChange)
          ],
        ),
      ),
    );
  }
}

///text field field
class ButtonTile extends StatelessWidget {
  const ButtonTile({
    Key? key,
    required this.onPress,
    this.width = 150,
    required this.label,
    required this.buttonLabel,
    this.extra,
  }) : super(key: key);

  final String label;
  final String buttonLabel;
  final VoidCallback onPress;
  final double width;
  final Widget? extra;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            SizedBox(
              child: extra,
            ),
            ElevatedButton(
              onPressed: onPress,
              child: Text(buttonLabel),
            ),
          ],
        ),
      ),
    );
  }
}