
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:price_list/components/custom_text.dart';
import 'package:price_list/components/custom_textfield.dart';
import 'package:price_list/constants/constants.dart';
import 'package:price_list/constants/utils.dart';
import 'package:price_list/providers/ware_provider.dart';
import 'package:provider/provider.dart';

class PriceTextField extends StatelessWidget {
  const PriceTextField({super.key, required this.controller, this.label, this.onChange, this.prefixWidget});
final TextEditingController controller;
final String? label;
final Widget? prefixWidget;
  final Function(String val)? onChange;
  @override
  Widget build(BuildContext context) {
    return Consumer<WareProvider>(
      builder: (context,wareProvider,child) {
        String? convertedValue;
        if( wareProvider.currency!="تومان" && wareProvider.currenciesMap!=null) {
          double cValue = wareProvider
              .currenciesMap![kCurrencyListMap[wareProvider.currency]] ?? 0;
          convertedValue = addSeparator(stringToDouble(controller.text) * cValue);
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: CustomTextField(controller: controller,
                    label: label,
                    textFormat: TextFormatter.price,
                    maxLength: 17,
                    decimalDigits: wareProvider.currency=="تومان" ||wareProvider.currency=="ریال"?0:2,
                    onChange: (val){
                      if(wareProvider.currency!="تومان" && wareProvider.currenciesMap!=null) {
                        double cValue = wareProvider
                            .currenciesMap![kCurrencyListMap[wareProvider.currency]] ?? 0;
                        convertedValue = addSeparator(stringToDouble(controller.text) * cValue);
                        if(onChange!=null) {
                        onChange!(val);
                      }
                    }
                      },
                  ),
                ),
                if(prefixWidget!=null)
                prefixWidget!
              ],
            ),
            if(wareProvider.currency!="تومان" && wareProvider.currenciesMap!=null)
              CText("$convertedValue معادل به تومان ",color: kMainColor,)
          ],
        );
      }
    );
  }
}
