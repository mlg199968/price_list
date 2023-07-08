
import 'package:flutter/material.dart';

class WareProvider extends ChangeNotifier{
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



// Future<List> getWares(BuildContext context)async{
// List wares =await wareServices.getWares(context);
// notifyListeners();
// return wares;
// }

}