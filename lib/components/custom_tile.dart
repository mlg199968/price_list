import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:price_list/components/custom_bg_shape.dart';
import '../../../constants/constants.dart';

class CustomTile extends StatelessWidget {
  const CustomTile(
      {super.key,
      this.height=60,
      this.color=Colors.deepPurpleAccent,
      this.subTitle,
      required this.title,
      required this.topTrailing,
      required this.trailing,
      this.leadingIcon,
      this.topTrailingLabel,
      this.onTap,
      this.type,
      this.enable = true});
  final double height;
  final Color color;
  final String? subTitle;
  final String title;
  final String topTrailing;
  final String? topTrailingLabel;
  final String trailing;
  final String? type;
  final IconData? leadingIcon;
  final VoidCallback? onTap;
  final bool enable;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child:

        Builder(builder: (context) {
          return Card(
            child: BackgroundClipper(
              color: color,
              height: height,
              child: MyListTile(
                onTap: onTap ?? (){},
                  enable: enable,
                  title: title,
                  leadingIcon: leadingIcon,
                  type: type,
                  subTitle: subTitle,
                  topTrailingLabel: topTrailingLabel,
                  topTrailing: topTrailing,
                  trailing: trailing),
            ),
          );
        }));


  }
}

class MyListTile extends StatelessWidget {
  const MyListTile({
    super.key,
    required this.enable,
    required this.title,
    this.leadingIcon,
    this.type,
    this.subTitle,
    this.topTrailingLabel,
    required this.topTrailing,
    required this.trailing,
    required this.onTap,
  });

  final bool enable;
  final String title;
  final IconData? leadingIcon;
  final String? type;
  final String? subTitle;
  final String? topTrailingLabel;
  final String topTrailing;
  final String trailing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap:onTap,
      iconColor: Colors.black26,
      contentPadding: const EdgeInsets.symmetric(horizontal: 5),
      dense: true,
      title: Text(
        title,
        style: TextStyle(fontSize: 15),
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.right,
        maxLines: 2,
      ),
      leading: leadingIcon != null
          ? SizedBox(
              child: Column(
                children: [
                  Expanded(
                      child: Icon(
                    leadingIcon,
                    size: 20,
                  )),
                  Text(
                    type ?? "",
                    style: const TextStyle(fontSize: 12, color: Colors.black38),
                  ),
                  const SizedBox(
                    height: 5,
                  )
                ],
              ),
            )
          : null,
      subtitle: Text(subTitle ?? ""),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          RichText(
            text: TextSpan(
              text: topTrailingLabel ?? "",
              style: const TextStyle(color: Colors.black54, fontSize: 11),
              children: [
                TextSpan(
                    text: topTrailing,
                    style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 11,
                        fontFamily: kCustomFont)),
              ],
            ),
          ),
          AutoSizeText(
            trailing,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.left,
            textDirection: TextDirection.ltr,
            maxLines: 2,
            style: kCellStyle,
            minFontSize: 12,
            maxFontSize: 20,
          ),
        ],
      ),
    );
  }
}

class DropButtons extends StatelessWidget {
  const DropButtons(
      {super.key,
      required this.text,
      required this.icon,
      required this.onPress,
      required this.color});
  final String text;
  final IconData icon;
  final Color color;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        alignment: Alignment.center,
        color: color,
        child: TextButton(
          onPressed: onPress,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                icon,
                color: Colors.white,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                text,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
