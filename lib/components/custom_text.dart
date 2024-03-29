import 'package:flutter/material.dart';

class CText extends StatelessWidget {
  const CText(
    this.text, {
    super.key,
    this.fontSize = 12,
    this.color = Colors.black87, this.maxLine, this.textDirection=TextDirection.ltr, this.textAlign,
  });
  final String? text;
  final double fontSize;
  final int? maxLine;
  final Color color;
  final TextDirection textDirection;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(
      text ?? "",
      style: TextStyle(fontSize: fontSize, color: color),
      overflow: TextOverflow.fade,
      maxLines:maxLine ,
      textDirection:textDirection,
      textAlign: textAlign,
    );
  }
}
