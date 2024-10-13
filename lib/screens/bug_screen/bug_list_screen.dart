import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:price_list/components/action_button.dart';
import 'package:price_list/components/custom_alert.dart';
import 'package:price_list/components/custom_icon_button.dart';
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.black38,
        title: const Text("لیست خطا ها"),
        bottom:PreferredSize(
      preferredSize: const Size.fromHeight(20),
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            Flexible(
              child: DynamicButton(
                label: " اشتراک گذاری",
                icon: Icons.share,
                bgColor: Colors.black38,
                borderColor: Colors.blueAccent,
                iconColor: Colors.blueAccent,
                onPress: ()async{
                  await ErrorHandler().shareErrors(context);
                },
              ),
            ),
            Flexible(
              child: ActionButton(
                label: "پاک کردن",
                icon: Icons.cleaning_services_rounded,
                bgColor: Colors.black38,
                borderColor: Colors.red,
                iconColor: Colors.redAccent,
                onPress: ()async{
                  showDialog(context: context, builder: (_)=>CustomAlert(
                    title: "آیا از پاک کردن لیست خطا ها مطمئن هستید؟",
                    onYes: (){
                      HiveBoxes.getBugs().clear();
                    },
                  ),
                  );
              
                },
              ),
            ),
          ],),

        )),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: Colors.black,
              // gradient: kBlackWhiteGradiant
          ),
          child: SizedBox(
            width: 600,
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
                  return EmptyHolder(text: "خطایی یافت نشد",icon: Icons.error_outline_rounded,color: Colors.white,);
                }

              },
            ),
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

        leading: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline,color: Colors.amber,),
            Flexible(
              child: Text(
                bug.bugDate.toPersianDate(),
                style: const TextStyle(fontSize: 11, color: Colors.black38),
              ),
            ),
            Text(
              "${bug.bugDate.hour}:${bug.bugDate.minute}",
              style: const TextStyle(fontSize: 9, color: Colors.black45),
            ),
          ],
        ),
      ),
    );
  }
}