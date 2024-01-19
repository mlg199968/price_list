import 'package:hive/hive.dart';

part 'shop.g.dart';

@HiveType(typeId: 6)
class Shop extends HiveObject {
  @HiveField(0)
  String shopName="نام فروشگاه";
  @HiveField(1)
  String address="آدرس فروشگاه";
  @HiveField(2)
  String phoneNumber="شماره تلفن اول";
  @HiveField(3)
  String phoneNumber2="شماره تلفن دوم";
  @HiveField(4)
  String description="توضیحات";
  @HiveField(5)
  String? logoImage;
  @HiveField(6)
  String? signatureImage;
  @HiveField(7)
  String? stampImage;
  @HiveField(8)
  String shopCode="";
  @HiveField(9)
  String currency="ریال";
  @HiveField(10)
  bool showCost=false;
  @HiveField(11)
  bool showQuantity=true;
  @HiveField(12)
  String? fontFamily;
  @HiveField(13)
  int userLevel=0;
  @HiveField(14)
  String? backupDirectory;

  Shop copyWith({
    String? shopName,
    String? address,
    String? phoneNumber,
    String? phoneNumber2,
    String? description,
    String? logoImage,
    String? signatureImage,
    String? stampImage,
    String? shopCode,
    String? currency,
    bool? showCost,
    bool? showQuantity,
    String? fontFamily,
    String? backupDirectory,
    int? userLevel,
  }) {
    Shop shop=Shop()
      ..shopName= shopName ?? this.shopName
      ..address= address ?? this.address
      ..phoneNumber= phoneNumber ?? this.phoneNumber
      ..phoneNumber2= phoneNumber2 ?? this.phoneNumber2
      ..description= description ?? this.description
      ..logoImage= logoImage ?? this.logoImage
      ..signatureImage= signatureImage ?? this.signatureImage
      ..stampImage= stampImage ?? this.stampImage
      ..shopCode= shopCode ?? this.shopCode
      ..currency= currency ?? this.currency
      ..showCost= showCost ?? this.showCost
      ..showQuantity= showQuantity ?? this.showQuantity
      ..fontFamily= fontFamily ?? this.fontFamily
      ..userLevel= userLevel ?? this.userLevel
      ..backupDirectory= backupDirectory ?? this.backupDirectory;
    return shop;
  }



}



//run this code for create adaptor:
//flutter packages pub run build_runner build --delete-conflicting-outputs
//dart run build_runner build --delete-conflicting-outputs