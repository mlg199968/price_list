import 'package:price_list/model/product.dart';


class WareTools {
  /// search and sort the ware List
  static List<Product> filterList(
      List<Product> list, String? keyWord, String sort) {
    if (keyWord != null) {
      list = list.where((element) {
        String productName = element.productName.toLowerCase().replaceAll(" ", "");
        //String serial=element.serialNumber.toLowerCase().replaceAll(" ", "");
        String key = keyWord.toLowerCase().replaceAll(" ", "");
        if (productName.contains(key)) {
          return true;
        } else {
          return false;
        }
      }).toList();
    }
    switch (sort) {
      case "حروف الفبا":
        list.sort((a, b) {
          return a.productName.compareTo(b.productName);
        });
        //break;
      // case "موجودی کالا":
      //   list.sort((b, a) {
      //     return a.quantity.compareTo(b.quantity);
      //   });
      //   break;

      // case "تاریخ ثبت":
      //   list.sort((b, a) {
      //     return a..compareTo(b.date);
      //   });
      //   break;
    }
    return list;
  }
}
