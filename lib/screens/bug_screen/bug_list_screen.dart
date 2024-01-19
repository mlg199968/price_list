import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:price_list/constants/constants.dart';
import 'package:price_list/model/bug.dart';
import 'package:price_list/screens/bug_screen/panels/bug_detail_panel.dart';
import 'package:price_list/services/hive_boxes.dart';

class BugListScreen extends StatelessWidget {
  static const String id = "/bug-screen";
  const BugListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("لیست خطا ها"),
      ),
      body: Directionality(
        textDirection: TextDirection.ltr,
        child: Container(
          decoration: const BoxDecoration(gradient: kBlackWhiteGradiant),
          child: ValueListenableBuilder(
            valueListenable: HiveBoxes.getBugs().listenable(),
            builder: (context, snap,child) {
                if (snap.isNotEmpty) {
                  return SingleChildScrollView(
                    child: Column(
                        children: snap.values.map((bug) => ErrorTile(bug: bug),).toList()
                    ),
                  );
                } else {
                  return const Center(child: Text("خطایی یافت نشد"));
                }

            },
          ),
        ),
      ),
    );
  }
}

class ErrorTile extends StatelessWidget {
  const ErrorTile({
    super.key,
    required this.bug,
  });

  final Bug bug;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 1,
      child: ListTile(
        title: Text(bug.title ?? ""),
        subtitle: Text(
          bug.errorText ?? "",
          style: const TextStyle(fontSize: 11),
        ),
        onTap: () {
          showDialog(
              context: context,
              builder: (context) =>BugDetailPanel(bug: bug));
        },
        leading: const Icon(Icons.error_outline),
        trailing: Text(
          bug.bugDate.toPersianDate(),
          style: const TextStyle(fontSize: 11, color: Colors.black38),
        ),
      ),
    );
  }
}
