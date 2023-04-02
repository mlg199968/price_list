// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:price_list/add_ware/add_ware_screen.dart';
import 'package:price_list/components/custom_alert_dialog.dart';
import 'package:price_list/constants/utils.dart';
import 'package:price_list/model/ware_hive.dart';

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
              InfoPanelRow(title: "سرگروه", infoList: wareInfo.groupName),
              InfoPanelRow(
                  title: "قیمت خرید", infoList: addSeparator(wareInfo.cost)),
              InfoPanelRow(
                  title: "قیمت فروش", infoList: addSeparator(wareInfo.sale)),
              InfoPanelRow(
                  title: "مقدار", infoList: "${wareInfo.quantity} ${wareInfo.unit} "),
              InfoPanelRow(title: "توضیحات", infoList: wareInfo.description),
              InfoPanelRow(
                  title: "تاریخ تغییر", infoList: wareInfo.date.toPersianDateStr()),
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

class ActionButton extends StatelessWidget {
  const ActionButton(
      {super.key,
      required this.onPress,
      required this.icon,
      this.bgColor = Colors.blue});

  final VoidCallback onPress;
  final IconData icon;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: const EdgeInsets.all(0),
      iconSize: 30,
      onPressed: onPress,
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Icon(
          icon,
          color: Colors.white,
        ),
      ),
    );
  }
}

class InfoPanelRow extends StatelessWidget {
  const InfoPanelRow({super.key, required this.infoList, required this.title});

  final String infoList;
  final String title;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
            border: Border(
                bottom: BorderSide(
          color: Colors.white70,
        ))),
        width: MediaQuery.of(context).size.width * .5,
        padding: const EdgeInsets.only(bottom: 10),
        margin: const EdgeInsets.only(bottom: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title.toPersianDigit()),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              flex: 1,
              child: Text(
                infoList.toPersianDigit(),
                textAlign: TextAlign.left,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
