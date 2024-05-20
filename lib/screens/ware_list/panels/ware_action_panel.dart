
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:price_list/components/action_button.dart';
import 'package:price_list/components/counter_textfield.dart';
import 'package:price_list/components/custom_alert.dart';
import 'package:price_list/components/custom_dialog.dart';
import 'package:price_list/components/custom_button.dart';
import 'package:price_list/components/custom_text.dart';
import 'package:price_list/components/custom_textfield.dart';
import 'package:price_list/components/drop_list_model.dart';
import 'package:price_list/constants/utils.dart';
import 'package:price_list/model/ware.dart';
import 'package:price_list/providers/ware_provider.dart';
import 'package:price_list/screens/setting/backup/backup_tools.dart';
import 'package:price_list/services/hive_boxes.dart';
import 'package:provider/provider.dart';

import 'change_group_panel.dart';


class WareActionsPanel extends StatefulWidget {
  static const String id = "/WareActionPanel";
  const WareActionsPanel(
      {Key? key, required this.wares, required this.subGroup})
      : super(key: key);
  final List<Ware> wares;
  final String subGroup;

  @override
  State<WareActionsPanel> createState() => _WareActionsPanelState();
}

class _WareActionsPanelState extends State<WareActionsPanel> {
  final TextEditingController percentController = TextEditingController(text: "0");
  final TextEditingController fixAmountController = TextEditingController(text: "0");
  final TextEditingController coefficientController = TextEditingController(text: "1");
  late String subGroup;
  bool isNegative = false;
///save button function
  void saveButtonFunction() {
    for (Ware ware in widget.wares) {
      double fixPrice = fixAmountController.text == ""
          ? 0
          : stringToDouble(fixAmountController.text);
      double percent = percentController.text == ""
          ? 0
          : stringToDouble(percentController.text);
      double coefficient = coefficientController.text == ""
          ? 1
          : stringToDouble(coefficientController.text);
      if (ware.groupName == subGroup || subGroup == "همه" || subGroup == "selected") {
        if (!isNegative) {
          ware.sale = ware.sale + fixPrice + (ware.sale * percent / 100);
          ware.cost = ware.cost + fixPrice + (ware.cost * percent / 100);
        } else {
          ware.sale = ware.sale - fixPrice - (ware.sale * percent / 100);
          ware.cost = ware.cost - fixPrice - (ware.cost * percent / 100);
        }
        ware.sale *= coefficient;
        ware.cost *= coefficient;
        HiveBoxes.getWares().put(ware.wareID, ware);
      }
    }
    Navigator.pop(context, false);
  }

  @override
  void initState() {
    subGroup = widget.subGroup;
    super.initState();
  }

  @override
  void dispose() {
    percentController.dispose();
    fixAmountController.dispose();
    coefficientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
        vip: !Provider.of<WareProvider>(context, listen: false).isVip,
        height: 400,
        title: "افزایش یا کاهش گروهی قیمت ها ",
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
        actions: [
          ///save button
          CustomButton(
            width: 100,
              height: 30,
              icon: Icon(Icons.save_alt,color: Colors.white,),
              text: "ثبت",
              radius: 10,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => CustomAlert(
                    title: "آیا از ثبت تغییرات مطمئن هستید؟",
                    onYes: (){
                      saveButtonFunction();
                      Navigator.pop(context);
                    },
                  ),
                );
              }),
        ],
        child: Consumer<WareProvider>(builder: (context, wareProvider, child) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///dropDown list for Group Select
              if(subGroup!="selected")
              Row(
                children: [
                  const Text("انتخاب گروه کالا"),
                  const SizedBox(
                    width: 10,
                  ),


                  Flexible(
                    child: DropListModel(
                      selectedValue: subGroup,
                      height: 40,
                      listItem:["همه", ...wareProvider.groupList],
                      onChanged: (val) {
                        subGroup = val;
                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  CText(
                    "کاهش قیمت",
                    color: isNegative ? Colors.red : Colors.black54,
                  ),
                  Switch(
                      value: isNegative,
                      activeColor: Colors.red,
                      onChanged: (val) {
                        isNegative = val;
                        setState(() {});
                      }),
                ],
              ),

              ///price text fields
              Row(
                children: [
                  Flexible(
                      flex: 5,
                      child: CustomTextField(
                        width: 200,
                        label: "مبلغ ثابت",
                        controller: fixAmountController,
                        textFormat: TextFormatter.price,
                      )),
                  const SizedBox(
                    width: 5,
                  ),
                  Flexible(
                      flex: 3,
                      child: SizedBox(
                        width: 120,
                        child: CounterTextfield(
                          label: "درصد",
                          controller: percentController,
                        ),
                      )),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CText(
                    "ضریب",
                  ),
                  Flexible(
                    child: CounterTextfield(
                      label: "ضریب",
                      controller: coefficientController,
                      minNum: .01,
                      maxNum: 100,
                    ),
                  ),
                ],
              ),
              Gap(10),
              if(subGroup!="همه")
              ActionButton(
                icon: Icons.account_tree_rounded,
                label: "تغییر نام گروه",
                onPress: (){
                  showDialog(
                      context: context,
                      builder: (context) => GroupManagePanel(wares:widget.wares)).then((value) {
                    setState(() {});
                  });
                },
              ),
            ],
          );
        }));
  }
}
