import 'package:flutter/material.dart';
import 'package:price_list/components/counter_textfield.dart';
import 'package:price_list/components/custom_dialog.dart';
import 'package:price_list/components/custom_button.dart';
import 'package:price_list/components/custom_text.dart';
import 'package:price_list/components/custom_textfield.dart';
import 'package:price_list/constants/utils.dart';
import 'package:price_list/model/ware.dart';
import 'package:price_list/providers/ware_provider.dart';
import 'package:price_list/services/hive_boxes.dart';
import 'package:provider/provider.dart';

class SelectedWareActionPanel extends StatefulWidget {
  const SelectedWareActionPanel(
      {Key? key, required this.wares})
      : super(key: key);
  final List<Ware> wares;


  @override
  State<SelectedWareActionPanel> createState() => _SelectedWareActionPanelState();
}

class _SelectedWareActionPanelState extends State<SelectedWareActionPanel> {
  final TextEditingController percentController = TextEditingController();
  final TextEditingController fixAmountController = TextEditingController();
  final TextEditingController coefficientController = TextEditingController();
  bool isNegative=false;
  @override
  void initState() {

    percentController.text = "0";
    fixAmountController.text = "0";
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
      vip: !Provider.of<WareProvider>(context,listen: false).isVip,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 40),
              child: Text("افزایش یا کاهش قیمت موارد انتخاب شده "),
            ),
            Row(
              children: [
                CText("کاهش قیمت",color:isNegative?Colors.red: Colors.black54,),
                Switch(value: isNegative,activeColor: Colors.red, onChanged: (val){isNegative=val;setState(() {

                });}),
              ],
            ),
            ///price text fields
            Row(
              children: [
                ///fix amount
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
                ///percent TextField
                Expanded(
                  flex: 2,
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
                )),
              ],
            ),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("ضریب :",),

                CounterTextfield(label:"ضریب",controller: coefficientController),
              ],
            ),
            const SizedBox(
              height: 15,
            ),

            ///buttons
            CustomButton(
                text: "ثبت",
                onPressed: () {
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
                      if(!isNegative) {
                        ware.sale = ware.sale +
                            fixPrice +
                            (ware.sale * percent / 100);
                        ware.cost = ware.cost +
                            fixPrice +
                            (ware.cost * percent / 100);
                      }else{
                        ware.sale = ware.sale -
                            fixPrice -
                            (ware.sale * percent / 100);
                        ware.cost = ware.cost -
                            fixPrice -
                            (ware.cost * percent / 100);

                      }
                      ware.sale *=coefficient;
                      ware.cost *=coefficient;
                      HiveBoxes.getWares().put(ware.wareID, ware);

                  }
                  Navigator.pop(context, false);
                }),
            const SizedBox(
              width: 5,
            ),
          ],
        ));
  }
}
