// ignore_for_file: non_constant_identifier_names

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:price_list/components/action_button.dart';
import 'package:price_list/components/custom_alert.dart';
import 'package:price_list/components/custom_dialog.dart';
import 'package:price_list/components/empty_holder.dart';
import 'package:price_list/constants/enums.dart';
import 'package:price_list/constants/error_handler.dart';
import 'package:price_list/constants/utils.dart';
import 'package:price_list/model/ware.dart';
import 'package:price_list/screens/ware_list/add_ware_screen.dart';
import 'package:price_list/screens/ware_list/widgets/row_info.dart';

InfoPanel({required BuildContext context, required Ware wareInfo}) {
  return CustomDialog(
    height: MediaQuery.of(context).size.height * .8,
    image: wareInfo.imagePath,
    title: "مشخصات کالا",
    child: Column(
      children: [
        Expanded(
          child: ListView(
            children: <Widget>[
              InfoPanelRow(title: "نام کالا", infoList: wareInfo.wareName),
              InfoPanelRow(
                  title: "سریال کالا", infoList: wareInfo.wareSerial ?? ""),
              InfoPanelRow(title: "سرگروه", infoList: wareInfo.groupName),
              InfoPanelRow(
                  title: "قیمت خرید", infoList: addSeparator(wareInfo.cost)),
              InfoPanelRow(
                  title: "قیمت فروش", infoList: addSeparator(wareInfo.sale)),
              InfoPanelRow(
                  title: "مقدار",
                  infoList: "${wareInfo.quantity} ${wareInfo.unit} "),
              InfoPanelRow(title: "توضیحات", infoList: wareInfo.description),
              InfoPanelRow(
                  title: "تاریخ ثبت",
                  infoList: wareInfo.date.toPersianDateStr()),
              InfoPanelRow(
                  title: "تاریخ ویرایش",
                  infoList: (wareInfo.modifyDate ?? DateTime.now())
                      .toPersianDateStr()),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          children: <Widget>[
            ///delete button
            Flexible(
              child: ActionButton(
                  label: "حذف",
                  bgColor: Colors.red,
                  onPress: () {
                    showDialog(
                      context: context,
                      builder: (context) => CustomAlert(
                        title: "آیا از حذف کالا مورد نظر مطمئن هستید؟",
                        onYes: (){
                          wareInfo.delete();
                          Navigator.pop(context,false);
                          Navigator.pop(context,false);

                          showSnackBar(context, "کالا مورد نظر حذف شد!",
                              type: SnackType.success);
                        },
                        onNo: (){
                          Navigator.pop(context,false);
                        },
                      ),
                    );
                  },
                  icon: Icons.delete),
            ),
            SizedBox(
              width: 10,
            ),

            ///edit button
            Flexible(
              child: ActionButton(
                label: "ویرایش",
                onPress: () {
                  Navigator.pushNamed(context, AddWareScreen.id,
                      arguments: wareInfo);
                },
                icon: Icons.drive_file_rename_outline_sharp,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

InfoPanelDesktop(
    {required BuildContext context,
    required Ware wareInfo,
    required VoidCallback onReload}) {
  return Directionality(
    textDirection: TextDirection.rtl,
    child: Stack(
      children: [
        SingleChildScrollView(
          controller: ScrollController(),
          child: Container(
            height: 700,
            width: 550,
            margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 5),
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            decoration: BoxDecoration(
                color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.black54,blurRadius: 5,offset: Offset(1, 2))]
            ),
            child: Column(
              children: [
                if (wareInfo.imagePath != null && wareInfo.imagePath != "")
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Container(
                      height: 200,
                      padding: EdgeInsets.only(bottom: 20),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image(
                          image: FileImage(File(wareInfo.imagePath!)),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, trace) {
                            ErrorHandler.errorManger(context, error,
                                route: trace.toString(),
                                title: "InfoPanelDesktop widget load image error");
                            return const EmptyHolder(
                                text: "بارگزاری تصویر با مشکل مواجه شده است",
                                icon: Icons.image_not_supported_outlined);
                          },
                        ),
                      ),
                    ),
                  ),
                ///info rows
                Column(
                  children: <Widget>[
                    InfoPanelRow(title: "نام کالا", infoList: wareInfo.wareName),
                    InfoPanelRow(title: "سرگروه", infoList: wareInfo.groupName),
                    InfoPanelRow(
                        title: "قیمت خرید", infoList: addSeparator(wareInfo.cost)),
                    InfoPanelRow(
                        title: "قیمت فروش", infoList: addSeparator(wareInfo.sale)),
                    InfoPanelRow(
                        title: "مقدار",
                        infoList: "${wareInfo.quantity} ${wareInfo.unit} "),
                    InfoPanelRow(
                        title: "توضیحات", infoList: wareInfo.description),
                    InfoPanelRow(
                        title: "تاریخ تغییر",
                        infoList: wareInfo.date.toPersianDateStr()),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),


              ],
            ),
          ),
        ),
        /// buttons
        Container(
          margin: EdgeInsets.all(7),
          alignment: Alignment.bottomCenter,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              ///delete button
              ActionButton(
                  label: "حذف",
                  bgColor: Colors.red,
                  onPress: () {
                    showDialog(
                      context: context,
                      builder: (context) => CustomAlert(
                        title: "آیا از حذف کالا مورد نظر مطمئن هستید؟",
                        onYes: (){
                          wareInfo.delete();
                          Navigator.pop(context,false);
                          onReload();

                          showSnackBar(context, "کالا مورد نظر حذف شد!",
                              type: SnackType.success);
                        },
                        onNo: (){
                          Navigator.pop(context,false);
                        },
                      ),
                    );

                  },
                  icon: Icons.delete),
              Gap(10),

              ///edit button
              ActionButton(
                label: "ویرایش",
                onPress: () {
                  Navigator.pushNamed(context, AddWareScreen.id,
                      arguments: wareInfo);
                },
                icon: Icons.drive_file_rename_outline_sharp,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
