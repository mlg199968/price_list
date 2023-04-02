
import 'package:flutter/material.dart';

class WareProvider extends ChangeNotifier{
 List groupList=["default",];
 String selectedGroup="default";
 String connectionState="waiting";




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



// Future<List> getWares(BuildContext context)async{
// List wares =await wareServices.getWares(context);
// notifyListeners();
// return wares;
// }

}