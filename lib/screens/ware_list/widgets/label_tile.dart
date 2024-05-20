import 'package:flutter/material.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../../../constants/constants.dart';

///LabelTile
class LabelTile extends StatelessWidget {
  const LabelTile({
    super.key,
    required this.label,
    this.count = 0,
    this.onTap,
    this.onSecondaryTap,
    this.disable = true,
    this.disableColor = kMainDisableColor,
    this.activeColor = kMainActiveColor,
    this.fontSize,this.elevation=.4,
  });
  final String label;
  final num count;
  final double? fontSize;
  final double elevation;
  final VoidCallback? onTap;
  final VoidCallback? onSecondaryTap;
  final bool disable;
  final Color activeColor;
  final Color disableColor;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      onSecondaryTap: onSecondaryTap,
      child: AnimatedSize(
        duration: const Duration(milliseconds: 200),
        child: Container(
          margin: const EdgeInsets.all(2),
          padding: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            color: disable ? disableColor : activeColor,
            borderRadius: BorderRadius.circular(disable ? 5 : 10),
            boxShadow: [BoxShadow(blurRadius: 2, offset: const Offset(.5, .9), color: Colors.black54.withOpacity(elevation))],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Text(
                  label,
                  style: TextStyle(color: Colors.white,fontSize: fontSize),
                ),
              ),
              if (count != 0)
                const SizedBox(
                  width: 5,
                ),
              if (count != 0)
                Container(
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                        color: Colors.white70, shape: BoxShape.circle),
                    child: Text(count.toString().toPersianDigit())),
            ],
          ),
        ),
      ),
    );
  }
}