import 'package:flutter/foundation.dart';
import 'package:price_list/services/hive_boxes.dart';

class WareProvider extends ChangeNotifier {
  int _userLevel = 0;
  int get userLevel => _userLevel;

  List _groupList = [
    "default",
  ];
  List get groupList => _groupList;

  String selectedGroup = "default";




  void addGroup(String groupName) {
    groupList.insert(0, groupName);
    notifyListeners();
  }

  void loadGroupList() {
    List groups = HiveBoxes.getGroupWares();
    for (String group in groups) {
      if (!_groupList.contains(group)) {
        _groupList.add(group);
      }
    }
    // groupList.addAll(groups);
    // groupList=groupList.toSet().toList();
  }

  void updateSelectedGroup(String newSelect) {
    selectedGroup = newSelect;
    notifyListeners();
  }



  // void setVip(bool input) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setBool("isVip", input);
  //   isVip = input;
  //   notifyListeners();
  // }

  // void getVip() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   bool? subsInfo = prefs.getBool("isVip");
  //
  //   if (subsInfo != null) {
  //     isVip = subsInfo;
  //   }
  //   // if(kDebugMode) {
  //   //   isVip = false;
  //   // }
  // }




// Future<List> getWares(BuildContext context)async{
// List wares =await wareServices.getWares(context);
// notifyListeners();
// return wares;
// }
}
