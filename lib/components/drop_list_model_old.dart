import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:price_list/constants/constants.dart';


// ignore: must_be_immutable
class DropListModel extends StatefulWidget {
  DropListModel(
      {super.key, required this.listItem,
      required this.onChanged,
      required this.selectedValue});
  final List listItem;
  // ignore: prefer_typing_uninitialized_variables
  final  onChanged;
  String selectedValue;
  @override
  State<DropListModel> createState() => _DropListModelState();
}

class _DropListModelState extends State<DropListModel> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        alignment: Alignment.centerRight,
        scrollbarRadius: const Radius.circular(20),
        buttonDecoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: kColorController)),
        hint: const Text(
          'no Group',
          style: TextStyle(fontSize: 20, color: kColorController),
        ),

        items: widget.listItem
            .map((item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: const TextStyle(
                      fontSize: 20,
                      color: kColorController,
                    ),
                  ),
                ))
            .toList(),
        value: widget.selectedValue ,
        onChanged:
          widget.onChanged,

        buttonHeight: 40,
        buttonWidth: 140,
        itemHeight: 40,
      ),
    );
  }
}
