import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:price_list/components/action_button.dart';
import 'package:price_list/components/empty_holder.dart';
import 'package:price_list/constants/constants.dart';
import 'package:price_list/constants/error_handler.dart';
import 'package:price_list/model/bug.dart';
import 'package:price_list/screens/bug_screen/panels/bug_detail_panel.dart';
import 'package:price_list/services/hive_boxes.dart';

import '../../components/dynamic_button.dart';

class BugListScreen extends StatelessWidget {
  static const String id = "/bug-screen";
  const BugListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("لیست خطا ها"),
        actions: [
          DynamicButton(
            label: " اشتراک گذاری",
            onPress: ()async{
             await ErrorHandler().shareErrors();
            },
          ),
        ],
      ),
      body: Directionality(
        textDirection: TextDirection.ltr,
        child: Container(
          decoration: const BoxDecoration(gradient: kBlackWhiteGradiant),
          child: ValueListenableBuilder(
            valueListenable: HiveBoxes.getBugs().listenable(),
            builder: (context, snap,child) {
              List<Bug> bugList=snap.values.toList();

              if (snap.isNotEmpty) {
                bugList.sort((b,a){
                  return a.bugDate.compareTo(b.bugDate);
                });
                if(bugList.length>200){
                  bugList.last.delete();
                }
                return ListView.builder(
                  itemCount: bugList.length,
                   itemBuilder :(context,index){
                     return ErrorTile(bug: bugList[index]);
                   }
                );
              } else {
                return EmptyHolder(text: "خطایی یافت نشد",icon: Icons.error_outline_rounded,);
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
      surfaceTintColor: Colors.white,
      elevation: 1,
      child: ListTile(
        title: Text(bug.title ?? ""),
        subtitle: Text(
          bug.errorText ?? "",
          style: const TextStyle(fontSize: 11),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
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