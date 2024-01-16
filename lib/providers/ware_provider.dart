
import 'package:flutter/material.dart';
import 'package:price_list/constants/constants.dart';
import 'package:price_list/model/shop.dart';
import 'package:price_list/screens/notice_screen/services/notice_tools.dart';
import 'package:price_list/services/hive_boxes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WareProvider extends ChangeNotifier{
  int _userLevel=0;
  int get userLevel=>_userLevel;
  bool isVip=false;
 List groupList=["default",];
 String selectedGroup="default";
 String currency="ریال";
 String _fontFamily=kFonts[0];
 String get fontFamily=>_fontFamily;
 bool _showCostPrice = false;
 bool get showCostPrice => _showCostPrice;
 bool _showQuantity = false;
 bool get showQuantity => _showQuantity;





  //*****
  String shopName="نام فروشگاه";
  String address="آدرس فروشگاه";
  String phoneNumber="شماره تلفن اول";
  String phoneNumber2="شماره تلفن دوم";
  String description="توضیحات";
  String? logoImage;
  String? signatureImage;
  String? stampImage;
  String shopCode="";




  void getData(Shop shop){
    shopName=shop.shopName;
    address=shop.address;
    phoneNumber=shop.phoneNumber;
    phoneNumber2=shop.phoneNumber2;
    description=shop.description;
    logoImage=shop.logoImage;
    signatureImage=shop.signatureImage;
    stampImage=shop.stampImage;
    shopCode=shop.shopCode;
    currency=shop.currency;
    _fontFamily=shop.fontFamily ?? kFonts[0];
    _userLevel=shop.userLevel;
    _showQuantity=shop.showQuantity;
    _showCostPrice=shop.showCost;


  }


  void setUserLevel(int input) async{
    Shop shop=HiveBoxes.getShopInfo().getAt(0)!;
    shop.userLevel=input;
    HiveBoxes.getShopInfo().putAt(0, shop);
    _userLevel=input;
    notifyListeners();
  }


  void addGroup(String groupName){
  groupList.insert(0,groupName);
  notifyListeners();
}
void loadGroupList(List groups){
  groupList.addAll(groups);
  groupList=groupList.toSet().toList();
  //notifyListeners();
}
void updateSelectedGroup(String newSelect){
  selectedGroup=newSelect;
  notifyListeners();
}
void updateSetting(bool cost,bool quantity){
  _showQuantity=quantity;
  _showCostPrice=cost;
  notifyListeners();
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
    //notifyListeners();
  }


}
  getFontFamily(String? font){
    if(font!=null) {
      _fontFamily = font;
      notifyListeners();
    }
  }

// Future<List> getWares(BuildContext context)async{
// List wares =await wareServices.getWares(context);
// notifyListeners();
// return wares;
// }

}