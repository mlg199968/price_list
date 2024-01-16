import 'dart:io';

import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:price_list/components/hide_keyboard.dart';
import 'package:price_list/constants/constants.dart';
import 'package:price_list/screens/side_bar/sidebar_panel.dart';
class CustomDialog extends StatelessWidget {
  const CustomDialog({
    super.key,
    this.title,
    required this.child,
    this.height,
    this.textDirection = TextDirection.rtl,
    this.opacity = .6,
    this.image,
    this.borderRadius=20,this.vip=false,
  });
  final String? title;
  final Widget child;
  final double? height;
  final double width = 450;
  final TextDirection textDirection;
  final double opacity;
  final double borderRadius;
  final String? image;
  final bool vip;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
      iconPadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.white.withOpacity(opacity),
      scrollable: true,
      content: HideKeyboard(
        child: BlurryContainer(
          padding: const EdgeInsets.all(0),
          borderRadius: BorderRadius.circular(borderRadius),
          child: Stack(
            children: [
              ///image holder part with faded button,
              Opacity(
                opacity: .7,
                child: Container(
                  width: width,
                  height: 250,
                  decoration: BoxDecoration(
                    image: (image == null || image=="")
                        ? null
                        : DecorationImage(
                            image: FileImage(File(image!)),
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              ),
              Container(
                width: width,
                height: 250,
                decoration: const BoxDecoration(
                    backgroundBlendMode: BlendMode.dstIn,
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.white, Colors.transparent],
                        stops: [.5, .9])),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ///close button
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
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(gradient: kMainGradiant),
                      child: title == null
                          ? null
                          : Text(
                              title!,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 18),
                            )),
                  Directionality(
                    textDirection: textDirection,
                    child: Flexible(
                      child: Container(
                          margin: (image == null || image=="")
                              ? null
                              : const EdgeInsets.all(20).copyWith(top: 50),
                          //decoration for image if image is not null
                          decoration: (image == null || image=="")
                              ? null
                              : BoxDecoration(
                                  gradient: const LinearGradient(
                                      colors: [
                                        Colors.white,
                                        Colors.transparent
                                      ],
                                      stops: [
                                        0,
                                        .8
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                          height:
                              height, // ?? MediaQuery.of(context).size.height,
                          width: width, // ?? MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.all(20).copyWith(top: 10),
                          child: child),
                    ),
                  ),
                ],
              ),
              ///vip Button show here when user is not vip
              if (vip)
                Container(
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
        ),
      ),
    );
  }
}
