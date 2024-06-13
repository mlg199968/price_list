import 'package:price_list/constants/global_task.dart';
import 'package:price_list/model/ware.dart';
import 'package:price_list/providers/ware_provider.dart';
import 'package:price_list/services/hive_boxes.dart';
import 'package:provider/provider.dart';

class WareTools {
  /// search and sort the ware List
  static List<Ware> filterList(
      List<Ware> list, String? keyWord, String sort, String category) {
    list = list
        .where((ware) => category == ware.groupName || category == "همه"|| category == "selected")
        .toList();
    if (keyWord != null) {
      list = list.where((element) {
        String wareName = element.wareName.toLowerCase().replaceAll(" ", "");
        String serial =
            element.wareSerial.toString().toLowerCase().replaceAll(" ", "");
        String description =
            element.description.toString().toLowerCase().replaceAll(" ", "");
        String groupName =
            element.groupName.toString().toLowerCase().replaceAll(" ", "");
        String key = keyWord.toLowerCase().replaceAll(" ", "");
        if (wareName.contains(key) ||
            serial.contains(key) ||
            description.contains(key) ||
            groupName.contains(key)) {
          return true;
        } else {
          return false;
        }
      }).toList();
    }
    switch (sort) {
      case "حروف الفبا":
        list.sort((a, b) {
          String a1=a.wareName.toLowerCase().replaceAll(" ", "");
          String b1=b.wareName.toLowerCase().replaceAll(" ", "");
          return a1.compareTo(b1);
        });
        break;
      case "موجودی کالا":
        list.sort((b, a) {
          return a.quantity.compareTo(b.quantity);
        });
        break;

      case "تاریخ ثبت":
        list.sort((b, a) {
          return a.date.compareTo(b.date);
        });
        break;
      case "تاریخ ویرایش":
        list.sort((b, a) {
          return (a.modifyDate ?? DateTime.now())
              .compareTo(b.modifyDate ?? DateTime.now());
        });
        break;
    }
    return list;
  }
double currencyCheck(String currency){

    return 0;
}
///sort ware list with group sort
static List<Ware> sortGroups(List<Ware> wareList){
    List<Ware> sortedList=[];
    List groupList=Provider.of<WareProvider>(GlobalTask.navigatorState.currentContext!,listen: false).groupList;
    for(String group in groupList){
      for(Ware ware in wareList){
        if(ware.groupName==group){
          sortedList.add(ware);
        }
      }
    }
    return sortedList;
}
  ///group exist condition
  ///check if all ware with same group name are exist in the selected wares
  static bool groupExist(
      {required List<Ware> selectedWares,
      required String group}) {
    List<Ware> allWares=HiveBoxes.getWares().values.toList();
    int allGroupCount =
        allWares.where((element) => element.groupName == group).length;
    int selectedGroupCount =
        selectedWares.where((element) => element.groupName == group).length;
    if (allGroupCount == selectedGroupCount) {
      return true;
    } else {
      return false;
    }
  }
}
