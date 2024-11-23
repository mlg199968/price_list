



import 'package:flutter/material.dart';

import '../../../components/counter_textfield.dart';

///text field
class NumberInputItem extends StatelessWidget {
  const NumberInputItem({
    Key? key,
    required this.controller,
    this.onChange,
    this.width = 150,
    required this.label,
    required this.inputLabel, this.min=1, this.max=100,
  }) : super(key: key);

  final String label;
  final String inputLabel;
  final TextEditingController controller;
  final double width;
  final Function(String val)? onChange;
  final double min;
  final double max;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(child: Text(label)),
            CounterTextfield(
              label: inputLabel,
              controller: controller,
              width: width,
              decimal: false,
              minNum: min,
              maxNum: max,
            )
          ],
        ),
      ),
    );
  }
}