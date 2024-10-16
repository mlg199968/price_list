// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bug.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BugAdapter extends TypeAdapter<Bug> {
  @override
  final int typeId = 10;

  @override
  Bug read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Bug()
      ..title = fields[0] as String?
      ..errorText = fields[1] as String?
      ..count = fields[2] as int
      ..directory = fields[3] as String?
      ..bugDate = fields[4] as DateTime
      ..bugId = fields[5] as String
      ..stacktrace = fields[6] as String?
      ..device = fields[7] as String?
      ..subscriber = fields[8] as String?
      ..appVersion = fields[9] as String?;
  }

  @override
  void write(BinaryWriter writer, Bug obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.errorText)
      ..writeByte(2)
      ..write(obj.count)
      ..writeByte(3)
      ..write(obj.directory)
      ..writeByte(4)
      ..write(obj.bugDate)
      ..writeByte(5)
      ..write(obj.bugId)
      ..writeByte(6)
      ..write(obj.stacktrace)
      ..writeByte(7)
      ..write(obj.device)
      ..writeByte(8)
      ..write(obj.subscriber)
      ..writeByte(9)
      ..write(obj.appVersion);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BugAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
