import 'dart:io';

import 'package:flutter/material.dart';
import 'package:price_list/components/action_button.dart';
import 'package:price_list/components/counter_textfield.dart';
import 'package:price_list/components/custom_alert_dialog.dart';
import 'package:price_list/components/custom_textfield.dart';
import 'package:price_list/components/drop_list_model.dart';
import 'package:price_list/components/pdf/pdf_api.dart';
import 'package:price_list/components/pdf/pdf_ware_list_api.dart';
import 'package:price_list/constants/constants.dart';
import 'package:price_list/constants/utils.dart';
import 'package:price_list/model/ware_hive.dart';
import 'package:price_list/providers/ware_provider.dart';
import 'package:price_list/services/hive_boxes.dart';
import 'package:provider/provider.dart';

class WareActionsPanel extends StatefulWidget {
  static const String id="/WareActionPanel";
  const WareActionsPanel(
      {Key? key, required this.wares, required this.subGroup})
      : super(key: key);
  final List<WareHive> wares;
  final String subGroup;

  @override
  State<WareActionsPanel> createState() => _WareActionsPanelState();
}

class _WareActionsPanelState extends State<WareActionsPanel> {
  final TextEditingController percentController = TextEditingController();
  final TextEditingController fixAmountController = TextEditingController();
  late String subGroup;

  String printType=kPrintTypeList[0];

  @override
  void initState() {
    subGroup = widget.subGroup;
    percentController.text = "0";
    fixAmountController.text = "0";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
        height: 350,
        child: Consumer<WareProvider>(
            builder: (context,wareProvider,child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text("انتخاب گروه کالا"),
                      const SizedBox(
                        width: 10,
                      ),

                      ///dropDown list for Group Select
                      DropListModel(
                        selectedValue: subGroup,
                        height: 40,
                        listItem: ["همه", ...wareProvider.groupList],
                        onChanged: (val) {
                          subGroup = val;
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const Text("قالب چاپ"),
                      const SizedBox(
                        width: 10,
                      ),

                      ///dropDown list for print type Select
                      DropListModel(
                        selectedValue: printType,
                        height: 40,
                        listItem: kPrintTypeList,
                        onChanged: (val) {
                          printType = val;
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 15.0),
                    child: Text("افزایش یا کاهش گروهی قیمت ها "),
                  ),

                  ///price text fields
                  Row(
                    children: [
                      Flexible(
                          flex: 2,
                          child: CustomTextField(
                            width:200,
                            label: "مبلغ ثابت",
                            controller: fixAmountController,
                            textFormat: TextFormatter.price,
                          )),
                      const SizedBox(
                        width: 5,
                      ),
                      Flexible(
                          child: SizedBox(
                            width: 120,
                            child: CounterTextfield(
                              label: "درصد",
                              controller: percentController,
                              onChange: (val) {
                                if (val != "" &&
                                    val != "-" &&
                                    val != "." &&
                                    val != "-." &&
                                    stringToDouble(val!) > 1000) {
                                  percentController.text = 1000.toString();
                                  setState(() {});
                                }
                              },
                            ),
                          )),
                    ],
                  ),
                  const Expanded(
                    child: SizedBox(
                      height: 15,
                    ),
                  ),

                  ///buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ActionButton(
                          icon: Icons.save_alt,
                          label: "ثبت",
                          onPress: () {
                            for (WareHive ware in widget.wares) {
                              double fixPrice = fixAmountController.text == ""
                                  ? 0
                                  : stringToDouble(fixAmountController.text);
                              double percent = percentController.text == ""
                                  ? 0
                                  : stringToDouble(percentController.text);
                              if (ware.groupName == subGroup || subGroup == "همه") {
                                ware.sale = ware.sale +
                                    fixPrice +
                                    (ware.sale * percent / 100);
                                ware.cost = ware.cost +
                                    fixPrice +
                                    (ware.cost * percent / 100);
                                HiveBoxes.getWares().put(ware.wareID, ware);
                              }
                            }
                            Navigator.pop(context, false);
                          }),
                      const SizedBox(
                        width: 5,
                      ),
                      ActionButton(
                          label: "چاپ",
                          icon: Icons.print,
                          bgColor: Colors.red,
                          onPress: () async {
                            List<WareHive> filteredList = [];
                            for (WareHive ware in widget.wares) {
                              if (ware.groupName == subGroup || subGroup == "همه") {
                                filteredList.add(ware);
                              }
                            }
                            late File file;
                            if(printType=="اتیکت") {
                              file = await PdfWareListApi.generateTicketWareList(
                                  filteredList, context);
                            }
                            else{
                              file = await PdfWareListApi.generateSimpleWareList(
                                  filteredList, context);
                            }
                            PdfApi.openFile(file);
                          }),
                    ],
                  ),
                ],
              );
            }
        ));
  }
}
