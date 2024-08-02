
import 'package:flutter/foundation.dart';
import '../constants/constants.dart';
import '../constants/enums.dart';
import '../constants/utils.dart';
import '../model/device.dart';
import '../model/shop.dart';
import '../model/subscription.dart';
import '../model/user.dart';
import '../services/hive_boxes.dart';

class UserProvider extends ChangeNotifier {
  bool get isVip=>userLevel==1?true:false;
  int _userLevel = 0;
  // int get userLevel =>_userLevel;
  int get userLevel =>_subscription!=null?_subscription!.userLevel: 0;
  Subscription? _subscription;
  Subscription? get subscription=>_subscription;
  ///check current device match with saved device ,for safety for cracks
  Future<bool> get deviceAuthority async{
    Device currentDevice=await getDeviceInfo();
    if(_subscription != null && _subscription!.device?.id==currentDevice.id){
      return true;
    }else{
      _subscription?.level=0;
      _userLevel=0;
      return false;
    }
  }
  //ceil count is for how many item you can add to list
  int get ceilCount => _userLevel == 0 ? 20 : 1000;
  String ceilCountMessage =
      "این نسخه از برنامه دارای محدودیت حداکثر ده آیتم است ";
  User? _user;
  User? get activeUser => _user;
  String? _appType;
  String? get appType => _appType;
  String? _backupDirectory;
  String? get backupDirectory=>_backupDirectory;
  String _appVersion="0";
  String get appVersion=>_appVersion;


  bool saveBackupOnExist=false;
  //*****
  Shop sampleShop = Shop()
    ..shopName = "shopName"
    ..address = "address"
    ..phoneNumber = "phoneNumber"
    ..phoneNumber2 = ""
    ..currency = "ریال";

  List<Map> descriptionList=[];

  String shopName = "نام فروشگاه";
  String address = "آدرس فروشگاه";
  String phoneNumber = "شماره تلفن اول";
  String phoneNumber2 = "شماره تلفن دوم";
  String description = "توضیحات";
  String? logoImage;
  String? signatureImage;
  String? stampImage;
  String shopCode = "";
  String currency = "تومان";
  double preDiscount = 0;
  int preBillNumber = 1;
  int preTax = 0;

  String _fontFamily = kFonts[0];
  String get fontFamily => _fontFamily;
  String _pdfFont = kFonts[0];
  String get pdfFont => _pdfFont;
  bool _showCostPrice = false;
  bool get showCostPrice => _showCostPrice;
  bool _showQuantity = false;
  bool get showQuantity => _showQuantity;
  Map? currenciesMap;
  bool _replacedCurrency=false;
  bool get replacedCurrency=>_replacedCurrency;


  void getData(Shop shop) {
    shopName = shop.shopName;
    address = shop.address;
    phoneNumber = shop.phoneNumber;
    phoneNumber2 = shop.phoneNumber2;
    description = shop.description;
    logoImage = shop.logoImage;
    signatureImage = shop.signatureImage;
    stampImage = shop.stampImage;
    shopCode = shop.shopCode;
    currency = shop.currency;
    _fontFamily = shop.fontFamily ?? kFonts[0];
    _pdfFont = shop.pdfFont ?? kPdfFonts[0];
    _userLevel = shop.userLevel;
    _showQuantity = shop.showQuantity;
    _showCostPrice = shop.showCost;
    _backupDirectory = shop.backupDirectory;
    currenciesMap=shop.currenciesValue;
    _replacedCurrency=shop.replacedCurrency ?? false;

    _user = shop.activeUser;
    _appType = shop.appType;
    _userLevel = shop.userLevel;
    _subscription=shop.subscription;
    _backupDirectory = shop.backupDirectory;
    if(shop.descriptionList!=null) {
      descriptionList=shop.descriptionList!;
    }

    ///this for just use complete for debug app
    if (kDebugMode) {
      // _userLevel = 0;
    }
  }

  void setUserLevel(int input) async {
    // SharedPreferences prefs= await SharedPreferences.getInstance();
    // prefs.setInt("level",input);
    Shop shop = HiveBoxes.getShopInfo().getAt(0)!;
    shop.userLevel = input;
    HiveBoxes.getShopInfo().putAt(0, shop);
    _userLevel = input;
    notifyListeners();
  }
  ///set subscription
  void setSubscription(Subscription? subs){
    Shop shop = HiveBoxes.getShopInfo().getAt(0)!;
    shop.subscription = subs;
    HiveBoxes.getShopInfo().putAt(0, shop);
    _subscription=subs;
    notifyListeners();
  }
  // void getUserLevel() async{
  //   SharedPreferences prefs= await SharedPreferences.getInstance();
  //   int? subsInfo= prefs.getInt("level");
  //
  //   if(subsInfo!=null){
  //     _userLevel=subsInfo;
  //     if(_userLevel==1) {
  //       _ceilCount=1000;
  //     }
  //   }else{
  //   }
  //
  //   notifyListeners();
  // }

  void updateSetting(bool cost, bool quantity,bool reCurrency) {
    _showQuantity = quantity;
    _showCostPrice = cost;
    _replacedCurrency=reCurrency;
    notifyListeners();
  }

  ///user functions
  setUser(User? user) {
    _user = user;
    notifyListeners();
    if (_appType == AppType.waiter.value) {
      Shop old = HiveBoxes.getShopInfo().values.single;
      old.activeUser = user;
      HiveBoxes.getShopInfo().putAt(0, old);
    }
  }

  removeUser() {
    _user = null;
    notifyListeners();
  }

  ///appType Functions
  setAppType(AppType? type) {
    _appType = type?.value;
    notifyListeners();
  }

  removeAppType() {
    _appType = null;
    notifyListeners();
  }

  setFontFamily(String font) {
    _fontFamily = font;
    notifyListeners();
  }

  setFontFromHive() {
    Shop? shop = HiveBoxes.getShopInfo().get(0);
    if (shop != null && shop.fontFamily != null) {
      _fontFamily = shop.fontFamily!;
    }
  }
  ///item or order description list actions
  addDescription(Map des){
    descriptionList.add(des);
    notifyListeners();

  }
  removeDescription(Map des){
    descriptionList.remove(des);
    notifyListeners();
    Shop shop=HiveBoxes.getShopInfo().values.single;
    shop.descriptionList=descriptionList;
    HiveBoxes.getShopInfo().putAt(0, shop);
  }
  sortDescription(String? id){
    descriptionList.sort((a,b) {
      if(a["id"]==id) {
        return -1;
      }else{
        return 1;
      }
    });
    // notifyListeners();
  }
  ///
  setAppVersion(String version){
    _appVersion=version;
    notifyListeners();
  }
}
