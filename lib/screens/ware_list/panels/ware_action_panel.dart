import 'package:flutter/material.dart';
import 'package:price_list/components/custom_alert_dialog.dart';
import 'package:price_list/components/custom_button.dart';
import 'package:price_list/components/custom_textfield.dart';
import 'package:price_list/components/drop_list_model.dart';
import 'package:price_list/components/pdf/pdf_api.dart';
import 'package:price_list/components/pdf/pdf_ware_list_api.dart';
import 'package:price_list/constants/utils.dart';
import 'package:price_list/data/hive_boxes.dart';
import 'package:price_list/model/ware_hive.dart';
import 'package:price_list/ware_provider.dart';
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

  @override
  void initState() {
    subGroup = widget.subGroup;
    percentController.text = "0";
    fixAmountController.text = "0";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomAlertDialog(
        context: context,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text("انتخاب گروه کالا"),
                const SizedBox(
                  width: 10,
                ),

                ///dropDown list for Group Select
                Consumer<WareProvider>(
                  builder: (context, wareData, child) {
                    return DropListModel(
                      selectedValue: subGroup,
                      height: 40,
                      listItem: ["همه", ...wareData.groupList],
                      onChanged: (val) {
                        subGroup = val;
                        setState(() {});
                      },
                    );
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
                Expanded(
                    flex: 3,
                    child: CustomTextField(
                      label: "مبلغ ثابت",
                      controller: fixAmountController,
                      textFormat: TextFormatter.price,
                    )),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                    child: CustomTextField(
                      label: "درصد",
                      controller: percentController,
                      textFormat: TextFormatter.number,
                      onChange: (val) {
                        if (val != "" &&
                            val != "-" &&
                            val != "." &&
                            val != "-." &&
                            stringToDouble(val) > 1000) {
                          percentController.text = 1000.toString();
                          setState(() {});
                        }
                      },
                    )),
              ],
            ),
            const SizedBox(
              height: 15,
            ),

            ///buttons
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                      width: double.maxFinite,
                      text: "ثبت",
                      onPressed: () {
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
                ),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: CustomButton(
                      width: double.maxFinite,
                      text: "چاپ",
                      color: Colors.red,
                      onPressed: () async {
                        List<WareHive> filteredList = [];
                        for (WareHive ware in widget.wares) {
                          if (ware.groupName == subGroup || subGroup == "همه") {
                            filteredList.add(ware);
                          }
                        }
                        final file = await PdfWareListApi.generate(
                            filteredList, context);
                        PdfApi.openFile(file);
                      }),
                ),
              ],
            ),
          ],
        ));
  }
}
