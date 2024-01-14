// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ware_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WareHiveAdapter extends TypeAdapter<WareHive> {
  @override
  final int typeId = 0;

  @override
  WareHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WareHive()
      ..wareName = fields[0] as String
      ..unit = fields[1] as String
      ..groupName = fields[2] as String
      ..description = fields[3] as String
      ..cost = fields[4] as num
      ..sale = fields[5] as num
      ..quantity = fields[6] as num
      ..date = fields[7] as DateTime
      ..wareID = fields[8] as String?
      ..isChecked = fields[9] as bool?
      ..color = fields[10] as String?
      ..modifyDate = fields[11] as DateTime?
      ..wareSerial = fields[12] as String?;
  }

  @override
  void write(BinaryWriter writer, WareHive obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.wareName)
      ..writeByte(1)
      ..write(obj.unit)
      ..writeByte(2)
      ..write(obj.groupName)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.cost)
      ..writeByte(5)
      ..write(obj.sale)
      ..writeByte(6)
      ..write(obj.quantity)
      ..writeByte(7)
      ..write(obj.date)
      ..writeByte(8)
      ..write(obj.wareID)
      ..writeByte(9)
      ..write(obj.isChecked)
      ..writeByte(10)
      ..write(obj.color)
      ..writeByte(11)
      ..write(obj.modifyDate)
      ..writeByte(12)
      ..write(obj.wareSerial);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WareHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
