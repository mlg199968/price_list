import 'package:flutter/material.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart'
    as formatter;
import 'package:flutter/services.dart';
import 'package:price_list/constants/constants.dart';
import 'package:price_list/providers/ware_provider.dart';

import 'package:provider/provider.dart';

enum TextFormatter { price, normal, number }

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    Key? key,
    this.label,
    required this.controller,
    this.maxLine = 1,
    this.maxLength = 35,
    this.width = 150,
    this.height,
    this.borderRadius=5,
    this.hint,
    this.textFormat = TextFormatter.normal,
    this.onChange,
    this.validate = false,
    this.extraValidate,
    this.enable = true,
    this.focus,
    this.suffixIcon,
    this.obscure = false,
    this.prefixIcon,
    this.symbol,
    this.currency,
    this.decimalDigits,
  }) : super(key: key);

  final String? label;
  final TextEditingController controller;
  final int maxLine;
  final int maxLength;
  final double width;
  final double? height;
  final double borderRadius;
  final String? hint;
  final Widget? suffixIcon;
  final IconData? prefixIcon;
  final FocusNode? focus;
  final TextFormatter textFormat;
  final Function(String val)? onChange;
  final bool validate;
  final Function(String? val)? extraValidate;
  final String? symbol;
  final String? currency;
  final bool enable;
  final bool obscure;
  final int? decimalDigits;


  @override
  Widget build(BuildContext context) {
    String curr=currency ?? Provider.of<WareProvider>(context,listen: false).currency;
    bool isPressed = false;
    return SizedBox(
      height: height,
      width: width,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: TextFormField(
          obscureText: obscure,
          enabled: enable,
          onChanged: onChange,
          focusNode: focus,
          validator: validate
              ? (val) {
                  if (val == null || val.isEmpty) {
                    return " ضروری !";
                  } else {
                    if (extraValidate != null) {
                      return extraValidate!(val);
                    }
                  }

                  return null;
                }
              : null,
          keyboardType: (textFormat == TextFormatter.number ||
                  textFormat == TextFormatter.price)
              ? const TextInputType.numberWithOptions(decimal: true)
              : null,
          inputFormatters: textFormat == TextFormatter.price
              ? <TextInputFormatter>[
                  formatter.CurrencyTextInputFormatter.currency(
                    customPattern: symbol == null ? null : " $symbol ",
                    symbol: "",
                    decimalDigits:decimalDigits ?? 0,
                   ),
                ]
              : null,

          onTap: () {
            if (!isPressed) {
              //logic:when user tap on the textfield ,text get selected
              controller.selection = TextSelection(
                  baseOffset: 0, extentOffset: controller.value.text.length);
            }
            isPressed = true;
          },
          textAlign: TextAlign.center,
          maxLines: maxLine,
          maxLength: maxLength,
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(fontSize: 12),
            prefixIcon: prefixIcon == null ? null : Icon(prefixIcon),
            suffixIcon:suffixIcon,
            isDense: true,
           // contentPadding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
            counterText: "",
            filled: true,
            fillColor: Colors.white,
            hoverColor: Colors.white70,
            label:label==null?null: Text(
              textFormat == TextFormatter.price?
              "${label!} ($curr)":label!,
              style: const TextStyle(color: Colors.black54,fontSize: 14),
              maxLines: 1,
              overflow: TextOverflow.fade,
            ),
            border: OutlineInputBorder(
              borderSide: const BorderSide(width: .5),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: .5, color: kMainColor2),
              borderRadius: BorderRadius.circular(borderRadius+5),
            ),
            enabledBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: const BorderSide(color: Colors.blueGrey, width: 1)),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius+5),
                borderSide: const BorderSide(color: Colors.red)),
          ),
        ),
      ),
    );
  }
}
