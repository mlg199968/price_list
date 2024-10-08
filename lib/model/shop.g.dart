// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shop.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ShopAdapter extends TypeAdapter<Shop> {
  @override
  final int typeId = 6;

  @override
  Shop read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Shop()
      ..shopName = fields[0] as String
      ..address = fields[1] as String
      ..phoneNumber = fields[2] as String
      ..phoneNumber2 = fields[3] as String
      ..description = fields[4] as String
      ..logoImage = fields[5] as String?
      ..signatureImage = fields[6] as String?
      ..stampImage = fields[7] as String?
      ..shopCode = fields[8] as String
      ..currency = fields[9] as String
      ..showCost = fields[10] as bool
      ..showQuantity = fields[11] as bool
      ..fontFamily = fields[12] as String?
      ..userLevel = fields[13] as int
      ..backupDirectory = fields[14] as String?
      ..pdfFont = fields[15] as String?
      ..currenciesValue = (fields[16] as Map?)?.cast<dynamic, dynamic>()
      ..replacedCurrency = fields[17] as bool?
      ..activeUser = fields[18] as User?
      ..appType = fields[19] as String?
      ..subscription = fields[20] as Subscription?
      ..descriptionList = (fields[21] as List?)
          ?.map((dynamic e) => (e as Map).cast<dynamic, dynamic>())
          .toList()
      ..conditions = (fields[22] as Map?)?.cast<String, bool>()
      ..listViewMode = fields[23] as String?
      ..imageQuality = fields[24] as int?
      ..imageSize = fields[25] as int?
      ..sortItem = fields[26] as String?;
  }

  @override
  void write(BinaryWriter writer, Shop obj) {
    writer
      ..writeByte(27)
      ..writeByte(0)
      ..write(obj.shopName)
      ..writeByte(1)
      ..write(obj.address)
      ..writeByte(2)
      ..write(obj.phoneNumber)
      ..writeByte(3)
      ..write(obj.phoneNumber2)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.logoImage)
      ..writeByte(6)
      ..write(obj.signatureImage)
      ..writeByte(7)
      ..write(obj.stampImage)
      ..writeByte(8)
      ..write(obj.shopCode)
      ..writeByte(9)
      ..write(obj.currency)
      ..writeByte(10)
      ..write(obj.showCost)
      ..writeByte(11)
      ..write(obj.showQuantity)
      ..writeByte(12)
      ..write(obj.fontFamily)
      ..writeByte(13)
      ..write(obj.userLevel)
      ..writeByte(14)
      ..write(obj.backupDirectory)
      ..writeByte(15)
      ..write(obj.pdfFont)
      ..writeByte(16)
      ..write(obj.currenciesValue)
      ..writeByte(17)
      ..write(obj.replacedCurrency)
      ..writeByte(18)
      ..write(obj.activeUser)
      ..writeByte(19)
      ..write(obj.appType)
      ..writeByte(20)
      ..write(obj.subscription)
      ..writeByte(21)
      ..write(obj.descriptionList)
      ..writeByte(22)
      ..write(obj.conditions)
      ..writeByte(23)
      ..write(obj.listViewMode)
      ..writeByte(24)
      ..write(obj.imageQuality)
      ..writeByte(25)
      ..write(obj.imageSize)
      ..writeByte(26)
      ..write(obj.sortItem);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShopAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
