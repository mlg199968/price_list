class WareBool {
  bool des;
  bool cost;
  bool sale;
  bool sale2;
  bool sale3;
  bool count;
  bool serial;

  // سازنده کلاس
  WareBool({
    required this.des,
    required this.cost,
    required this.sale,
    required this.sale2,
    required this.sale3,
    required this.count,
    required this.serial,
  });

  // متد برای تبدیل Map به WareBool
  factory WareBool.fromMap(Map<String, bool> map) {
    return WareBool(
      des: map['des'] ?? false,
      cost: map['cost'] ?? false,
      sale: map['sale'] ?? false,
      sale2: map['sale2'] ?? false,
      sale3: map['sale3'] ?? false,
      count: map['count'] ?? false,
      serial: map['serial'] ?? false,
    );
  }

  // متد برای تبدیل WareBool به Map
  Map<String, bool> toMap() {
    return {
      'des': des,
      'cost': cost,
      'sale': sale,
      'sale2': sale2,
      'sale3': sale3,
      'count': count,
      'serial': serial,
    };
  }
}