import 'package:flutter/material.dart';
import 'package:price_list/components/custom_textfield.dart';

///text field
class PriceInputItem extends StatelessWidget {
  const PriceInputItem({
    Key? key,
    required this.controller,
    this.onChange,
    this.width = 150,
    required this.label,
    required this.inputLabel,
    this.showCurrency = true,
  }) : super(key: key);

  final String label;
  final String inputLabel;
  final TextEditingController controller;
  final double width;
  final Function(String val)? onChange;
  final bool showCurrency;

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
            CustomTextField(
                label: inputLabel,
                controller: controller,
                width: width,
                height: 35,
                textFormat: TextFormatter.price,
                currency: "تومان",
                onChange: onChange)
          ],
        ),
      ),
    );
  }
}