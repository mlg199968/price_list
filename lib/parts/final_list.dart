import 'package:flutter/material.dart';




class FinalList extends ChangeNotifier{

  List groupList=[];

  void addToGroupList(List groups){
    groupList.addAll(groups);
    notifyListeners();
  }

}



