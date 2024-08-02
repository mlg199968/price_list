import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:price_list/constants/constants.dart';
import 'package:price_list/constants/global_task.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';

part 'ware.g.dart';

@HiveType(typeId: 0)
class Ware extends HiveObject {
  @HiveField(0)
  late String wareName;
  @HiveField(1)
  late String unit;
  @HiveField(2)
  late String groupName;
  @HiveField(3)
  String description = "";
  @HiveField(4)
  num cost = 0;
  @HiveField(5)
  num sale = 0;
  @HiveField(6)
  num quantity = 0;
  @HiveField(7)
  DateTime date = DateTime.now();
  @HiveField(8)
  late String? wareID;
  @HiveField(9)
  bool? isChecked = false;
  @HiveField(10)
  String? color = "";
  @HiveField(11)
  DateTime? modifyDate = DateTime.now();
  @HiveField(12)
  String? wareSerial = "";
  @HiveField(13)
  String? imagePath;
  @HiveField(14)
  double? discount;
  @HiveField(15)
  num? sale2;
  @HiveField(16)
  num? sale3;
  @HiveField(17)
  int? saleIndex;


  num get selectedSale {
    num selectedSale = saleIndex == 0
        ? sale
        : saleIndex == 1
        ? (sale2 ?? 0)
        : (sale3 ?? 0);
    UserProvider wareProvider = Provider.of<UserProvider>(
        GlobalTask.navigatorState.currentContext!,
        listen: false);
    if (wareProvider.currency != "تومان" &&
        wareProvider.currenciesMap != null &&
        wareProvider.replacedCurrency) {
      double cValue = wareProvider
              .currenciesMap![kCurrencyListMap[wareProvider.currency]] ??
          0;
      return selectedSale * cValue;
    } else {
      return selectedSale;
    }
  }
  num get saleConverted {
    if(discount!=null){
      return selectedSale-(selectedSale*discount!/100);
    }else{
      return selectedSale;
    }
  }
  Map<String, dynamic> toMap() {
    return {
      'wareName': wareName,
      'wareSerial': wareSerial,
      'unit': unit,
      'groupName': groupName,
      'description': description,
      'cost': cost,
      'sale': sale,
      'sale2': sale2,
      'sale3': sale3,
      'quantity': quantity,
      'date': date.toIso8601String(),
      'modifyDate': modifyDate!.toIso8601String(),
      'wareID': wareID,
      'isChecked': isChecked! ? 1 : 0,
      'color': color,
      'imagePath': imagePath,
      'saleIndex': saleIndex
    };
  }

  Ware fromMap(Map<String, dynamic> map) {
    Ware ware = Ware()
      ..wareName = map['wareName'] ?? ""
      ..wareSerial = map['wareSerial'] ?? ""
      ..unit = map['unit'] ?? ""
      ..groupName = map['groupName'] ?? ""
      ..description = map['description'] ?? ""
      ..cost = map['cost'] ?? 0
      ..sale = map['sale'] ?? 0
      ..sale2 = map['sale2']
      ..sale3 = map['sale3']
      ..quantity = map['quantity'] ?? 0
      ..date = DateTime.parse(map['date'])
      ..modifyDate = DateTime.parse(map["modifyDate"])
      ..wareID = map['wareID'] ?? ""
      ..isChecked = map['isChecked'] == 1 ? true : false
      ..color = map['color']
      ..saleIndex = map['saleIndex'] ?? 0
      ..imagePath = map['imagePath'];
    return ware;
  }

  String toJson() => jsonEncode(toMap());
  Ware fromJson(String source) => fromMap(jsonDecode(source));
}

//run this code for create adaptor:
//flutter packages pub run build_runner build --delete-conflicting-outputs
//dart run build_runner build --delete-conflicting-outputs
