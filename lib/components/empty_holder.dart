import 'package:flutter/material.dart';

class EmptyHolder extends StatelessWidget {
  const EmptyHolder({
    super.key,
    required this.text,
    required this.icon,
    this.color,
    this.iconSize = 30,
    this.fontSize = 10,
    this.onTap,
    this.height=300,
  });
  final String text;
  final IconData icon;
  final Color? color;
  final double? height;
  final double iconSize;
  final double fontSize;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: height,
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: iconSize,
              color: color ?? Colors.black38,
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              text,
              style: TextStyle(
                fontSize: fontSize,
                color: color ?? Colors.black38,
              ),
              textDirection: TextDirection.rtl,
            ),
          ],
        )),
      ),
    );
  }
}
