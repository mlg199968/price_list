import 'package:flutter/material.dart';
import 'package:price_list/components/glass_bg.dart';

// ignore: non_constant_identifier_names
AlertDialog CustomAlertDialog(
    {required BuildContext context,
    String? title,
    required Widget child,
    double height = double.maxFinite,
    double width = double.maxFinite,
    textDirection = TextDirection.rtl,
      double opacity=.8,
    }) {
  return AlertDialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    icon: GlassBackground(
      child: Align(
        alignment: Alignment.topRight,
        child: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.close,
            color: Colors.blue,
            size: 30,
          ),
        ),
      ),
    ),
    iconPadding: EdgeInsets.zero,
    title: title == null
        ? null
        : Center(
            child: Text(
            title,
            style: const TextStyle(color: Colors.black54),
          )),
    contentPadding: EdgeInsets.zero,
    backgroundColor: Colors.white.withOpacity(opacity),
    content: GlassBackground(
      child: Directionality(
        textDirection: textDirection,
        child: Container(
            height: height,
            width: width,
            padding: const EdgeInsets.all(20),
            child: child),
      ),
    ),
  );
}
