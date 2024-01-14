import 'package:flutter/material.dart';

import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:price_list/constants/constants.dart';
import 'package:price_list/model/notice.dart';
import 'package:price_list/screens/notice_screen/panels/notice_detail_panel.dart';
import 'package:price_list/services/backend_services.dart';

class NoticeScreen extends StatelessWidget {
  static const String id = "/notification-screen";
  const NoticeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("اطلاع رسانی ها"),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          padding: EdgeInsets.only(top: 80),
          decoration: const BoxDecoration(gradient: kMainGradiant),
          child: FutureBuilder(
            future: BackendServices().readNotice(context, "hitop-cafe"),
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.done &&
                  snap.hasData) {
                if (snap.hasData) {
                  return Column(
                    children: snap.data!.map((notice) => NoticeTile(notice: notice!),).toList()


                  );
                } else {
                  return const Center(child: Text("اطلاع رسانی ای یافت نشد"));
                }
              } else if (snap.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return const Center(child: Text("خطا در برقراری ارتباط"));
              }
            },
          ),
        ),
      ),
    );
  }
}

class NoticeTile extends StatelessWidget {
  const NoticeTile({
    super.key,
    required this.notice,
  });

  final Notice notice;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 1,
      child: ListTile(
        title: Text(notice.title),
        subtitle: Text(
          notice.content ?? "",
          style: const TextStyle(fontSize: 11),
        ),
        onTap: () {
          showDialog(
              context: context,
              builder: (context) => NoticeDetailPanel(notice: notice));
        },
        leading: const Icon(Icons.notifications),
        trailing: Text(
          notice.noticeDate?.toPersianDate() ?? "",
          style: const TextStyle(fontSize: 11, color: Colors.black38),
        ),
      ),
    );
  }
}
