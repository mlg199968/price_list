

import 'package:flutter/material.dart';

import '../../../components/drop_list_model.dart';

///drop list field
class DropListItem extends StatelessWidget {
  const DropListItem({
    super.key,
    required this.title,
    required this.selectedValue,
    required this.listItem,
    required this.onChange,
    this.dropWidth = 80,
  });

  final String title;
  final String selectedValue;
  final List<String> listItem;
  final void Function(String) onChange;
  final double dropWidth;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(child: Text(title)),
            Flexible(
              child: DropListModel(
                  elevation: 0,
                  width: dropWidth,
                  height: 30,
                  listItem: listItem,
                  selectedValue: selectedValue,
                  onChanged: onChange),
            ),
          ],
        ),
      ),
    );
  }
}