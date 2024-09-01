import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:price_list/components/action_button.dart';
import 'package:price_list/components/custom_alert.dart';
import 'package:price_list/components/custom_button.dart';
import 'package:price_list/components/custom_dialog.dart';
import 'package:price_list/components/empty_holder.dart';
import 'package:price_list/constants/enums.dart';
import 'package:price_list/constants/error_handler.dart';
import 'package:price_list/constants/utils.dart';
import 'package:price_list/model/ware.dart';
import 'package:price_list/screens/ware_list/add_ware_screen.dart';
import 'package:price_list/screens/ware_list/widgets/row_info.dart';

class InfoPanel extends StatelessWidget {
  const InfoPanel({super.key,required this.ware});
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
    return CustomDialog(
      height: 600,
      contentPadding: EdgeInsets.zero,
      image: ware.imagePath,
      actions: [
        Row(
          children: <Widget>[
            ///delete button
            CustomButton(
                text: "حذف",
                width: 100,
                height: 30,
                color: Colors.red,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => CustomAlert(
                      title: "آیا از حذف کالا مورد نظر مطمئن هستید؟",
                      onYes: ()async{
                        await deleteImageFile(ware.imagePath);
                        ware.delete();
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
                icon: const Icon(CupertinoIcons.trash_fill,
                  size: 20,
                  color: Colors.white70,)),
            SizedBox(
              width: 10
            ),
            ///edit button
            CustomButton(
              text: "ویرایش",
              width: 100,
              height: 30,
              onPressed: () {
                Navigator.pushNamed(context, AddWareScreen.id,
                    arguments: ware);
              },
              icon: const Icon(Icons.drive_file_rename_outline_sharp,size: 20,
                color: Colors.orangeAccent,),
            ),
          ],
        ),
      ],
      title: "مشخصات کالا",
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: List.generate(
                infoMap.length,
                    (index) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: InfoPanelRow(
                      title: infoMap.keys.elementAt(index),
                      infoList: infoMap.values.elementAt(index)),
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}



class InfoPanelDesktop extends StatelessWidget {
  const InfoPanelDesktop({super.key, required this.ware, required this.onReload});
  final Ware ware;
  final VoidCallback onReload;
  Map<String, String?> get infoMap =>InfoPanel(ware: ware).infoMap;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Stack(
        children: [
          Container(
            height: 700,
            width: 550,
            margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 5),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [BoxShadow(color: Colors.black54,blurRadius: 5,offset: Offset(1, 2))]
            ),
            child: SingleChildScrollView(
              controller: ScrollController(),
              child: Column(
                children: [
                  if (ware.imagePath != null && ware.imagePath != "")
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Container(
                        height: 200,
                        padding: EdgeInsets.only(bottom: 20),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image(
                            image: FileImage(File(ware.imagePath!)),
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
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    child: Column(
                      children: List.generate(
                        infoMap.length,
                            (index) => InfoPanelRow(
                            title: infoMap.keys.elementAt(index),
                            infoList: infoMap.values.elementAt(index)),
                      ),
                    ),
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
                          onYes: ()async{
                            await deleteImageFile(ware.imagePath);
                            ware.delete();
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
                        arguments: ware);
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
}

