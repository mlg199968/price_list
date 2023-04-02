import 'package:hive_flutter/adapters.dart';
import 'package:price_list/model/ware_hive.dart';
import 'package:hive/hive.dart';







class HiveBoxes {


static Box<WareHive> getWares(){
  return Hive.box<WareHive>("ware_db");
}
static List getGroupWares(){
 final groupList= Hive.box<WareHive>("ware_db").values.map((ware) => ware.groupName).toSet().toList();
  return groupList;
}

}