import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart'
    as formatter;
import 'package:price_list/constants/constants.dart';

enum TextFormatter { price, normal, number }

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    Key? key,
    required this.label,
    required this.controller,
    this.maxLine = 1,
    this.maxLength=35,
    this.width = 150,
    this.height=25,
    this.textFormat = TextFormatter.normal,
    this.onChange,
    this.validate=false,
    this.enable=true
  }) : super(key: key);


  final String label;
  final TextEditingController controller;
  final int maxLine;
  final int maxLength;
  final double width;
  final double height;
  final TextFormatter textFormat;
  // ignore: prefer_typing_uninitialized_variables
  final  onChange;
  // ignore: prefer_typing_uninitialized_variables
  final bool validate;
  final bool enable;


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: TextFormField(
          enabled:enable ,
          onChanged:onChange,
          validator:validate?(val){

            if(val==null || val.isEmpty){
              return " ضروری !";
            }
            return null;
            }:null,
          keyboardType:
              (textFormat == TextFormatter.number || textFormat==TextFormatter.price) ? TextInputType.number : null,
          inputFormatters: textFormat == TextFormatter.price
              ? [
                  formatter.CurrencyTextInputFormatter(
                    symbol: "",
                    decimalDigits: 0,
                  )
                ]
              : null,
          textAlign: TextAlign.center,
          maxLines: maxLine,
          maxLength: maxLength,
          controller: controller,
          decoration: InputDecoration(
            isDense: true,
            contentPadding:  EdgeInsets.fromLTRB(10, height, 10, 0),
            counterText: "",
            filled: true,
            fillColor: Colors.white,
            hoverColor: Colors.white70,

            label: AutoSizeText(
              label,
              style: const TextStyle(color: kColor1),
              maxFontSize: 16,
              minFontSize: 10,
              maxLines: 1,
              overflow: TextOverflow.fade,


            ),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                ),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: kColorController)),
            errorBorder:OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color:Colors.red)),
          ),
        ),
      ),
    );
  }
}
