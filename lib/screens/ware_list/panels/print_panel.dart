import 'dart:io';

import 'package:flutter/cupertino.dart' show CupertinoCheckbox;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:price_list/components/counter_textfield.dart';
import 'package:price_list/components/custom_dialog.dart';
import 'package:price_list/components/custom_button.dart';
import 'package:price_list/components/custom_text.dart';
import 'package:price_list/components/drop_list_model.dart';
import 'package:price_list/components/pdf/pdf_api.dart';
import 'package:price_list/components/pdf/pdf_ware_list_api.dart';
import 'package:price_list/constants/constants.dart';
import 'package:price_list/constants/utils.dart';
import 'package:price_list/model/ware_hive.dart';
import 'package:price_list/providers/ware_provider.dart';
import 'package:price_list/screens/setting/backup/backup_tools.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class PrintPanel extends StatefulWidget {
  static const String id = "/WareActionPanel";
  const PrintPanel(
      {Key? key, required this.wares, required this.subGroup})
      : super(key: key);
  final List<WareHive> wares;
  final String subGroup;

  @override
  State<PrintPanel> createState() => _PrintPanelState();
}

class _PrintPanelState extends State<PrintPanel> {
  final TextEditingController textScaleController = TextEditingController(text: "1");
  late String subGroup;
  double get textScale => stringToDouble(textScaleController.text);
  String printType = kPrintTypeList[0];
  bool showHeader=true;
  bool showFooter=true;
  Map<String,bool> showMap={
  "des":false,
  "cost":false,
  "sale":true,
  "count":false,
  "serial":false,
  };
  /// pdf type file
  Future<File> pdfTypeFile() async {
    List<WareHive> filteredList = [];
    for (WareHive ware in widget.wares) {
      if (ware.groupName == subGroup || subGroup == "همه" || subGroup == "selected") {
        filteredList.add(ware);
      }
    }
    final pdfWareListApi=PdfWareListApi(context, filteredList,showFooter: showFooter,showHeader: showHeader);
    late File file;
    if (printType == "اتیکت") {
      file = await pdfWareListApi
          .generateTicketWareList(scale: textScale);
    }
    else if (printType == "کاستوم") {
      file =await pdfWareListApi
          .generateCustomWareList(scale: textScale,show: showMap);
    }
    else if (printType == "کاتالوگ") {
      file = await pdfWareListApi
          .generateCatalog(scale: textScale,show: showMap);
    }
    else {
      file = await pdfWareListApi
          .generateSimpleWareList(scale: textScale);
    }
    return file;
  }
  @override
  void initState() {
    subGroup = widget.subGroup;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    ///custom check box model
    Widget cCheckBox(String label,bool isCheck,Function onChange){
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CText(label,fontSize: 11,color: Colors.black45,),
          CupertinoCheckbox(value: isCheck,
              onChanged: (val){
            onChange(val);
              setState(() {});}),
        ],
      );
    }
    ///
    return CustomDialog(
        vip:!Provider.of<WareProvider>(context, listen: false).isVip,
        contentPadding: EdgeInsets.all(8),
        height: 400,
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
                  Provider.of<WareProvider>(context, listen: false)
                      .backupDirectory;
              await BackupTools.createBackup(context,
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
                icon: Icon(FontAwesomeIcons.filePdf,color:Colors.white,size: 18,),
                color: Colors.red,

                onPressed: () async {
                  File file=await pdfTypeFile();
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
              icon: Icon(Icons.share_rounded,color: Colors.white,),
              onPressed: ()async{
                File file=await pdfTypeFile();
                await Share.shareXFiles([XFile(file.path)]);
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
                if(subGroup!="selected")
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
                    cCheckBox("نمایش عنوان",showHeader,(val)=>showHeader=val),
                    cCheckBox("نمایش پاورقی",showFooter,(val)=>showFooter=val),
                  ],
                ),
                const Divider(),
                ///Catalog print type check boxes
                if(printType==kPrintTypeList[3])
                cCheckBox("توضیحات",showMap["des"]!,(val)=>showMap["des"]=val),
                ///custom print type check boxes
                if(printType==kPrintTypeList[0])
                Wrap(
                  direction: Axis.horizontal,
                  children: [
                    cCheckBox("قیمت خرید",showMap["cost"]!,(val)=>showMap["cost"]=val),
                    cCheckBox("قیمت فروش",showMap["sale"]!,(val)=>showMap["sale"]=val),
                    cCheckBox("تعداد",showMap["count"]!,(val)=>showMap["count"]=val),
                    cCheckBox("توضیحات",showMap["des"]!,(val)=>showMap["des"]=val),
                    cCheckBox("سریال",showMap["serial"]!,(val)=>showMap["serial"]=val),
                  ],
                ),
                const Gap(30),
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
                          borderRadius: 40,
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