// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:price_list/components/custom_alert_dialog.dart';
import 'package:price_list/constants/utils.dart';
import 'package:price_list/model/ware_hive.dart';
import 'package:price_list/screens/add_ware/add_ware_screen.dart';
import 'package:price_list/screens/ware_list/widgets/action_button.dart';
import 'package:price_list/screens/ware_list/widgets/row_info.dart';

InfoPanel({required BuildContext context, required WareHive wareInfo}) {
  return CustomAlertDialog(
    height: MediaQuery.of(context).size.height * .5,
    context: context,
    title: "مشخصات کالا",
    child: Column(
      children: [
        Expanded(
          child: ListView(
            children: <Widget>[
              InfoPanelRow(title: "نام کالا", infoList: wareInfo.wareName),
              InfoPanelRow(title: "سریال کالا", infoList: wareInfo.wareSerial ?? ""),
              InfoPanelRow(title: "سرگروه", infoList: wareInfo.groupName),
              InfoPanelRow(
                  title: "قیمت خرید", infoList: addSeparator(wareInfo.cost)),
              InfoPanelRow(
                  title: "قیمت فروش", infoList: addSeparator(wareInfo.sale)),
              InfoPanelRow(
                  title: "مقدار", infoList: "${wareInfo.quantity} ${wareInfo.unit} "),
              InfoPanelRow(title: "توضیحات", infoList: wareInfo.description),
              InfoPanelRow(
                  title: "تاریخ ثبت", infoList: wareInfo.date.toPersianDateStr()),
            InfoPanelRow(
                  title: "تاریخ ویرایش", infoList: wareInfo.modifyDate!.toPersianDateStr()),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ///delete button
            ActionButton(
                bgColor: Colors.red,
                onPress: () {
                  wareInfo.delete();
                  Navigator.pop(context);
                },
                icon: Icons.delete),

            ///edit button
            ActionButton(
              onPress: () {
                Navigator.pushNamed(context, AddWareScreen.id,
                    arguments: wareInfo);
              },
              icon: Icons.drive_file_rename_outline_sharp,
            ),
          ],
        ),
      ],
    ),
  );
}

