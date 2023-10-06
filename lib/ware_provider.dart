
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WareProvider extends ChangeNotifier{
  bool isVip=false;
 List groupList=["default",];
 String selectedGroup="default";
 String currency="ریال";
 bool showCostPrice = false;
 bool showQuantity = false;



void addGroup(String groupName){
  groupList.insert(0,groupName);
  notifyListeners();
}
void loadGroupList(List groups){
  groupList.addAll(groups);
  groupList=groupList.toSet().toList();
  notifyListeners();
}
void updateSelectedGroup(String newSelect){
  selectedGroup=newSelect;
  notifyListeners();
}
void updateSetting(bool cost,bool quantity){
  showQuantity=quantity;
  showCostPrice=cost;
 // notifyListeners();
}

void setVip(bool input) async{
  SharedPreferences prefs= await SharedPreferences.getInstance();
  prefs.setBool("isVip",input);
 isVip=input;
  notifyListeners();
}

void getVip() async{
  SharedPreferences prefs= await SharedPreferences.getInstance();
  bool? subsInfo= prefs.getBool("isVip");

  if(subsInfo!=null){
    isVip=subsInfo;
  }
  else{
  }
  notifyListeners();
}

// Future<List> getWares(BuildContext context)async{
// List wares =await wareServices.getWares(context);
// notifyListeners();
// return wares;
// }

}