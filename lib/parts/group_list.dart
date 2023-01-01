import 'package:flutter/material.dart';

class GroupList extends ChangeNotifier{
  List dataList=[
    ['Product Name', 'Buy Price', 'Sell Price'],
    ['cell1', 'cell2', 'cell3'],
  ][0];
  List<String> groupList=[
    'mozaik','dddd'

  ];


  void addToList(List<String> dataProduct){
    dataList.add(dataProduct);
    notifyListeners();
    print(dataList.length);
  }
  void removeFromList(List<String> dataProduct) {
    //List<String> reversedList = dataProduct.reversed.toList();
    dataList.remove(dataProduct);
    notifyListeners();
  }

}
