import 'package:price_list/parts/final_list.dart';

FinalList finalList=FinalList();
final dataStore=finalList.dataList[0];
const String dataTable = 'dataProduct';
const String groupTable = 'groupProduct';


class NoteFields {
  static final List<String>values=[id,productName,costPrice,salePrice,unit,groupName];

  static const String productName='productName';
  static const String unit = 'unit';
  static const String costPrice='costPrice';
  static const String salePrice = 'salePrice';
  static const String groupName = 'groupName';
  static const String id = '_id';
}

class Note {

   final String? productName;
   final String? unit;
   final String? costPrice;
   final String? salePrice;
   final String? groupName;
   final String? id;

   const Note({
    this.productName,
    this.unit,
    this.costPrice,
    this.salePrice,
    this.groupName,
    this.id,

     });
  Note copy({
    String? productName,
    String? unit,
    String? costPric,
    String? salePrice,
    String? groupName,
    String? id,
  }) =>
      Note(
       productName: productName ?? this.productName,
       unit:        unit ?? this.unit,
       costPrice:    costPrice ?? costPrice,
       salePrice:   salePrice ?? this.salePrice,
       groupName:   groupName ?? this.groupName,
       id:          id ?? this.id,
      );
  static Note fromJson(Map<String,Object?> json)=>Note(
     productName:json[NoteFields.productName] as String,
     unit:       json[NoteFields.unit] as String,
     costPrice:  json[NoteFields.costPrice] as String,
     salePrice:  json[NoteFields.salePrice]  as String,
     groupName:  json[NoteFields.groupName]  as String,
     id:         json[NoteFields.id]  as String, 
  );
  static List fromJsonToList(Map<String,Object?> json)=><String>[
     json[NoteFields.productName] as String,
     json[NoteFields.unit] as String,
     json[NoteFields.costPrice] as String,
     json[NoteFields.salePrice]  as String,
     json[NoteFields.groupName]  as String,
     json[NoteFields.id]  as String,
  ];

  Map<String, Object?> toJson() => {
   NoteFields.productName: productName,
   NoteFields.unit:        unit ,
   NoteFields.costPrice:    costPrice ,
   NoteFields.salePrice:   salePrice,
   NoteFields.groupName:   groupName ,
   NoteFields.id:          id,
  };
}