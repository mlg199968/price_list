import 'package:price_list/parts/final_list.dart';

FinalList finalList=FinalList();
//final dataStore=finalList.dataList[0];
const String dataTable = 'dataProduct';
const String groupTable = 'groupProduct';


class ProductFields {
  static final List<String>values=[id,productName,costPrice,salePrice,unit,groupName];

  static const String productName='productName';
  static const String unit = 'unit';
  static const String costPrice='costPrice';
  static const String salePrice = 'salePrice';
  static const String groupName = 'groupName';
  static const String id = '_id';
}

class Product {

   final String productName;
   final String unit;
   final String costPrice;
   final String salePrice;
   final String groupName;
   final String id;

   const Product({
    this.productName="",
    this.unit="",
    this.costPrice="",
    this.salePrice="",
    this.groupName="",
    this.id="",

     });
  Product copy({
    String productName="",
    String unit="",
    String costPrice="",
    String salePrice="",
    String groupName="",
    String id="",
  }) =>
      Product(
       productName: productName,
       unit:        unit,
       costPrice:    costPrice,
       salePrice:   salePrice,
       groupName:   groupName,
       id:          id,
      );
  static Product fromJson(Map<String,Object?> json)=>Product(
     productName:json[ProductFields.productName] as String,
     unit:       json[ProductFields.unit] as String,
     costPrice:  json[ProductFields.costPrice] as String,
     salePrice:  json[ProductFields.salePrice]  as String,
     groupName:  json[ProductFields.groupName]  as String,
     id:         json[ProductFields.id]  as String,
  );
  static List fromJsonToList(Map<String,Object?> json)=><String>[
     json[ProductFields.productName] as String,
     json[ProductFields.unit] as String,
     json[ProductFields.costPrice] as String,
     json[ProductFields.salePrice]  as String,
     json[ProductFields.groupName]  as String,
     json[ProductFields.id]  as String,
  ];

  Map<String, Object?> toJson() => {
   ProductFields.productName: productName,
   ProductFields.unit:        unit ,
   ProductFields.costPrice:    costPrice ,
   ProductFields.salePrice:   salePrice,
   ProductFields.groupName:   groupName ,
   ProductFields.id:          id,
  };
}