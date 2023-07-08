import 'package:price_list/model/ware_hive.dart';

class WareTools {
  /// search and sort the ware List
  static List<WareHive> filterList(
      List<WareHive> list, String? keyWord, String sort) {
    if (keyWord != null) {
      list = list.where((element) {
        String wareName = element.wareName.toLowerCase().replaceAll(" ", "");
        //String serial=element.serialNumber.toLowerCase().replaceAll(" ", "");
        String key = keyWord.toLowerCase().replaceAll(" ", "");
        if (wareName.contains(key)) {
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
          return a.modifyDate!.compareTo(b.modifyDate!);
        });
        break;
    }
    return list;
  }
}
