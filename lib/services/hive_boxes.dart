import 'package:hive_flutter/adapters.dart';
import 'package:price_list/model/bug.dart';
import 'package:price_list/model/notice.dart';
import 'package:price_list/model/shop.dart';
import 'package:price_list/model/ware.dart';
import 'package:hive/hive.dart';







class HiveBoxes {


static Box<Ware> getWares(){
  return Hive.box<Ware>("ware_db");
}
static Box<Shop> getShopInfo(){
  return Hive.box<Shop>("shop_db");
}

static Box<Bug> getBugs(){
  return Hive.box<Bug>("bug_db");
}

static Box<Notice> getNotice(){
  return Hive.box<Notice>("notice_db");
}

static List getGroupWares(){
 final groupList=
 Hive.box<Ware>("ware_db").values.map((e) => e.groupName).toList();
  return groupList;
}

}