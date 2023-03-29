import 'dart:convert';

class Ware {
  final String wareName;
  final String unit;
  final String groupName;
  final String description;
  final num cost;
  final num sale;
  final num quantity;
  final DateTime date;
  final String? id;

  Ware({
    required this.wareName,
    required this.unit,
    required this.groupName,
    required this.description,
    required this.cost,
    required this.sale,
    required this.quantity,
    required this.date,
    this.id = "",
  });

  Map<String, dynamic> toMap() {
    return {
      'wareName': wareName,
      'unit': unit,
      'groupName': groupName,
      'description': description,
      'cost': cost,
      'sale': sale,
      'quantity': quantity,
      'date': date.toIso8601String(),
      'id': id,
    };
  }

  factory Ware.fromMap(Map<String, dynamic> map) {
    return Ware(
      wareName: map['wareName'] ?? "",
      unit: map['unit'] ?? "",
      groupName: map['groupName'] ?? "",
      description: map['description'] ?? "",
      cost: map['cost'] ?? 0,
      sale: map['sale'] ?? 0,
      quantity: map['quantity'] ?? 0,
      date: DateTime.parse(map['date']),
      id: map['id'] ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory Ware.fromJson(String source) =>
      Ware.fromMap(
        json.decode(source),
      );

}
