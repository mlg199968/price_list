import 'package:flutter/material.dart';
import 'package:price_list/components/custom_bg_shape.dart';

import '../model/ware.dart';

class CustomTile extends StatelessWidget {
  const CustomTile({
    super.key,
    this.height = 60,
    this.color = Colors.deepPurpleAccent,
    this.subTitle,
    required this.title,
    required this.topTrailing,
    required this.trailing,
    this.leadingIcon,
    this.topTrailingLabel,
    this.onTap,
    this.type,
    this.enable = true,
    this.middle,
    this.middleLabel,
    this.trailingLabel,
    this.onLongPress,
    this.selected = false, this.surfaceColor, required this.ware,
  });
  final Ware ware;
  final double height;
  final Color color;
  final Color? surfaceColor;
  final String? subTitle;
  final String title;
  final String topTrailing;
  final String? topTrailingLabel;
  final String trailing;
  final String? type;
  final IconData? leadingIcon;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final String? middle;
  final String? middleLabel;
  final String? trailingLabel;
  final bool enable;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          surfaceTintColor:surfaceColor ?? Colors.white,
          margin: selected ? const EdgeInsets.only(right: 20) : null,
          child: BackgroundClipper(
            color: selected ?Colors.blue:color,
            height: height,
            child: MyListTile(
              selected: selected,
              onTap: onTap ?? () {},
              onLongPress: onLongPress,
              enable: enable,
              title: title,
              leadingIcon: leadingIcon,
              type: type,
              subTitle: subTitle,
              topTrailingLabel: topTrailingLabel,
              topTrailing: topTrailing,
              trailing: trailing,
              trailingLabel: trailingLabel,
              middle: middle,
              middleLabel: middleLabel,
            ),
          ),
        ));
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
    this.middle,
    this.middleLabel,
    this.trailingLabel,
    this.onLongPress,
    required this.selected,
  });

  final bool enable;
  final bool selected;
  final String title;
  final IconData? leadingIcon;
  final String? type;
  final String? subTitle;
  final String? topTrailingLabel;
  final String topTrailing;
  final String trailing;
  final String? trailingLabel;
  final String? middle;
  final String? middleLabel;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context,constraint) {
        bool hideTrailing=constraint.maxWidth<300;
        return ListTile(
          selected: selected,
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
                        style: TextStyle(
                          fontSize: 12,
                          color: selected ? Colors.blue : Colors.black38,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      )
                    ],
                  ),
                )
              : null,
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(subTitle ?? ""),
              RichText(
                text: TextSpan(
                  text: middleLabel ?? "",
                  style:  TextStyle(color: selected ? Colors.blue :Colors.black54, fontSize: 11),
                  children: [
                    TextSpan(
                        text: middle,
                        style:  TextStyle(
                            color: selected ? Colors.blue :Colors.black87,
                            fontSize: 13,
                            fontFamily: Theme.of(context).textTheme.bodyMedium!.fontFamily)),
                  ],
                ),
              ),
            ],
          ),
          trailing: hideTrailing?null:Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              RichText(
                text: TextSpan(
                  text: topTrailingLabel ?? "",
                  style:  TextStyle(color: selected ? Colors.blue :Colors.black54, fontSize: 11),
                  children: [
                    TextSpan(
                        text: topTrailing,
                        style:  TextStyle(
                            color:selected ? Colors.blue : Colors.black54,
                            fontSize: 12,
                            fontFamily: Theme.of(context).textTheme.bodyMedium!.fontFamily)),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  text: trailingLabel ?? "",
                  style:  TextStyle(color: selected ? Colors.blue :Colors.black54, fontSize: 11),
                  children: [
                    TextSpan(
                        text: trailing,
                        style:  TextStyle(
                            color: selected ? Colors.blue :Colors.black,
                            fontSize: 14,
                            fontFamily: Theme.of(context).textTheme.bodyMedium!.fontFamily)),
                  ],
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}


