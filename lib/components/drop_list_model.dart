import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:price_list/constants/constants.dart';

class DropListModel extends StatelessWidget {
  const DropListModel({
    super.key,
    required this.listItem,
    required this.selectedValue,
    required this.onChanged,
    this.width = 140,
    this.height = 35,
    this.icon,
    this.elevation = 2,
    this.borderRadius = 10,
    this.subWidget,
    this.valueSubWidget,
  });

  final List listItem;
  final String selectedValue;
  final Function onChanged;
  final double width;
  final double height;
  final Icon? icon;
  final double elevation;
  final double borderRadius;
  final Widget? subWidget;
  final String? valueSubWidget;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: icon == null ? TextDirection.rtl : TextDirection.ltr,
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius)),
        color: Colors.transparent,
        elevation: icon == null ? elevation : 0,
        child: DropdownButtonHideUnderline(
          child: DropdownButton2(
            iconStyleData: const IconStyleData(
              icon: Icon(Icons.keyboard_arrow_down),
              openMenuIcon: Icon(Icons.keyboard_arrow_up),
              iconDisabledColor: Colors.black26,
              iconEnabledColor: kMainColor,
            ),
            dropdownStyleData: DropdownStyleData(
                width: width,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.85),
                  gradient: kBlackWhiteGradiant,
                  borderRadius: BorderRadius.circular(borderRadius),
                  //border: Border.all(color: kColorController)
                ),
                scrollbarTheme:
                    ScrollbarThemeData(radius: Radius.circular(borderRadius)),
                padding: EdgeInsets.zero,
                scrollPadding: EdgeInsets.zero),
            buttonStyleData: ButtonStyleData(
              width: width,
              height: height,
              decoration: BoxDecoration(
                color: icon != null ? null : Colors.white,
                borderRadius: BorderRadius.circular(borderRadius),
                //border: Border.all(color: kColorController)
              ),
            ),
            menuItemStyleData: MenuItemStyleData(
              padding: EdgeInsets.zero,
            ),
            isExpanded: true,
            customButton: icon,
            isDense: true,
            alignment: Alignment.centerRight,
            hint: const Text(
              'no item',
              style: TextStyle(fontSize: 20, color: Colors.black38),
            ),
            items: listItem
                .map((item) => DropdownMenuItem<String>(
                      alignment: Alignment.centerRight,
                      value: item,
                      child: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 5),
                        margin: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: icon != null
                              ? (selectedValue == item ? kMainColor : null)
                              : null,
                          borderRadius: BorderRadius.circular(borderRadius - 3),
                        ),

                        ///item row
                        child: Row(
                          textDirection: TextDirection.rtl,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ///item name
                            Flexible(
                              child: Text(
                                item,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 4,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: icon != null
                                      ? (selectedValue == item
                                          ? Colors.white70
                                          : null)
                                      : null,
                                ),
                              ),
                            ),
                            if (item == valueSubWidget && subWidget != null)
                              Flexible(child: subWidget!)
                          ],
                        ),
                      ),
                    ))
                .toList(),
            value: listItem.contains(selectedValue)?selectedValue:listItem.first,
            onChanged: (val) {
              onChanged(val);
            },
          ),
        ),
      ),
    );
  }
}
