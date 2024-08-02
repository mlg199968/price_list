
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:price_list/components/custom_text.dart';
import 'package:price_list/components/custom_textfield.dart';
import 'package:price_list/constants/constants.dart';
import 'package:price_list/constants/utils.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';

class PriceTextField extends StatelessWidget {
  const PriceTextField({super.key, required this.controller, this.label, this.onChange, this.prefixWidget});
final TextEditingController controller;
final String? label;
final Widget? prefixWidget;
  final Function(String val)? onChange;
  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context,userProvider,child) {
        String? convertedValue;
        if( userProvider.currency!="تومان" && userProvider.currenciesMap!=null) {
          double cValue = userProvider
              .currenciesMap![kCurrencyListMap[userProvider.currency]] ?? 0;
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
                    decimalDigits: userProvider.currency=="تومان" ||userProvider.currency=="ریال"?0:2,
                    onChange: (val){
                      if(userProvider.currency!="تومان" && userProvider.currenciesMap!=null) {
                        double cValue = userProvider
                            .currenciesMap![kCurrencyListMap[userProvider.currency]] ?? 0;
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
            if(userProvider.currency!="تومان" && userProvider.currenciesMap!=null)
              CText("$convertedValue معادل به تومان ",color: kMainColor,)
          ],
        );
      }
    );
  }
}
