// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_variant.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductVariantAdapter extends TypeAdapter<ProductVariant> {
  @override
  final int typeId = 3;

  @override
  ProductVariant read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductVariant(
      variantId: fields[0] as int,
      productId: fields[1] as String,
      variantName: fields[2] as String,
      price: fields[3] as double,
      cost: fields[4] as double,
      quantityAvailable: fields[5] as int,
      isActive: fields[6] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ProductVariant obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.variantId)
      ..writeByte(1)
      ..write(obj.productId)
      ..writeByte(2)
      ..write(obj.variantName)
      ..writeByte(3)
      ..write(obj.price)
      ..writeByte(4)
      ..write(obj.cost)
      ..writeByte(5)
      ..write(obj.quantityAvailable)
      ..writeByte(6)
      ..write(obj.isActive);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductVariantAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
