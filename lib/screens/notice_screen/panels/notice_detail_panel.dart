import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:price_list/components/custom_button.dart';
import 'package:price_list/components/notification_dialog.dart';
import 'package:price_list/constants/utils.dart';
import 'package:price_list/model/notice.dart';

class NoticeDetailPanel extends StatelessWidget {
  const NoticeDetailPanel({super.key, required this.notice});
  final Notice notice;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: NotificationDialog(
        height: 500,
        contentPadding: const EdgeInsets.all(0),
        borderRadius: 18,
        opacity: 1,
        image: notice.image,
        title: notice.noticeDate?.toPersianDateStr() ?? "",
        actions:(notice.link != null && notice.link != "")? [
          Flexible(
            child: Align(
              alignment: Alignment.center,
              child: CustomButton(
                height: 40,
                width: 300,
                text: notice.linkTitle ?? "",
                icon: const Icon(CupertinoIcons.link,color: Colors.white,size: 20,),
                radius: 10,
                color: Colors.red,
                onPressed: () {
                  urlLauncher(context: context, urlTarget: notice.link!);
                },
              ),
            ),
          ),
        ]:null,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Text(
                notice.title,
                style: const TextStyle(fontSize: 16),
                maxLines: 4,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                notice.content ?? "",
                style: const TextStyle(
                    fontSize: 12, color: Colors.black54),
                maxLines: 200,
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
