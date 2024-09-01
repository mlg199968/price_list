import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:price_list/components/action_button.dart';
import 'package:price_list/components/dynamic_button.dart';
import 'package:price_list/components/custom_text.dart';
import 'package:price_list/components/custom_textfield.dart';
import 'package:price_list/components/drop_list_model.dart';
import 'package:price_list/components/hide_keyboard.dart';
import 'package:price_list/constants/constants.dart';
import 'package:price_list/constants/consts_class.dart';
import 'package:price_list/constants/enums.dart';
import 'package:price_list/constants/utils.dart';
import 'package:price_list/model/shop.dart';
import 'package:price_list/constants/permission_handler.dart';
import 'package:price_list/screens/bug_screen/bug_list_screen.dart';
import 'package:price_list/screens/setting/backup/backup_tools.dart';
import 'package:price_list/screens/setting/backup/excel_tools.dart';
import 'package:price_list/screens/setting/currency_screen/currency_screen.dart';
import 'package:price_list/screens/side_bar/sidebar_panel.dart';
import 'package:price_list/services/hive_boxes.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../components/custom_alert.dart';
import '../../providers/user_provider.dart';

class SettingScreen extends StatefulWidget {
  static const String id = "/SettingScreen";

  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  late final SharedPreferences prefs;
  late String selectedValue;
  late UserProvider provider;
  bool showCostPrice = false;
  bool showQuantity = false;
  String selectedCurrency = kCurrencyList[0];
  String selectedFont = kFonts[0];
  String selectedPdfFont = kPdfFonts[0];
  String? backupDirectory;

  void storeInfoShop() {
    Shop dbShop = HiveBoxes.getShopInfo().values.first.copyWith(
          fontFamily: selectedFont,
          pdfFont: selectedPdfFont,
          backupDirectory: backupDirectory,
        );
    provider.getData(dbShop);
    HiveBoxes.getShopInfo().putAt(0, dbShop);
  }

  void getData() async {
    selectedFont = provider.fontFamily;
    selectedPdfFont = provider.pdfFont;
    backupDirectory = provider.backupDirectory;
    setState(() {});
  }

  @override
  void initState() {
    print("subscription");
    print(Provider.of<UserProvider>(context, listen: false)
        .subscription
        ?.toMap());
    print("isVip");
    print(!Provider.of<UserProvider>(context, listen: false).isVip);
    print("user level");
    print(Provider.of<UserProvider>(context, listen: false).userLevel);
    provider = Provider.of<UserProvider>(context, listen: false);

    getData();
    super.initState();
  }

