import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart'
as formatter;

enum TextFormatter { price, normal, number }

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    Key? key,
    required this.label,
    required this.controller,
    this.maxLine = 1,
    this.maxLength=35,
    this.width = 150,
    this.height=20,
    this.textFormat = TextFormatter.normal,
    this.onChange,
    this.validate=false,
    this.enable=true, this.focus
  }) : super(key: key);


  final String label;
  final TextEditingController controller;
  final int maxLine;
  final int maxLength;
  final double width;
  final double height;
  final FocusNode? focus;
  final TextFormatter textFormat;
  // ignore: prefer_typing_uninitialized_variables
  final Function(String val)? onChange;
  // ignore: prefer_typing_uninitialized_variables
  final bool validate;
  final bool enable;



  @override
  Widget build(BuildContext context) {
    bool isPressed=false;
    return SizedBox(
      width: width,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: TextFormField(
          enabled:enable ,
          onChanged:onChange,
          focusNode: focus,
          validator:validate?(val){

            if(val==null || val.isEmpty){
              return " ضروری !";
            }
            return null;
          }:null,
          keyboardType:
          (textFormat == TextFormatter.number || textFormat==TextFormatter.price) ? const TextInputType.numberWithOptions(decimal: true) : null,
          inputFormatters: textFormat == TextFormatter.price
              ? [
            formatter.CurrencyTextInputFormatter(
              symbol: "",
              decimalDigits: 0,
            )
          ]
              : null,
          onTap: () {
            if(!isPressed) {
              controller.selection = TextSelection(
                  baseOffset: 0, extentOffset: controller.value.text.length);
            }
            isPressed=true;
          },
          textAlign: TextAlign.center,
          maxLines: maxLine,
          maxLength: maxLength,
          controller: controller,
          decoration: InputDecoration(
            isDense: true,
            contentPadding:  const EdgeInsets.fromLTRB(10, 5, 10, 5),
            counterText: "",
            filled: true,
            fillColor: Colors.white,
            hoverColor: Colors.white70,

            label: AutoSizeText(
              label,
              style: const TextStyle(color: Colors.blueGrey),
              maxFontSize: 14,
              minFontSize: 10,
              maxLines: 1,
              overflow: TextOverflow.fade,


            ),
            border: OutlineInputBorder(
              borderSide: const BorderSide(width: .5),
              borderRadius: BorderRadius.circular(15),
            ),
            focusedBorder:OutlineInputBorder(
              borderSide: const BorderSide(width: .5,color: Colors.lightBlue),
              borderRadius: BorderRadius.circular(10),
            ),
            enabledBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(color: Colors.blueGrey,width: 1)),
            errorBorder:OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color:Colors.red)),
          ),
        ),
      ),
    );
  }
}
