import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:price_list/side_bar/sidebar_panel.dart';

// ignore: non_constant_identifier_names
AlertDialog CustomAlertDialog({
  required BuildContext context,
  String? title,
  required Widget child,
  double? height,
  double width = 450,
  textDirection = TextDirection.rtl,
  double opacity = .75,
  bool vip = true,
}) {
  return AlertDialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
    iconPadding: EdgeInsets.zero,
    contentPadding: EdgeInsets.zero,
    backgroundColor: Colors.white.withOpacity(opacity),
    scrollable: true,
    content: Stack(
      children: [
        BlurryContainer(
          borderRadius: BorderRadius.circular(5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.close,
                    color: Colors.red,
                    size: 30,
                  ),
                ),
              ),
              Center(
                  child: title == null
                      ? null
                      : Text(
                          title,
                          style: const TextStyle(
                              color: Colors.black54, fontSize: 18),
                        )),
              Directionality(
                textDirection: textDirection,
                child: Flexible(
                  child: Container(
                      height: height, // ?? MediaQuery.of(context).size.height,
                      width: width, // ?? MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.all(20),
                      child: child),
                ),
              ),
            ],
          ),
        ),
        ///vip Button show here when user is not vip
        vip
            ? SizedBox()
            : Container(
                padding: EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * .6,
                //height: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        "برای استفاده از این پنل نسخه پرو برنامه را فعال کنید.",
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 18),

                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    PurchaseButton(),
                  ],
                ),
                color: Colors.black87.withOpacity(.7),
              ),
      ],
    ),
  );
}
