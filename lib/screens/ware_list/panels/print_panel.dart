import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:price_list/components/action_button.dart';
import 'package:price_list/components/check_button.dart';
import 'package:price_list/components/counter_textfield.dart';
import 'package:price_list/components/custom_dialog.dart';
import 'package:price_list/components/custom_button.dart';
import 'package:price_list/components/custom_text.dart';
import 'package:price_list/components/drop_list_model.dart';
import 'package:price_list/components/pdf/pdf_api.dart';
import 'package:price_list/components/pdf/pdf_ware_list_api.dart';
import 'package:price_list/constants/constants.dart';
import 'package:price_list/constants/enums.dart';
import 'package:price_list/constants/utils.dart';
import 'package:price_list/model/ware.dart';
import 'package:price_list/providers/ware_provider.dart';
import 'package:price_list/screens/setting/services/backup_tools.dart';
import 'package:price_list/screens/ware_list/services/ware_tools.dart';
import 'package:price_list/screens/ware_list/sort_ware_screen.dart';
import 'package:price_list/services/hive_boxes.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path/path.dart' as path;
import '../../../providers/user_provider.dart';

class PrintPanel extends StatefulWidget {
  static const String id = "/WareActionPanel";
  const PrintPanel({Key? key, required this.wares, required this.subGroup})
      : super(key: key);
  final List<Ware> wares;
  final String subGroup;

  @override
  State<PrintPanel> createState() => _PrintPanelState();
}

class _PrintPanelState extends State<PrintPanel> {
  final TextEditingController textScaleController =
      TextEditingController(text: "1");
  late String subGroup;
  String pdfFont = kPdfFonts[0];
  double get textScale => stringToDouble(textScaleController.text);
  String printType = kPrintTypeList[0];
  bool showHeader = true;
  bool showFooter = true;
  bool separateGroups = true;
  Map<String, bool> showMap = {
    "des": false,
    "cost": false,
    "sale": true,
    "sale2": false,
    "sale3": false,
    "count": false,
    "serial": false,
  };
  String sortItem = kSortList[0];

  /// pdf type file
  Future<File> pdfTypeFile() async {
    List<Ware> filteredList =
        WareTools.filterList(widget.wares, "", sortItem, subGroup);
    if (separateGroups) {
      filteredList = WareTools.sortGroups(filteredList);
    }

    final pdfWareListApi = PdfWareListApi(context, filteredList,
        scale: textScale,
        show: showMap,
        showFooter: showFooter,
        showHeader: showHeader,
        pdfFont: pdfFont);
    late File file;
    if (printType == "اتیکت") {
      file = await pdfWareListApi.generateTicketWareList();
    } else if (printType == "کاستوم") {
      file = await pdfWareListApi.generateCustomWareList();
    } else if (printType == "کاتالوگ") {
      file = await pdfWareListApi.generateCatalog();
    }  else if (printType == "کاتالوگ2") {
      file = await pdfWareListApi.generateCatalog2();
    } else {
      file = await pdfWareListApi.generateSimpleWareList();
    }
    return file;
  }

