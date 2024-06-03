

import 'package:flutter/material.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:price_list/components/custom_text.dart';
import 'package:price_list/constants/constants.dart';


class CustomToggleButton extends StatelessWidget {
  const CustomToggleButton({super.key, required this.labelList, this.widgetList, required this.selected, required this.onPress});
final List<String> labelList;
final List<Widget>? widgetList;
final String selected;
final Function(int index) onPress;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: SizedBox(
        height: 25,
        child: ToggleButtons(
          borderRadius: BorderRadius.circular(3),
          fillColor:kMainColor ,
          selectedColor: Colors.white,
          isSelected: labelList.map((e) {
            if(selected==e) {
                return true;
              }
            else{
              return false;
            }
            }).toList(),
          onPressed:onPress,
          children:widgetList!=null
              ? widgetList!
              : labelList.map((e) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: CText(e.toPersianDigit(),fontSize: 12,),
              ),).toList(),
        ),
      ),
    );
  }
}