  @override
  void dispose() {
    storeInfoShop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return HideKeyboard(
      child: Consumer<UserProvider>(builder: (context, userProvider, child) {
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
              alignment: Alignment.center,
              children: [
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: SingleChildScrollView(
                    child: SizedBox(
                      width: 450,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ///create backup
                          Wrap(
                            spacing: 3,
                            children: [
                              ///create backup full
                              FancyButtonTileVertical(
                                label: "پشتیبان گیری کامل",
                                subTitle: "پشتیبانگیری از داده و تصویر کالا ها",
                                buttonLabel: "پشتیبان گیری",
                                image: "assets/icons/full-backup.png",
                                icon: Icons.backup,
                                colors: [Colors.purpleAccent,Colors.pink],
                                onPress: () async {
                                  await BackupTools().createBackup(context,
                                      directory: backupDirectory);
                                },
                                ///share backup
                                extra: DynamicButton(
                                  label: "اشتراک گذاری",
                                  height: 18,
                                  borderRadius: 5,
                                  icon: Icons.share_rounded,
                                  bgColor: Colors.black38,
                                  iconColor: Colors.blueAccent,
                                  labelStyle: TextStyle(
                                      fontSize: 9, color: Colors.white),
                                  onPress: () async {
                                    await BackupTools().createBackup(context,
                                        directory: backupDirectory,
                                        isSharing: true);
                                  },
                                ),
                              ),
                              ///create backup database
                              FancyButtonTileVertical(
                                label: "پشتیبان گیری دیتابیس",
                                subTitle: "پشتیبانگیری فقط از داده ها، بدون فایل های گرافیکی",
                                buttonLabel: "پشتیبان گیری",
                                image: "assets/icons/db-backup.png",
                                icon: FontAwesomeIcons.database,

                                onPress: () async {
                                  await BackupTools(quickBackup: true).createBackup(context,
                                      directory: backupDirectory);
                                },
                                extra: DynamicButton(
                                  label: "اشتراک گذاری",
                                  height: 18,
                                  borderRadius: 5,
                                  icon: Icons.share_rounded,
                                  bgColor: Colors.black38,
                                  iconColor: Colors.blueAccent,
                                  labelStyle: TextStyle(
                                      fontSize: 9, color: Colors.white),
                                  onPress: () async {
                                    await BackupTools(quickBackup: true).createBackup(context,
                                        directory: backupDirectory,
                                        isSharing: true);
                                  },
                                ),
                              ),
                            ],
                          ),

                          Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ///load backup
                                FancyButtonTile(
                                  label: "بارگیری فایل پشتیبان",
                                  buttonLabel: "انتخاب",
                                  icon: FontAwesomeIcons.fileArrowUp,
                                  image: "assets/icons/folder.png",
                                  colors: [Colors.teal,Colors.cyan],
                                  onPress:  () async {
                                    await storagePermission(
                                        context, Allow.storage);
                                    if (context.mounted) {
                                      await storagePermission(
                                          context, Allow.externalStorage);
                                    }
                                    if (context.mounted) {
                                      await BackupTools.readZipFile(context);
                                    }
                                  },
                                ),

                              ],
                            ),
                          ),

                          ///choose directory
                          Container(
                              alignment: Alignment.centerRight,
                              padding: EdgeInsets.all(10),
                              child: CText(
                                "انتخاب مسیر ذخیره سازی فایل پشتیبان :",
                                color: Colors.white,
                                textDirection: TextDirection.rtl,
                              )),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                                margin: EdgeInsets.all(5),
                                padding: EdgeInsets.all(5),
                                alignment: Alignment.centerRight,
                                height: 40,
                                decoration: BoxDecoration(
                                    gradient: kBlackWhiteGradiant,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                        child: CText(backupDirectory ??
                                            "مسیری انتخاب نشده است")),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    ActionButton(
                                      label: "انتخاب",
                                      icon: Icons.folder_open_rounded,
                                      onPress: () async {
                                        await storagePermission(
                                            context, Allow.externalStorage);
                                        await storagePermission(
                                            context, Allow.storage);
                                        String? newDir =
                                            await BackupTools.chooseDirectory();
                                        if (newDir != null) {
                                          backupDirectory = newDir;
                                        }
                                        setState(() {});
                                      },
                                    ),
                                  ],
                                )),
                          ),
                          const Gap(10),

