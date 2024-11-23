import 'dart:io';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:price_list/components/action_button.dart';
import 'package:price_list/components/dynamic_button.dart';
import 'package:price_list/components/custom_text.dart';
import 'package:price_list/components/drop_list_model.dart';
import 'package:price_list/components/hide_keyboard.dart';
import 'package:price_list/constants/constants.dart';
import 'package:price_list/constants/consts_class.dart';
import 'package:price_list/constants/enums.dart';
import 'package:price_list/constants/utils.dart';
import 'package:price_list/model/shop.dart';
import 'package:price_list/constants/permission_handler.dart';
import 'package:price_list/model/ware_bool.dart';
import 'package:price_list/providers/ware_provider.dart';
import 'package:price_list/screens/bug_screen/bug_list_screen.dart';
import 'package:price_list/screens/setting/services/backup_tools.dart';
import 'package:price_list/screens/setting/services/excel_tools.dart';
import 'package:price_list/screens/setting/currency_screen/currency_screen.dart';
import 'package:price_list/screens/setting/widgets/button_field.dart';
import 'package:price_list/screens/setting/widgets/fancy_button.dart';
import 'package:price_list/screens/side_bar/sidebar_panel.dart';
import 'package:price_list/screens/ware_list/services/ware_tools.dart';
import 'package:price_list/services/hive_boxes.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../components/check_button.dart';
import '../../components/custom_alert.dart';
import '../../components/time/time.dart';
import '../../components/title_button.dart';
import '../../model/ware.dart';
import '../../providers/user_provider.dart';
import 'widgets/drop_list_field.dart';
import 'widgets/number_input_field.dart';

class SettingScreen extends StatefulWidget {
  static const String id = "/SettingScreen";

  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final TextEditingController imageQualityController = TextEditingController();
  final TextEditingController imageWidthController = TextEditingController();
  late final SharedPreferences prefs;
  late String selectedValue;
  late UserProvider provider;
  bool showCostPrice = false;
  bool showQuantity = false;
  String selectedCurrency = kCurrencyList[0];
  String selectedFont = kFonts[0];
  String selectedPdfFont = kPdfFonts[0];
  String? backupDirectory;
  ///filter declaration
  WareBool exportMap = WareBool(des: true, cost: true, sale: true, sale2: true, sale3: true, count: true, serial: true);
  late final List<Ware> wareList;
  List<Ware>? exportList;
  DateTime? modifiedDate;
  DateTime? createdDate;
  bool activeExportFilter=false;
  bool activeImportFilter=false;
  String selectedCategory = "همه";
  bool justImportLatestWare = false;
  ///save
  void storeInfoShop() {
    Shop dbShop = HiveBoxes.getShopInfo().values.first.copyWith(
        fontFamily: selectedFont,
        pdfFont: selectedPdfFont,
        backupDirectory: backupDirectory,
        imageQuality: int.tryParse(imageQualityController.text) ?? 30);
    provider.getData(dbShop);
    HiveBoxes.getShopInfo().putAt(0, dbShop);
  }

  void getData() async {
    selectedFont = provider.fontFamily;
    selectedPdfFont = provider.pdfFont;
    backupDirectory = provider.backupDirectory;
    imageQualityController.text = provider.imageQuality.toString();
    setState(() {});
  }

  @override
  void initState() {
    wareList=HiveBoxes.getWares().values.toList();
    provider = Provider.of<UserProvider>(context, listen: false);
    getData();
    super.initState();
  }
  ///update export list
  void updateExportList() {
    if (activeExportFilter) {
      exportList = WareTools.filterForExport(wareList,
          exportMap: exportMap,
          category: selectedCategory,
          modifiedDate: modifiedDate,
          createDate: createdDate);
    }else{
      exportList=wareList;
    }
    setState(() {});
  }