  @override
  void initState() {
    subGroup = widget.subGroup;
    pdfFont = HiveBoxes.getShopInfo().values.first.pdfFont ?? kPdfFonts[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ///custom check box model
    Widget cCheckBox(String label, bool isCheck, Function(bool val) onChange) {
      return Padding(
        padding: const EdgeInsets.all(2.0),
        child: CheckButton(
            label: label,
            value: isCheck,
            onChange: (val) {
              onChange(val!);
              setState(() {});
            }),
      );
    }

    ///
    return CustomDialog(
        vip: !Provider.of<UserProvider>(context, listen: false).isVip,
        contentPadding: EdgeInsets.all(8),
        opacity: 1,
        height: 600,
        title: "",
        topTrail: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: CustomButton(
            width: 100,
            height: 25,
            text: "پشتیبان گیری",
            icon: Icon(
              Icons.backup,
              size: 15,
              color: Colors.white,
            ),
            color: Colors.red,
            radius: 20,
            onPressed: () async {
              String? backupDirectory =
                  Provider.of<UserProvider>(context, listen: false)
                      .backupDirectory;
              await BackupTools(quickBackup: true).createBackup(context,
                  directory: backupDirectory);
              Navigator.pop(context);
            },
          ),
        ),

        ///buttons
        actions: [
          ///pdf print
          Flexible(
            child: CustomButton(
                width: 100,
                height: 30,
                text: "چاپ",
                radius: 10,
                icon: Icon(
                  FontAwesomeIcons.filePdf,
                  color: Colors.white,
                  size: 18,
                ),
                color: Colors.red,
                onPressed: () async {
                  File file = await pdfTypeFile();
                  PdfApi.openFile(file);
                }),
          ),
          Gap(5),

          ///share button
          Flexible(
            child: CustomButton(
              width: 150,
              height: 30,
              text: "اشتراک گذاری",
              radius: 10,
              icon: Icon(
                Icons.share_rounded,
                color: Colors.white,
              ),
              onPressed: () async {
                File file = await pdfTypeFile();
                if(Platform.isAndroid || Platform.isIOS) {
                  await Share.shareXFiles([XFile(file.path)]);
                }else{
                  String? directory=await chooseDirectory();
                  if(directory!=null){
                    String name = path.basename(file.path);
                  await file.copy("$directory\\$name");
                  };
                }
              },
            ),
          ),
        ],
        child: Consumer<WareProvider>(builder: (context, wareProvider, child) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ///dropDown list for Group Select
                if (subGroup != "selected")
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text("انتخاب گروه کالا"),
                      const Gap(10),
                      Flexible(
                        child: DropListModel(
                          selectedValue: subGroup,
                          height: 40,
                          listItem: ["همه", ...wareProvider.groupList],
                          onChanged: (val) {
                            subGroup = val;
                            setState(() {});
                          },
                        ),
                      ),
                    ],
                  ),
                Gap(10),

                ///print type
                Row(
                  children: [
                    const Text("قالب چاپ"),
                    Gap(10),

                    ///dropDown list for print type Select
                    Flexible(
                      child: DropListModel(
                        selectedValue: printType,
                        height: 40,
                        listItem: kPrintTypeList,
                        onChanged: (val) {
                          printType = val;
                          setState(() {});
                        },
                      ),
                    ),
                  ],
                ),
                Wrap(
                  children: [
                    cCheckBox(
                        "نمایش عنوان", showHeader, (val) => showHeader = val),
                    cCheckBox(
                        "نمایش پاورقی", showFooter, (val) => showFooter = val),
                  ],
                ),
                const Divider(),

                ///ticket print type check boxes
                if (printType == kPrintTypeList[2])
                  cCheckBox("سریال", showMap["serial"]!,
                          (val) => showMap["serial"] = val),
                ///Catalog print type check boxes
                if (printType == kPrintTypeList[3])
                  Wrap(
                    children: [
                      cCheckBox("توضیحات", showMap["des"]!,
                          (val) => showMap["des"] = val),
                      cCheckBox("قیمت فروش", showMap["sale"]!,
                              (val) => showMap["sale"] = val),
                    ],
                  ),
                ///custom print type check boxes
                if (printType == kPrintTypeList[0])
                  Wrap(
                    direction: Axis.horizontal,
                    children: [
                      cCheckBox("قیمت خرید", showMap["cost"]!,
                          (val) => showMap["cost"] = val),
                      cCheckBox("قیمت فروش", showMap["sale"]!,
                          (val) => showMap["sale"] = val),
                      cCheckBox("قیمت فروش2", showMap["sale2"]!,
                          (val) => showMap["sale2"] = val),
                      cCheckBox("قیمت فروش3", showMap["sale3"]!,
                          (val) => showMap["sale3"] = val),
                      cCheckBox("تعداد", showMap["count"]!,
                          (val) => showMap["count"] = val),
                      cCheckBox("توضیحات", showMap["des"]!,
                          (val) => showMap["des"] = val),
                      cCheckBox("سریال", showMap["serial"]!,
                          (val) => showMap["serial"] = val),
                    ],
                  ),
                const Gap(30),

                ///print font
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("فونت چاپ"),
                    const Gap(10),
                    Flexible(
                      child: DropListModel(
                        selectedValue: pdfFont,
                        height: 40,
                        listItem: kPdfFonts,
                        onChanged: (val) {
                          pdfFont = val;
                          setState(() {});
                        },
                      ),
                    ),
                  ],
                ),

                ///sort
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("ترتیب براساس"),
                    const Gap(10),
                    Flexible(
                      child: DropListModel(
                          listItem: kSortList,
                          selectedValue: sortItem,
                          onChanged: (val) {
                            sortItem = val;
                            setState(() {});
                          }),
                    ),
                    if(sortItem==SortItem.custom.value)
                    ActionButton(
                      height: 25,
                      label: "ترتیب بندی",
                      icon: CupertinoIcons.sort_down_circle,
                      bgColor: Colors.black87,
                      borderColor: Colors.indigo,
                      iconColor: Colors.blueAccent,
                      labelStyle: TextStyle(fontSize: 10,color: Colors.white),
                      onPress: (){
                        Navigator.pushNamed(context, SortWareScreen.id,arguments: widget.wares);
                      },
                    )
                  ],
                ),
                CheckButton(
                    label: "نمایش دسته ای",
                    value: separateGroups,
                    onChange: (val) {
                      separateGroups = val!;
                      setState(() {});
                    }),
                const Gap(10),

                ///text scale
                Row(
                  children: [
                    const CText("بزرگنمایی متن"),
                    Gap(10),
                    Flexible(
                      child: SizedBox(
                        width: 120,
                        height: 45,
                        child: CounterTextfield(
                          label: "اندازه متن",
                          controller: textScaleController,
                          step: .1,
                          minNum: .5,
                          maxNum: 3,
                          borderRadius: 10,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }));
  }
}
