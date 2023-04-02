import 'dart:convert';

import 'package:hive/hive.dart';


part 'ware_hive.g.dart';
@HiveType(typeId: 0)
class WareHive extends HiveObject {
@HiveField(0)
 late String wareName;
@HiveField(1)
 late String unit;
@HiveField(2)
 late String groupName;
@HiveField(3)
String description="";
@HiveField(4)
num cost=0;
@HiveField(5)
 num sale=0;
@HiveField(6)
num quantity=0;
@HiveField(7)
DateTime date=DateTime.now();
@HiveField(8)
 late String? wareID;
@HiveField(9)
bool? isChecked=false;
@HiveField(10)
String? color="";

Map<String, dynamic> toMap() {
    return {
      'wareName': wareName,
      'unit': unit,
      'groupName': groupName,
      'description': description,
      'cost': cost,
      'sale': sale,
      'quantity': quantity,
      'date': date.toIso8601String(),
      'wareID': wareID,
      'isChecked': isChecked! ?1:0,
      'color' : color
    };
  }

WareHive fromMap(Map<String, dynamic> map) {
 WareHive ware= WareHive()
  ..wareName= map['wareName'] ?? ""
  ..unit= map['unit'] ?? ""
  ..groupName= map['groupName'] ?? ""
  ..description= map['description'] ?? ""
  ..cost= map['cost'] ?? 0
  ..sale= map['sale'] ?? 0
  ..quantity= map['quantity'] ?? 0
  ..date= DateTime.parse(map['date'])
  ..wareID= map['wareID'] ?? ""
  ..isChecked= map['isChecked']==1?true:false
 ..color=map['color'];
 return ware;
}

String toJson() => jsonEncode(toMap());
WareHive fromJson(String source) => fromMap(jsonDecode(source));
}


//run this code for create adaptor:
//flutter packages pub run build_runner build --delete-conflicting-outputs