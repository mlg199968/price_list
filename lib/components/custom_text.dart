import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class CText extends StatelessWidget {
  const CText(
    this.text, {
    super.key,
    this.fontSize = 12,
    this.color,
    this.maxLine,
    this.textDirection = TextDirection.ltr,
    this.textAlign,
    this.minFontSize = 9, this.shadow,
  });
  final String? text;
  final double fontSize;
  final double minFontSize;
  final int? maxLine;
  final Color? color;
  final TextDirection textDirection;
  final TextAlign? textAlign;
  final BoxShadow? shadow;

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      text ?? "",
      style: TextStyle(
        color: color,
        shadows:shadow==null?null: [shadow!],
      ),
      overflow: TextOverflow.fade,
      maxLines: maxLine,
      textDirection: textDirection,
      textAlign: textAlign,
      minFontSize: minFontSize,
      maxFontSize: fontSize,
    );
  }
}
