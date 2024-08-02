// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plan.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlanAdapter extends TypeAdapter<Plan> {
  @override
  final int typeId = 23;

  @override
  Plan read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Plan()
      ..title = fields[0] as String
      ..mainPrice = fields[1] as int
      ..discount = fields[2] as int?
      ..fixDiscount = fields[3] as int?
      ..days = fields[4] as int
      ..startDate = fields[5] as DateTime?
      ..endDate = fields[6] as DateTime?
      ..description = fields[7] as String?
      ..id = fields[8] as String
      ..appName = fields[9] as String
      ..type = fields[10] as String
      ..platform = fields[11] as String
      ..refId = fields[12] as String?;
  }

  @override
  void write(BinaryWriter writer, Plan obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.mainPrice)
      ..writeByte(2)
      ..write(obj.discount)
      ..writeByte(3)
      ..write(obj.fixDiscount)
      ..writeByte(4)
      ..write(obj.days)
      ..writeByte(5)
      ..write(obj.startDate)
      ..writeByte(6)
      ..write(obj.endDate)
      ..writeByte(7)
      ..write(obj.description)
      ..writeByte(8)
      ..write(obj.id)
      ..writeByte(9)
      ..write(obj.appName)
      ..writeByte(10)
      ..write(obj.type)
      ..writeByte(11)
      ..write(obj.platform)
      ..writeByte(12)
      ..write(obj.refId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlanAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
