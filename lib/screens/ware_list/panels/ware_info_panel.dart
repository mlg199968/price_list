import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:price_list/components/action_button.dart';
import 'package:price_list/components/custom_alert.dart';
import 'package:price_list/components/empty_holder.dart';
import 'package:price_list/constants/enums.dart';
import 'package:price_list/constants/error_handler.dart';
import 'package:price_list/constants/utils.dart';
import 'package:price_list/model/ware.dart';
import 'package:price_list/screens/ware_list/add_ware_screen.dart';
import 'package:price_list/screens/ware_list/widgets/row_info.dart';

import '../../../components/custom_icon_button.dart';
import '../../../components/custom_text.dart';
import '../../../components/glass_bg.dart';
import '../../../constants/constants.dart';

class WareInfoPanel extends StatelessWidget {
  const WareInfoPanel({super.key, required this.ware});
  final Ware ware;

  Map<String, String?> get infoMap => {
        "نام کالا": ware.wareName,
        "سریال کالا": ware.wareSerial ?? "",
        "سرگروه": ware.groupName,
        "قیمت خرید": addSeparator(ware.cost),
        "قیمت فروش": addSeparator(ware.sale),
        "قیمت فروش 2": addSeparator(ware.sale2 ?? 0),
        "قیمت فروش 3": addSeparator(ware.sale3 ?? 0),
        "تخفیف": "${ware.discount ?? 0} %".toPersianDigit(),
        "مقدار": "${ware.quantity} ${ware.unit} ",
        "توضیحات:": ware.description,
        "تاریخ ثبت:": ware.date.toPersianDateStr(),
        "تاریخ ویرایش:": ware.modifyDate?.toPersianDateStr(),
      };

