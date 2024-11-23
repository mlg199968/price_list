import 'package:flutter/material.dart';

///Button tile
class ButtonTile extends StatelessWidget {
  const ButtonTile({
    Key? key,
    required this.onPress,
    this.width = 150,
    required this.label,
    required this.buttonLabel,
    this.extra,
  }) : super(key: key);

  final String label;
  final String buttonLabel;
  final VoidCallback onPress;
  final double width;
  final Widget? extra;

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
            SizedBox(
              child: extra,
            ),
            OutlinedButton(
              onPressed: onPress,
              child: Text(buttonLabel),
            ),
          ],
        ),
      ),
    );
  }
}