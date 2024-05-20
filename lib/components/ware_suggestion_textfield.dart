import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:price_list/components/custom_textfield.dart';
import 'package:price_list/model/ware.dart';

import '../services/hive_boxes.dart';


class WareSuggestionTextField extends StatelessWidget {
  const WareSuggestionTextField(
      {Key? key,
      required this.label,
      required this.controller,
      this.maxLine = 1,
      this.maxLength = 35,
      this.width = 150,
      this.height = 20,
      this.textFormat = TextFormatter.normal,
      this.onChange,
      this.validate = false,
      this.enable = true,
      required this.onSuggestionSelected, this.suffix})
      : super(key: key);

  final String label;
  final TextEditingController controller;
  final int maxLine;
  final int maxLength;
  final double width;
  final double height;
  final TextFormatter textFormat;

  // ignore: prefer_typing_uninitialized_variables
  final Function(String val)? onChange;
  final Function(Ware val) onSuggestionSelected;
  final Widget? suffix;

  // ignore: prefer_typing_uninitialized_variables
  final bool validate;
  final bool enable;

  Future<List<Ware>> suggestion(String query) async {
    return HiveBoxes.getWares().values.map((e) => e).where((element) {
      String wareName = element.wareName.toLowerCase().replaceAll(" ", "");
      //String serial=element.serialNumber.toLowerCase().replaceAll(" ", "");
      String key = query.toLowerCase().replaceAll(" ", "");
      if (wareName.contains(key)) {
        return true;
      } else {
        return false;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: TypeAheadField<Ware>(
          textFieldConfiguration: TextFieldConfiguration(
            controller: controller,
            maxLength: maxLength,
            maxLines: maxLine,
            onChanged: onChange,
            decoration: InputDecoration(
              suffixIcon: suffix,
              isDense: true,
              contentPadding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
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
              focusedBorder: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                  const BorderSide(color: Colors.blueGrey, width: 1)),
              enabledBorder: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide:
                      const BorderSide(color: Colors.blueGrey, width: 1)),
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.red)),
            ),
          ),
          suggestionsCallback: suggestion,
          itemBuilder: (context, suggestion) {
            return Container(
              padding: const EdgeInsets.fromLTRB(5, 5, 10, 10),
                child: Text(
              suggestion.wareName,
              textDirection: TextDirection.rtl,
            ));
          },

          onSuggestionSelected: onSuggestionSelected,
          suggestionsBoxDecoration:  const SuggestionsBoxDecoration(
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20),)
          ),
        ),
      ),
    );
  }
}
