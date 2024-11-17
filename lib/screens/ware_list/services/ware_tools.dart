import 'package:price_list/constants/global_task.dart';
import 'package:price_list/model/ware.dart';
import 'package:price_list/model/ware_bool.dart';
import 'package:price_list/providers/ware_provider.dart';
import 'package:price_list/services/hive_boxes.dart';
import 'package:provider/provider.dart';

class WareTools {
  /// search and sort the ware List
  static List<Ware> filterList(
      List<Ware> list, String? keyWord, String sort, String category,{bool reversed=false}) {
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
      case "ترتیب شخصی":
        list.sort((b, a) {
          return (b.sortIndex ?? 0)
              .compareTo(a.sortIndex ?? 1);
        });
        break;
      case "قیمت":
        list.sort((b, a) {
          return (a.saleConverted)
              .compareTo(b.saleConverted);
        });
        break;
    }
    return reversed?list.reversed.toList():list;
  }

  static List<Ware> filterForExport(
      List<Ware> list, {
        DateTime? modifiedDate,
        DateTime? createDate,
        WareBool? exportMap,
        String? category,
      }) {
    List<Ware> result = list;
    if(category!= null) {
      result = result
          .where((ware) =>
              category == ware.groupName ||
              category == "همه" ||
              category == "selected")
          .toList();
    }
    // فیلتر بر اساس تاریخ اصلاح
    if (modifiedDate != null) {
      result = result.where((ware) => ware.modifyDate != null && modifiedDate.isBefore(ware.modifyDate!)).toList();
    }

    // فیلتر بر اساس تاریخ ایجاد
    if (createDate != null) {
      result = result.where((ware) => createDate.isBefore(ware.date)).toList();
    }

    // فیلتر بر اساس WareBool
    if (exportMap != null) {
      result = result.map((ware) {
        // اگر "cost" در WareBool فالس است، مقدار قیمت خرید را صفر قرار می‌دهیم
        if (!exportMap.cost) {
          ware.cost = 0;
        }

        // اگر "sale" در WareBool فالس است، قیمت فروش را صفر می‌کنیم
        if (!exportMap.sale) {
          ware.sale = 0;
        }

        // اگر "sale2" در WareBool فالس است، قیمت فروش2 را صفر می‌کنیم
        if (!exportMap.sale2) {
          ware.sale2 = 0;
        }

        // اگر "sale3" در WareBool فالس است، قیمت فروش3 را صفر می‌کنیم
        if (!exportMap.sale3) {
          ware.sale3 = 0;
        }

        // اگر "count" در WareBool فالس است، تعداد را صفر می‌کنیم
        if (!exportMap.count) {
          ware.quantity = 0;
        }

        // اگر "des" در WareBool فالس است، توضیحات را null می‌کنیم
        if (!exportMap.des) {
          ware.description = "";
        }

        // اگر "serial" در WareBool فالس است، سریال را null می‌کنیم
        if (!exportMap.serial) {
          ware.wareSerial = null;
        }

        return ware;
      }).toList();
    }

    return result;
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
  /// null item in model fix
  static void wareNullFixer(){
    List<Ware> wares=HiveBoxes.getWares().values.toList();
    for(Ware ware in wares){
      if(ware.saleIndex==null){
        ware.saleIndex=0;
        HiveBoxes.getWares().put(ware.wareID, ware);
      }
    }
  }
}
