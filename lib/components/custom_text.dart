import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class CText extends StatelessWidget {
  const CText(
    this.text, {
    super.key,
    this.fontSize = 12,
    this.color = Colors.black87,
    this.maxLine,
    this.textDirection = TextDirection.ltr,
    this.textAlign,
    this.minFontSize = 9,
  });
  final String? text;
  final double fontSize;
  final double minFontSize;
  final int? maxLine;
  final Color color;
  final TextDirection textDirection;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      text ?? "",
      style: TextStyle(color: color),
      overflow: TextOverflow.fade,
      maxLines: maxLine,
      textDirection: textDirection,
      textAlign: textAlign,
      minFontSize: minFontSize,
      maxFontSize: fontSize,
    );
  }
}
