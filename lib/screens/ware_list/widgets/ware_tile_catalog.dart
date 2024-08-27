
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:price_list/components/custom_bg_shape.dart';
import 'package:price_list/constants/constants.dart';
import 'package:provider/provider.dart';

import '../../../components/empty_holder.dart';
import '../../../constants/error_handler.dart';
import '../../../constants/utils.dart';
import '../../../model/ware.dart';
import '../../../providers/user_provider.dart';

class CatalogTile extends StatelessWidget {
  const CatalogTile({
    super.key,
    this.height = 150,
    this.color = Colors.deepPurpleAccent,
    this.onTap,
    this.type,
    this.enable = true,
    this.onLongPress,
    this.selected = false, this.surfaceColor, required this.ware,
  });
  final Ware ware;
  final double height;
  final Color color;
  final Color? surfaceColor;
  final String? type;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool enable;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, userProvider, child) {
      return Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            width: 150,
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: kBlackWhiteGradiant,
              borderRadius: BorderRadius.circular(5),
              border:selected? Border.all(color: Colors.redAccent, width: 2):null,
              boxShadow: [
                if(selected)
                BoxShadow(color: Colors.redAccent,blurRadius: 5,offset: Offset(1,1))
                else
                BoxShadow(color: Colors.black38,blurRadius: 2,offset: Offset(1,1)),
              ]
            ),
            child: BackgroundClipper(
              color: selected ?Colors.redAccent:color,
              height: height,
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ///catalog image holder
                    AspectRatio(
                      aspectRatio: 1 / 1,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: ware.imagePath!=null? Image(
                          image:FileImage(File(ware.imagePath ?? "")),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, trace) {
                            return const EmptyHolder(
                                text: "بارگزاری تصویر با مشکل مواجه شده است",
                                icon: Icons.image_not_supported_outlined);
                          },
                        ):Image(
                          image:AssetImage("assets/images/empty-image.jpg"),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, trace) {
                            return const EmptyHolder(
                                text: "بارگزاری تصویر با مشکل مواجه شده است",
                                icon: Icons.image_not_supported_outlined);
                          },
                        ),
                      ),
                    ),
                    Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ///ware name text
                                Flexible(
                                  child: Text(
                                    ware.wareName.toPersianDigit(),
                                    style: TextStyle(fontSize: 13),
                                    maxLines: 4,
                                  ),
                                ),
                                SizedBox(height: 10),

                                ///catalog description

                                  Flexible(
                                    child: Text(
                                      ware.description.toPersianDigit(),
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.blueGrey),
                                      maxLines: 4,
                                    ),
                                  ),
                                SizedBox(height:10),
                                if (true)
                                ///sale price text
                                  PriceHolder(ware),
                              ]),
                        )),


                  ],
                ),
              )
            ),
          ));
    }
    );
  }
}
class PriceHolder extends StatelessWidget {
  const PriceHolder(this.ware,{super.key});
final Ware ware;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ///main price
        if (ware.discount != null && ware.discount! > 0)
          Wrap(
            children: [
              ///discount percent
              if (ware.discount != null && ware.discount! > 0)
                Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    padding: const EdgeInsets.symmetric(horizontal: 1),
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(5)),
                    child: Text(
                      "${ware.discount}%".toPersianDigit(),
                      style: const TextStyle(color: Colors.white,fontSize: 9),
                    )),
              Text(
                addSeparator(ware.selectedSale),
                style: const TextStyle(
                    decoration: TextDecoration.lineThrough,
                    color: Colors.blueGrey,fontSize: 13),
              ),
            ],
          ),

        ///with discount price
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            alignment: WrapAlignment.center,
            children: [
              AutoSizeText(
                addSeparator(ware.saleConverted),
                style: const TextStyle(color: Colors.white),
                minFontSize: 9,
                maxFontSize: 16,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                Provider.of<UserProvider>(context,listen: false).currency,
                style: TextStyle(color: Colors.blueGrey,fontSize: 8),
                maxLines: 1,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

///
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
    required this.selected, this.discount,
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
  final double? discount;

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
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if(discount!=null && discount!>0)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 2),
                        margin: EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                            color: Colors.red,borderRadius: BorderRadius.circular(5)
                        ),
                        child: Text(
                            "%$discount".toPersianDigit(),
                            style:  TextStyle(
                              color:Colors.white,
                              fontSize: 8,)),
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
              ],
            ),
          );
        }
    );
  }
}