  ///custom check box model
  Widget cCheckBox(String label, bool isCheck, Function(bool val) onChange) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: CheckButton(
          label: label,
          value: isCheck,
          onChange: (val) {
            onChange(val!);
            updateExportList();
            setState(() {});
          }),
    );
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
                      width: 500,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ///create backup customization
                          FilterField(
                            title: "فیلتر فایل خروجی پشتیبان",
                            isActive: activeExportFilter,
                            onChange: (value) {
                              activeExportFilter = value;
                              setState(() {});
                              updateExportList();
                            },
                            children: [
                                  Divider(),
                                  Row(
                                    children: [
                                      CText("انتخاب گروه:",),
                                      DropListModel(
                                        width: 200,
                                        height: 25,
                                        elevation: .2,
                                        selectedValue: selectedCategory,
                                        listItem: ["همه",...context.watch<WareProvider>().groupList],
                                        onChanged: (value) {
                                          selectedCategory= value;
                                          updateExportList();
                                          setState(() {});
                                        },
                                      ),
                                    ],
                                  ),
                                  ///create date filter
                                  TitleButton(
                                    title: "این تاریخ ثبت به بعد:",
                                    value: createdDate != null ? createdDate!.toPersianDate() : "مشخص نشده",
                                    onPress: () async {
                                      Jalali? picked = await PickTime.chooseDate(context);
                                      if (picked != null) {
                                        setState(() {
                                          createdDate = picked.toDateTime();
                                          updateExportList();
                                        });
                                      }
                                    },
                                  ),
                                  ///modified date filter
                                  TitleButton(
                                    title: "این تاریخ ویرایش به بعد:",
                                    value: modifiedDate != null ? modifiedDate!.toPersianDate() : "مشخص نشده",
                                    onPress: () async {
                                      Jalali? picked = await PickTime.chooseDate(context);
                                      if (picked != null) {
                                        setState(() {
                                          modifiedDate = picked.toDateTime();
                                          updateExportList();
                                        });
                                      }
                                    },
                                  ),
                                  Gap(20),
                                  Wrap(
                                    direction: Axis.horizontal,
                                    children: [
                                      cCheckBox("قیمت خرید", exportMap.cost, (val) => exportMap.cost = val),
                                      cCheckBox("قیمت فروش", exportMap.sale, (val) => exportMap.sale = val),
                                      cCheckBox("قیمت فروش2", exportMap.sale2, (val) => exportMap.sale2 = val),
                                      cCheckBox("قیمت فروش3", exportMap.sale3, (val) => exportMap.sale3 = val),
                                      cCheckBox("تعداد", exportMap.count, (val) => exportMap.count = val),
                                      cCheckBox("توضیحات", exportMap.des, (val) => exportMap.des = val),
                                      cCheckBox("سریال", exportMap.serial, (val) => exportMap.serial = val),
                                    ],
                                  ),
                              ],

                          ),
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
                                colors: [Colors.purpleAccent, Colors.pink],
                                onPress: () async {
                                  await BackupTools().createBackup(context,
                                      wareList: exportList,
                                      directory: backupDirectory);
                                },

                                ///share backup
                                extra: Platform.isAndroid || Platform.isIOS
                                    ? DynamicButton(
                                        label: "اشتراک گذاری",
                                        height: 18,
                                        borderRadius: 5,
                                        icon: Icons.share_rounded,
                                        bgColor: Colors.black38,
                                        iconColor: Colors.blueAccent,
                                        labelStyle: TextStyle(
                                            fontSize: 9, color: Colors.white),
                                        onPress: () async {
                                          await BackupTools().createBackup(
                                              context,
                                              wareList: exportList,
                                              directory: backupDirectory,
                                              isSharing: true);
                                        },
                                      )
                                    : null,
                              ),

                              ///create backup database
                              FancyButtonTileVertical(
                                label: "پشتیبان گیری دیتابیس",
                                subTitle:
                                    "پشتیبانگیری فقط از داده ها، بدون فایل های گرافیکی",
                                buttonLabel: "پشتیبان گیری",
                                image: "assets/icons/db-backup.png",
                                icon: FontAwesomeIcons.database,
                                onPress: () async {
                                  await BackupTools(quickBackup: true)
                                      .createBackup(context,
                                          wareList: exportList,
                                          directory: backupDirectory);
                                },
                                extra: (Platform.isAndroid || Platform.isIOS)
                                    ? DynamicButton(
                                        label: "اشتراک گذاری",
                                        height: 18,
                                        borderRadius: 5,
                                        icon: Icons.share_rounded,
                                        bgColor: Colors.black38,
                                        iconColor: Colors.blueAccent,
                                        labelStyle: TextStyle(
                                            fontSize: 9, color: Colors.white),
                                        onPress: () async {
                                          await BackupTools(quickBackup: true)
                                              .createBackup(context,
                                                  wareList: exportList,
                                                  directory: backupDirectory,
                                                  isSharing: true);
                                        },
                                      )
                                    : null,
                              ),
                            ],
                          ),
                          ///load backup
                          Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ///import backup customization
                                FilterField(
                                  title: "فیلتر درون ریزی پشتیبان",
                                  isActive: activeImportFilter,
                                  onChange: (value) {
                                    activeImportFilter = value;
                                    setState(() {});
                                    updateExportList();
                                  },
                                  children: [
                                    cCheckBox("کالا هایی که تاریخ آن ها از تاریخ فعلی کالا بالاتر است را وارد کن", justImportLatestWare,
                                            (val) {
                                      justImportLatestWare=val;
                                      setState(() {});

                                    })
                                  ],

                                ),
                                ///load backup
                                FancyButtonTile(
                                  label: "بارگیری فایل پشتیبان",
                                  buttonLabel: "انتخاب",
                                  icon: FontAwesomeIcons.fileArrowUp,
                                  image: "assets/icons/import-file.png",
                                  colors: [Colors.teal, Colors.cyan],
                                  onPress: () async {
                                    await storagePermission(
                                        context, Allow.storage);
                                    if (context.mounted) {
                                      await storagePermission(
                                          context, Allow.externalStorage);
                                    }
                                    if (context.mounted) {
                                      await BackupTools(justImportLatestWares:activeImportFilter && justImportLatestWare).readZipFile(context);
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),

                          ///choose directory
                          CText(
                            "انتخاب مسیر ذخیره سازی فایل پشتیبان :",
                            color: Colors.white,
                            textDirection: TextDirection.rtl,
                          ),
                          Container(
                              margin: EdgeInsets.all(5),
                              padding: EdgeInsets.all(5),
                              alignment: Alignment.centerRight,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.8),
                                  gradient: kBlackWhiteGradiant,
                                  borderRadius: BorderRadius.circular(20)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Image(image: AssetImage("assets/icons/folder.png")),
                                  Flexible(
                                      child: CText(backupDirectory ??
                                          "مسیری انتخاب نشده است")),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  ActionButton(
                                    label: "انتخاب",
                                    icon: Icons.folder_open_rounded,
                                    bgColor: Colors.black38,
                                    borderColor: Colors.orangeAccent,
                                    iconColor: Colors.orangeAccent,
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
                                if (Platform.isAndroid || Platform.isIOS)
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
                                      String? path =
                                          await ExcelTools.createExcel(
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
                          NumberInputItem(
                              controller: imageQualityController,
                              label: "کیفیت تصویر",
                              inputLabel: "1 تا 100"),

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
                                      onYes: () async {
                                        deleteDirectory(
                                            await Address.waresImage());
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

///filter fields
class FilterField extends StatelessWidget {
  const FilterField({super.key,this.isActive=false, required this.onChange, required this.children, required this.title});
 final String title;
final bool isActive;
final Function(bool value) onChange;
final List<Widget> children;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.decelerate,
      alignment: Alignment.center,
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color:isActive? Colors.white.withOpacity(0.8):Colors.transparent,
        gradient: kBlackWhiteGradiant,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white60),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ///filter section header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(FontAwesomeIcons.filter,size: 19,color: isActive?Colors.teal:Colors.white70,),
              Flexible(
                child: CText(
                  title,
                  fontSize: 14,
                  color: isActive?null:Colors.white,
                ),
              ),
              Transform.scale(
                scale: 0.7,
                child: Switch(
                  value: isActive,
                  onChanged: onChange,
                ),
              ),
            ],
          ),
          if (isActive)
          Divider(),
          if (isActive) ...children,
        ],
      ),
    );
  }
}










