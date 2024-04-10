// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coupons_and_discounts.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CouponsAndDiscountsModelAdapter
    extends TypeAdapter<CouponsAndDiscountsModel> {
  @override
  final int typeId = 5;

  @override
  CouponsAndDiscountsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CouponsAndDiscountsModel(
      couponCode: fields[0] as String,
      amount: fields[1] as double?,
      maximumAmount: fields[2] as double?,
      couponType: fields[3] as String?,
      validTill: fields[4] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, CouponsAndDiscountsModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.couponCode)
      ..writeByte(1)
      ..write(obj.amount)
      ..writeByte(2)
      ..write(obj.maximumAmount)
      ..writeByte(3)
      ..write(obj.couponType)
      ..writeByte(4)
      ..write(obj.validTill);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CouponsAndDiscountsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