                          ///excel import an export part
                          Container(
                            height: 70,
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            margin: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 5),
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [Colors.green, Colors.teal]),
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              children: [
                                SizedBox(
                                    height: 40,
                                    child: Image(
                                      image:
                                          AssetImage("assets/images/excel.png"),
                                    )),
                                Gap(10),
                                Flexible(
                                    child: CText(
                                  "فایل اکسل",
                                  color: Colors.white,
                                  maxLine: 2,
                                )),
                                Expanded(child: SizedBox()),
                                DynamicButton(
                                  label: "export",
                                  iconSize: 14,
                                  icon: FontAwesomeIcons.fileExport,
                                  borderRadius: 5,
                                  bgColor: Colors.black,
                                  iconColor: Colors.redAccent,
                                  onPress: () async {
                                    await ExcelTools.createExcel(
                                        context, backupDirectory);
                                  },
                                ),
                                DynamicButton(
                                  label: "import",
                                  bgColor: Colors.black,
                                  borderRadius: 5,
                                  iconColor: Colors.greenAccent,
                                  iconSize: 14,
                                  icon: FontAwesomeIcons.fileImport,
                                  onPress: () async {
                                    await ExcelTools.readExcel(context);
                                  },
                                ),
                                DynamicButton(
                                  label: "share",
                                  height: 20,
                                  borderRadius: 5,
                                  icon: Icons.share_rounded,
                                  bgColor: Colors.black,
                                  iconColor: Colors.blueAccent,
                                  labelStyle: TextStyle(
                                      fontSize: 10, color: Colors.white),
                                  onPress: () async {
                                    String? path = await ExcelTools.createExcel(
                                        context, backupDirectory);
                                    if (path != null &&
                                        backupDirectory != null) {
                                      await Share.shareXFiles([XFile(path)]);
                                    } else {
                                      showSnackBar(context,
                                          "مسیر ذخیره سازی انتخاب نشده است!",
                                          type: SnackType.warning);
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                          const Gap(30),

                          ///currency unit
                          ButtonTile(
                              label: "تنظیمات ارز",
                              buttonLabel: "تنظیمات ارز",
                              onPress: () {
                                Navigator.pushNamed(context, CurrencyScreen.id)
                                    .then((value) {
                                  setState(() {});
                                });
                              }),

                          ///change font family entire app
                          DropListItem(
                            title: "نوع فونت نمایشی",
                            selectedValue: selectedFont,
                            listItem: kFonts,
                            dropWidth: 120,
                            onChange: (val) {
                              selectedFont = val;
                              userProvider.setFontFamily(val);
                              setState(() {});
                            },
                          ),

                          ///change pdf font family
                          DropListItem(
                            title: "فونت چاپ",
                            selectedValue: selectedPdfFont,
                            listItem: kPdfFonts,
                            dropWidth: 120,
                            onChange: (val) {
                              selectedPdfFont = val;
                              setState(() {});
                            },
                          ),

                          ///developer section
                          const CText(
                            "توسعه دهنده",
                            fontSize: 16,
                            color: Colors.white60,
                          ),
                          ButtonTile(
                              onPress: () {
                                Navigator.pushNamed(context, BugListScreen.id);
                              },
                              label: "error List",
                              buttonLabel: "see"),
                          ButtonTile(
                            label: "reset",
                            buttonLabel: "delete all",
                            onPress: () {
                              showDialog(
                                  context: context,
                                  builder: (_) => CustomAlert(
                                      title:
                                          "آیا از حذف تمام کالا ها مطمئن هستید؟",
                                      onYes: () async{
                                        deleteDirectory(await Address.waresImage());
                                        HiveBoxes.getWares().clear();
                                        showSnackBar(
                                            context, "انبار کالا خالی شد!",
                                            type: SnackType.success);
                                        Navigator.pop(context);
                                      },
                                      onNo: () {
                                        Navigator.pop(context);
                                      }));
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                ///*********************** show purchase part if not purchased **************************************
                if (!userProvider.isVip)
                  BlurryContainer(
                    padding: EdgeInsets.all(10),
                    color: Colors.black87.withOpacity(.7),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    //height: MediaQuery.of(context).size.height,
                    child: SizedBox(
                      width: 200,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Text(
                              "برای استفاده از این پنل نسخه کامل برنامه را فعال کنید.",
                              textDirection: TextDirection.rtl,
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          PurchaseButton(),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

///switch field
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
            Flexible(child: Text(title)),
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
            Flexible(child: Text(title)),
            Flexible(
              child: DropListModel(
                  elevation: 0,
                  width: dropWidth,
                  height: 30,
                  listItem: listItem,
                  selectedValue: selectedValue,
                  onChanged: onChange),
            ),
          ],
        ),
      ),
    );
  }
}

///text field
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
            Flexible(child: Text(label)),
            CustomTextField(
                label: inputLabel,
                controller: controller,
                width: width,
                height: 35,
                textFormat: TextFormatter.price,
                currency: "تومان",
                onChange: onChange)
          ],
        ),
      ),
    );
  }
}

///Button tile
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
            Flexible(child: Text(label)),
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

