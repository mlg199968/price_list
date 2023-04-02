import 'package:price_list/parts/final_list.dart';

FinalList finalList = FinalList();
//final dataStore=finalList.dataList[0];
const String dataTable = 'dataProduct';
const String groupTable = 'groupProduct';

class ProductFields {
  static final List<String> values = [
    id,
    productName,
    costPrice,
    salePrice,
    unit,
    groupName,
   // quantity,
   // description,
   // serial,
   // date,
  ];

  static const String productName = 'productName';
  static const String unit = 'unit';
  static const String costPrice = 'costPrice';
  static const String salePrice = 'salePrice';
  static const String groupName = 'groupName';
  //static const String serial = 'serial';
  //static const String quantity = 'quantity';
  //static const String description = 'description';
  //static const String date = 'date';
  static const String id = '_id';
}

class Product {
  final String productName;
  final String unit;
  final String costPrice;
  final String salePrice;
  final String groupName;
  //final double quantity;
  //final String serial;
  //final String description;
 // final DateTime? date;
  final String id;

  const Product({
   // this.quantity = 1000,
   // this.serial = "",
   // this.description = "",
    //this.date,
    this.productName = "",
    this.unit = "",
    this.costPrice = "",
    this.salePrice = "",
    this.groupName = "",
    required this.id,
  });
  Product copy({

   // quantity = 1000,
    //serial = "",
   // description = "",
    //date,
    productName = "",
    unit = "",
    costPrice = "",
    salePrice = "",
    groupName = "",
    id = "",
  }) =>
      Product(
       // quantity: quantity,
      //  serial: serial,
       // description: description,
      //  date: date,
        productName:productName,
        unit:unit,
        costPrice:costPrice,
        salePrice:salePrice,
        groupName:groupName,
        id:id,
      );

  static Product fromJson(Map<String, Object?> json) => Product(
    productName: json[ProductFields.productName] as String,
    unit: json[ProductFields.unit] as String,
    costPrice: json[ProductFields.costPrice] as String,
    salePrice: json[ProductFields.salePrice] as String,
    groupName: json[ProductFields.groupName] as String,
    id: json[ProductFields.id] as String,
  );

  Map<String, Object?> toJson() => {
    ProductFields.productName: productName,
    ProductFields.unit: unit,
    ProductFields.costPrice: costPrice,
    ProductFields.salePrice: salePrice,
    ProductFields.groupName: groupName,
    ProductFields.id: id,
  };
}






// Map<String, dynamic> toJson() {
//   return {
//     'productName': this.productName,
//     'unit': this.unit,
//     'costPrice': this.costPrice,
//     'salePrice': this.salePrice,
//     'groupName': this.groupName,
//     'quantity': this.quantity,
//     'serial': this.serial,
//     'description': this.description,
//     'date': this.date==null?DateTime.now().toIso8601String():this.date!.toIso8601String(),
//     'id': this.id,
//   };
// }
//
// factory Product.fromJson(Map<String, dynamic> map) {
// return Product(
// productName: map['productName'] ?? "",
// unit: map['unit'] ?? "",
// costPrice: map['costPrice'] ?? "",
// salePrice: map['salePrice'] ?? "",
// groupName: map['groupName'] ?? "",
// quantity: map['quantity'] ?? 0,
// serial: map['serial'] ?? "",
// description: map['description'] ?? "",
// date: DateTime.parse(map['date']),
// id: map['id'] ?? "",
// );
// }