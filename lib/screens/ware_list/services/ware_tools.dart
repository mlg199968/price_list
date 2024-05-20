import 'package:price_list/model/ware.dart';
import 'package:price_list/services/hive_boxes.dart';

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
          return a.wareName.compareTo(b.wareName);
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
