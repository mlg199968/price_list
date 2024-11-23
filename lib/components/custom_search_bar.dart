import 'dart:io';

import 'package:flutter/material.dart';
import 'package:price_list/components/action_button.dart';
import 'package:price_list/components/drop_list_model.dart';
import 'package:price_list/constants/constants.dart';
import 'package:price_list/constants/enums.dart';
import 'package:price_list/providers/value_provider.dart';
import 'package:price_list/screens/ware_list/services/ware_tools.dart';
import 'package:price_list/screens/ware_list/sort_ware_screen.dart';
import 'package:price_list/services/hive_boxes.dart';
import 'package:provider/provider.dart';

import '../model/ware.dart';
import '../screens/ware_list/services/barcode_scanner.dart';
import 'custom_icon_button.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({
    super.key,
    required this.controller,
    required this.hint,
    required this.onChange(val),
    required this.selectedSort,
    required this.sortList,
    required this.onSort,
    this.iconColor = Colors.white,
    this.focusNode,
  });
  final TextEditingController controller;
  final String hint;
  final Function onChange;
  final String selectedSort;
  final Function(String val) onSort;
  final List sortList;
  final FocusNode? focusNode;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    bool isPressed = false;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          Consumer<ValueProvider>(builder: (context, valProvider, child) {
            return DropListModel(
              showInvertSortCheckBox: true,
              icon: Icon(
                Icons.sort_rounded,
                size: 35,
                color: iconColor,
                shadows: [kShadow],
              ),
              width: 200,
              listItem: sortList,
              selectedValue: selectedSort,
              valueSubWidget: SortItem.custom.value,
              onChanged: (val) {
                onSort(val);
              },
              subWidget: ActionButton(
                label: "ویرایش",
                height: 20,
                borderRadius: 5,
                padding: EdgeInsets.zero,
                labelStyle: TextStyle(fontSize: 9, color: Colors.white),
                bgColor: kSecondaryColor,
                icon: Icons.settings,
                iconSize: 10,
                onPress: () {
                  List<Ware>? wareList = HiveBoxes.getWares().values.toList();
                  WareTools.filterList(
                      wareList, "", SortItem.custom.value, "all");
                  Navigator.pushNamed(context, SortWareScreen.id,
                      arguments: wareList);
                },
              ),
            );
          }),
          Flexible(
            child: SizedBox(
              width: 400,
              height: 45,
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                elevation: 4,
                child: Center(
                  child: TextField(
                    focusNode: focusNode,
                    controller: controller,
                    onChanged: (val) {
                      onChange(val);
                    },
                    onTap: () {
                      if (!isPressed) {
                        //logic:when user tap on the textfield ,text get selected
                        controller.selection = TextSelection(
                            baseOffset: 0,
                            extentOffset: controller.value.text.length);
                      }
                      isPressed = true;
                    },
                    decoration: InputDecoration(
                      //isDense: true,
                      contentPadding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                      filled: true,
                      fillColor: Colors.white,
                      hintText: hint,
                      prefixIcon: Icon(Icons.search_rounded),
                      suffixIcon: Platform.isAndroid || Platform.isIOS
                          ? CustomIconButton(
                              icon: Icons.qr_code_scanner_rounded,
                              iconSize: 25,
                              onPress: () {
                                Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                BarcodeScannerScreen()))
                                    .then((value) {
                                  controller.text = value;
                                  onChange(value);
                                });
                              },
                            )
                          : null,
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Colors.transparent,
                            strokeAlign: BorderSide.strokeAlignOutside),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Colors.transparent,
                            strokeAlign: BorderSide.strokeAlignOutside),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    cursorHeight: 25,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