///Fancy Button Tile
class FancyButtonTile extends StatelessWidget {
  const FancyButtonTile({
    Key? key,
    required this.onPress,
    this.width = 150,
    required this.label,
    required this.buttonLabel,
    this.extra,
    this.icon,
    this.bgColor=Colors.black54,
    this.iconColor,
    this.height=70,
    this.iconSize,
    this.borderRadius=10,
    this.direction=TextDirection.ltr,
    this.margin=const EdgeInsets.symmetric(vertical: 2),
    this.padding=const EdgeInsets.only(left: 10),
    this.disable=false,
    this.labelStyle,
    this.borderColor,
    this.colors=const[Colors.blue,Colors.deepPurpleAccent],
    this.image,
    this.subTitle,
    this.imagePadding=const EdgeInsets.all(8),
  }) : super(key: key);

  final String label;
  final String? subTitle;
  final String buttonLabel;
  final VoidCallback onPress;
  final Widget? extra;
  final IconData? icon;
  final Color bgColor;
  final List<Color> colors;
  final Color? iconColor;
  final double height;
  final double? width;
  final double? iconSize;
  final double borderRadius;
  final TextDirection direction;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final EdgeInsets? imagePadding;
  final bool disable;
  final TextStyle? labelStyle;
  final Color? borderColor;
  final String? image;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Row(

        children: [
          if(image!=null)
          Container(
              height: height,
              padding: imagePadding,
              child: Image(
                image:
                AssetImage(image!),
              )),
          Gap(10),
          Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CText(label,color: Colors.white,),
              if(subTitle!=null)
              CText(subTitle,color: Colors.white54,fontSize: 10,),
            ],
          )),
          SizedBox(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DynamicButton(
                onPress: onPress,
                label: buttonLabel,
                padding: EdgeInsets.symmetric(horizontal: 8),
                borderRadius: borderRadius,
                bgColor: bgColor ,
                icon: icon,
                iconColor: iconColor ?? colors.last,
                borderColor: borderColor ?? colors.last,
                labelStyle: TextStyle(fontSize: 13,color: Colors.white),
              ),
              SizedBox(
                child: extra,
              ),
            ],
          ),
        ],
      ),
    );
  }
}


///Fancy Button Tile vertical
class FancyButtonTileVertical extends StatelessWidget {
  const FancyButtonTileVertical({
    Key? key,
    required this.onPress,
    required this.label,
    required this.buttonLabel,
    this.extra,
    this.icon,
    this.bgColor=Colors.black54,
    this.iconColor,
    this.height=200,
    this.width = 150,
    this.iconSize,
    this.borderRadius=10,
    this.direction=TextDirection.ltr,
    this.margin=const EdgeInsets.symmetric(vertical: 2,horizontal: 4),
    this.padding=const EdgeInsets.all(8),
    this.disable=false,
    this.labelStyle,
    this.borderColor,
    this.colors=const[Colors.blue,Colors.deepPurpleAccent],
    this.image,
    this.subTitle,
  }) : super(key: key);

  final String label;
  final String? subTitle;
  final String buttonLabel;
  final VoidCallback onPress;
  final Widget? extra;
  final IconData? icon;
  final Color bgColor;
  final List<Color> colors;
  final Color? iconColor;
  final double height;
  final double? width;
  final double? iconSize;
  final double borderRadius;
  final TextDirection direction;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final bool disable;
  final TextStyle? labelStyle;
  final Color? borderColor;
  final String? image;
  @override
  Widget build(BuildContext context) {
    return Container(
      // height: height,
      width: width,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if(image!=null)
          SizedBox(
            height: 100,
              child: Image(
                image:
                AssetImage(image!),
              )),
          const Gap(10),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
          CText(label,color: Colors.white,),
          if(subTitle!=null)
          CText(subTitle,color: Colors.white54,fontSize: 10,),
                      ],
                    ),
          const Gap(10),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DynamicButton(
                onPress: onPress,
                label: buttonLabel,
                padding: EdgeInsets.symmetric(horizontal: 8),
                borderRadius: borderRadius,
                bgColor: bgColor ,
                icon: icon,
                iconColor: iconColor ?? colors.last,
                borderColor: borderColor ?? colors.last,
                labelStyle: TextStyle(fontSize: 13,color: Colors.white),
              ),
              SizedBox(
                child: extra,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
