import 'package:flutter/material.dart';




class FinalList extends ChangeNotifier{
  String groupDropListValue='همه';
  String selectedGroup="همه";
  bool hideNavBar=true;

  List dataList=[
  ];
  List groupList=[
    'همه',
  ];



  void addToList(List<String> dataProduct){
    dataList.add(dataProduct);
    notifyListeners();


  }
  void removeFromList(List<String> dataProduct) {
    dataList.remove(dataProduct);
    notifyListeners();
  }
  void groupDropListValueUpdate(String value){
    groupDropListValue=value;
    notifyListeners();
  }
  void addToGroupList(String groupName){
    groupList.add(groupName);
    notifyListeners();
  }

}



