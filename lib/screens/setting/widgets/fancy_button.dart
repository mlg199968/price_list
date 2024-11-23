import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../components/custom_text.dart';
import '../../../components/dynamic_button.dart';

///Fancy Button Tile
class FancyButtonTile extends StatelessWidget {
  const FancyButtonTile({
    Key? key,
    required this.onPress,
    this.width = 150,
    required this.label,
    required this.buttonLabel,
    this.extra,
    this.icon,
    this.bgColor = Colors.black54,
    this.iconColor,
    this.height = 70,
    this.iconSize,
    this.borderRadius = 10,
    this.direction = TextDirection.ltr,
    this.margin = const EdgeInsets.symmetric(vertical: 2),
    this.padding = const EdgeInsets.only(left: 10),
    this.disable = false,
    this.labelStyle,
    this.borderColor,
    this.colors = const [Colors.blue, Colors.deepPurpleAccent],
    this.image,
    this.subTitle,
    this.imagePadding = const EdgeInsets.all(8),
  }) : super(key: key);

  final String label;
  final String? subTitle;
  final String buttonLabel;
  final VoidCallback onPress;
  final Widget? extra;
  final IconData? icon;
  final Color bgColor;
  final List<Color> colors;
  final Color? iconColor;
  final double height;
  final double? width;
  final double? iconSize;
  final double borderRadius;
  final TextDirection direction;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final EdgeInsets? imagePadding;
  final bool disable;
  final TextStyle? labelStyle;
  final Color? borderColor;
  final String? image;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Row(
        children: [
          if (image != null)
            Container(
                height: height,
                padding: imagePadding,
                child: Image(
                  image: AssetImage(image!),
                )),
          SizedBox(width:10),
          Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CText(
                    label,
                    color: Colors.white,
                  ),
                  if (subTitle != null)
                    CText(
                      subTitle,
                      color: Colors.white54,
                      fontSize: 10,
                    ),
                ],
              )),
          SizedBox(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DynamicButton(
                onPress: onPress,
                label: buttonLabel,
                padding: EdgeInsets.symmetric(horizontal: 8),
                borderRadius: borderRadius,
                bgColor: bgColor,
                icon: icon,
                iconSize: iconSize,
                iconColor: iconColor ?? colors.last,
                borderColor: borderColor ?? colors.last,
                labelStyle: TextStyle(fontSize: 13, color: Colors.white),
              ),
              SizedBox(
                child: extra,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

///Fancy Button Tile vertical
class FancyButtonTileVertical extends StatelessWidget {
  const FancyButtonTileVertical({
    Key? key,
    required this.onPress,
    required this.label,
    required this.buttonLabel,
    this.extra,
    this.icon,
    this.bgColor = Colors.black54,
    this.iconColor,
    this.height = 200,
    this.width = 150,
    this.iconSize,
    this.borderRadius = 10,
    this.direction = TextDirection.ltr,
    this.margin = const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
    this.padding = const EdgeInsets.all(8),
    this.disable = false,
    this.labelStyle,
    this.borderColor,
    this.colors = const [Colors.blue, Colors.deepPurpleAccent],
    this.image,
    this.subTitle,
  }) : super(key: key);

  final String label;
  final String? subTitle;
  final String buttonLabel;
  final VoidCallback onPress;
  final Widget? extra;
  final IconData? icon;
  final Color bgColor;
  final List<Color> colors;
  final Color? iconColor;
  final double height;
  final double? width;
  final double? iconSize;
  final double borderRadius;
  final TextDirection direction;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final bool disable;
  final TextStyle? labelStyle;
  final Color? borderColor;
  final String? image;
  @override
  Widget build(BuildContext context) {
    return Container(
      // height: height,
      width: width,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (image != null)
            SizedBox(
                height: 100,
                child: Image(
                  image: AssetImage(image!),
                )),
          const Gap(10),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CText(
                label,
                color: Colors.white,
              ),
              if (subTitle != null)
                CText(
                  subTitle,
                  color: Colors.white54,
                  fontSize: 10,
                ),
            ],
          ),
          const Gap(10),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DynamicButton(
                onPress: onPress,
                label: buttonLabel,
                padding: EdgeInsets.symmetric(horizontal: 8),
                borderRadius: borderRadius,
                bgColor: bgColor,
                icon: icon,
                iconColor: iconColor ?? colors.last,
                borderColor: borderColor ?? colors.last,
                labelStyle: TextStyle(fontSize: 13, color: Colors.white),
              ),
              SizedBox(
                child: extra,
              ),
            ],
          ),
        ],
      ),
    );
  }
}