  @override
  Widget build(BuildContext context) {
    ///buttons list
    List<Widget> buttons = [
      ///delete button
      ActionButton(
          label: "حذف",
          width: 80,
          height: 30,
          borderRadius: 5,
          borderColor: Colors.red,
          bgColor: Colors.black38,
          icon: CupertinoIcons.trash_fill,
          iconSize: 20,
          iconColor: Colors.red,
          onPress: () {
          showDialog(
            context: context,
            builder: (context) => CustomAlert(
              title: "آیا از حذف کالا مورد نظر مطمئن هستید؟",
              onYes: () async {
                await deleteImageFile(ware.imagePath);
                ware.delete();
                Navigator.pop(context, false);
                Navigator.pop(context, false);

                showSnackBar(context, "کالا مورد نظر حذف شد!",
                    type: SnackType.success);
              },
              onNo: () {
                Navigator.pop(context, false);
              },
            ),
          );
        },
      ),
      ///edit button
      ActionButton(
        label: "ویرایش",
        width: 80,
        height: 30,
        borderRadius: 5,
        icon:Icons.drive_file_rename_outline_sharp,
          iconSize: 20,
          bgColor: Colors.black38,
        iconColor: Colors.orangeAccent,
        borderColor:Colors.orangeAccent,
        onPress: () {
          Navigator.pushNamed(context, AddWareScreen.id, arguments: ware);
        },
      ),
    ];
    return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        iconPadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.zero,
        backgroundColor: Colors.white.withOpacity(0),
        surfaceTintColor: Colors.white,
        buttonPadding: EdgeInsets.zero,
        insetPadding: const EdgeInsets.all(15),
        actionsPadding: EdgeInsets.zero,
        content: Container(
          height: 600,
          width: 500,
          decoration: BoxDecoration(
              gradient: kBlackWhiteGradiant,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [kShadow]),
          child: Stack(
            children: [
              ///close button
              Align(
                alignment: Alignment.topLeft,
                child: SizedBox(
                  height: 30,
                  width: 30,
                  child: CustomIconButton(
                    icon: CupertinoIcons.clear_fill,
                    iconColor: Colors.red,
                    iconSize: 30,
                    onPress: () {
                      Navigator.pop(context, false);
                    },
                  ),
                ),
              ),
              ///whole top part
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ///image holder
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          ///ware bg image
                          SizedBox(
                              height: 250,
                              width: 1000,
                              child: (ware.imagePath != null &&
                                      ware.imagePath != "")
                                  ? Image(
                                      image: FileImage(File(ware.imagePath!)),
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, trace) {
                                        ErrorHandler.errorManger(
                                            context, error,
                                            route: trace.toString(),
                                            title:
                                                "InfoPanelDesktop widget load image error");
                                        return const EmptyHolder(
                                            text:
                                                "بارگزاری تصویر با مشکل مواجه شده است",
                                            icon: Icons
                                                .image_not_supported_outlined);
                                      },
                                    )
                                  : Image.asset(
                                      "assets/images/empty-image.jpg")),

                          ///blurry layer
                          GlassBackground(
                            sigma: 5,
                            child: Container(
                              height: 250,
                              decoration: BoxDecoration(
                                  color: (ware.imagePath != null &&
                                          ware.imagePath != "")
                                      ? Colors.black26
                                      : null,
                                  gradient: (ware.imagePath != null &&
                                          ware.imagePath != "")
                                      ? null
                                      : kMainGradiant),
                            ),
                          ),
                          ///top content
                          Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Flexible(
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              CText(
                                                ware.wareName,
                                                color: Colors.white,
                                                textAlign: TextAlign.right,
                                                fontSize: 16,
                                              ),
                                              CText(
                                                ware.description,
                                                color: Colors.white54,
                                                textAlign: TextAlign.right,
                                                fontSize: 10,
                                              ),
                                              Gap(10),
                                              ///action buttons
                                              Wrap(
                                                  children: buttons),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const Gap(5),

                                      ///avatar image holder
                                      Flexible(
                                        child: AspectRatio(
                                          aspectRatio: 1/1,
                                          child: Align(
                                            alignment: Alignment.centerRight,
                                            child: Container(
                                              height: 230,
                                              width: 230,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                  image: (ware.imagePath != null &&
                                                          ware.imagePath != "")
                                                      ? DecorationImage(
                                                          image: FileImage(
                                                              File(ware.imagePath!)),fit: BoxFit.cover)
                                                      : DecorationImage(
                                                          image: const AssetImage(
                                                              "assets/images/empty-image.jpg"),
                                                        )),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      ///info list
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: List.generate(
                              infoMap.length,
                              (index) => InfoPanelRow(
                                  title: infoMap.keys.elementAt(index),
                                  infoList: infoMap.values.elementAt(index)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ].reversed.toList(),
          ),
        ));
  }
}

///
class InfoPanelDesktop extends StatelessWidget {
  const InfoPanelDesktop(
      {super.key, required this.ware, required this.onReload});
  final Ware ware;
  final VoidCallback onReload;
  Map<String, String?> get infoMap => WareInfoPanel(ware: ware).infoMap;
  @override
  Widget build(BuildContext context) {
    ///buttons
    List<Widget> buttons=<Widget>[
      ///delete button
      ActionButton(
        label: "حذف",
        width: 80,
        height: 30,
        borderRadius: 5,
        borderColor: Colors.red,
        bgColor: Colors.black38,
        icon: CupertinoIcons.trash_fill,
        iconSize: 20,
        iconColor: Colors.red,
          onPress: () {
            showDialog(
              context: context,
              builder: (context) => CustomAlert(
                title: "آیا از حذف کالا مورد نظر مطمئن هستید؟",
                onYes: () async {
                 if (ware.images!=null && ware.images!.isNotEmpty){
                   for(String path in ware.images!){
                     await deleteImageFile(path);
                   }
                 }
                  ware.delete();
                  Navigator.pop(context, false);
                  onReload();

                  showSnackBar(context, "کالا مورد نظر حذف شد!",
                      type: SnackType.success);
                },
                onNo: () {
                  Navigator.pop(context, false);
                },
              ),
            );
          },
          ),
      Gap(10),

      ///edit button
      ActionButton(
        label: "ویرایش",
        width: 80,
        height: 30,
        borderRadius: 5,
        icon:Icons.drive_file_rename_outline_sharp,
        iconSize: 20,
        bgColor: Colors.black38,
        iconColor: Colors.orangeAccent,
        borderColor:Colors.orangeAccent,
        onPress: () {
          Navigator.pushNamed(context, AddWareScreen.id,
              arguments: ware);
        },
      ),
    ];
    return Flexible(
      child: Container(
        height: 800,
        width: 550,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: Colors.black54,
                  blurRadius: 5,
                  offset: Offset(1, 2))
            ]),
        child: Stack(
          children: [
            ///whole top part
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SingleChildScrollView(
                controller: ScrollController(),
                child: Column(
                  children: [
                    ///image holder
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        ///ware bg image
                        SizedBox(
                            height: 250,
                            width: 1000,
                            child: (ware.imagePath != null &&
                                ware.imagePath != "")
                                ? Image(
                              image: FileImage(File(ware.imagePath!)),
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, trace) {
                                ErrorHandler.errorManger(
                                    context, error,
                                    route: trace.toString(),
                                    title:
                                    "InfoPanelDesktop widget load image error");
                                return const EmptyHolder(
                                    text:
                                    "بارگزاری تصویر با مشکل مواجه شده است",
                                    icon: Icons
                                        .image_not_supported_outlined);
                              },
                            )
                                : Image.asset(
                                "assets/images/empty-image.jpg")),

                        ///blurry layer
                        GlassBackground(
                          sigma: 5,
                          child: Container(
                            height: 250,
                            decoration: BoxDecoration(
                                color: (ware.imagePath != null &&
                                    ware.imagePath != "")
                                    ? Colors.black26
                                    : null,
                                gradient: (ware.imagePath != null &&
                                    ware.imagePath != "")
                                    ? null
                                    : kMainGradiant),
                          ),
                        ),
                        ///top content
                        Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Flexible(
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                          children: [
                                            CText(
                                              ware.wareName,
                                              color: Colors.white,
                                              textAlign: TextAlign.right,
                                              fontSize: 16,
                                            ),
                                            CText(
                                              ware.description,
                                              color: Colors.white54,
                                              textAlign: TextAlign.right,
                                              fontSize: 10,
                                            ),
                                            Gap(10),
                                            ///action buttons
                                            Wrap(
                                                children: buttons),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const Gap(5),

                                    ///avatar image holder
                                    Flexible(
                                      child: AspectRatio(
                                        aspectRatio: 1/1,
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Container(
                                            height: 230,
                                            width: 230,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                image: (ware.imagePath != null &&
                                                    ware.imagePath != "")
                                                    ? DecorationImage(
                                                    image: FileImage(
                                                        File(ware.imagePath!)),fit: BoxFit.cover)
                                                    : DecorationImage(
                                                  image: const AssetImage(
                                                      "assets/images/empty-image.jpg"),
                                                )),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    ///info list
                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: List.generate(
                            infoMap.length,
                                (index) => InfoPanelRow(
                                title: infoMap.keys.elementAt(index),
                                infoList: infoMap.values.elementAt(index)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ].reversed.toList(),
        ),
      ),
    );
  }
}
