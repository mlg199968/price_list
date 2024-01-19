import 'package:flutter/material.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:price_list/components/custom_alert_dialog.dart';
import 'package:price_list/components/custom_button.dart';
import 'package:price_list/constants/utils.dart';
import 'package:price_list/model/notice.dart';

class NoticeDetailPanel extends StatelessWidget {
  const NoticeDetailPanel({super.key, required this.notice});
  final Notice notice;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: CustomDialog(
        contentPadding: EdgeInsets.all(0),
        borderRadius: 8,
        opacity: 1,
        height: 450,
        title: notice.noticeDate?.toPersianDateStr() ?? "",
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ///image
                  if(notice.image!=null && notice.image!="")
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        image:DecorationImage(image:NetworkImage(notice.image!),fit: BoxFit.fitHeight)),
                    child: AspectRatio(aspectRatio: 16 / 9),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Text(
                          notice.title,
                          style: const TextStyle(fontSize: 20),
                          maxLines: 4,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          notice.content ?? "",
                          style: const TextStyle(
                              fontSize: 14, color: Colors.black87),
                          maxLines: 200,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (notice.link != null && notice.link != "")
              Container(
                margin: EdgeInsets.all(20),
                alignment: Alignment.bottomCenter,
                child: CustomButton(
                  height: 40,
                  text: notice.linkTitle ?? "",
                  onPressed: () {
                    urlLauncher(context: context, urlTarget: notice.link!);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
