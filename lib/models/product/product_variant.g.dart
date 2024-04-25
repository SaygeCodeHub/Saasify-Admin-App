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
      variantId: fields[0] as String?,
      productId: fields[1] as String?,
      variantName: fields[2] as String?,
      sellingPrice: fields[3] as double?,
      purchasePrice: fields[4] as double?,
      quantity: fields[5] as int?,
      isActive: fields[6] as bool?,
      dateAdded: fields[7] as DateTime?,
      isUploadedToServer: fields[8] as bool?,
      minStockLevel: fields[9] as int?,
      localImagePath: fields[11] as String?,
      serverImagePath: fields[12] as String?,
      weight: fields[10] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ProductVariant obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.variantId)
      ..writeByte(1)
      ..write(obj.productId)
      ..writeByte(2)
      ..write(obj.variantName)
      ..writeByte(3)
      ..write(obj.sellingPrice)
      ..writeByte(4)
      ..write(obj.purchasePrice)
      ..writeByte(5)
      ..write(obj.quantity)
      ..writeByte(6)
      ..write(obj.isActive)
      ..writeByte(7)
      ..write(obj.dateAdded)
      ..writeByte(8)
      ..write(obj.isUploadedToServer)
      ..writeByte(9)
      ..write(obj.minStockLevel)
      ..writeByte(10)
      ..write(obj.weight)
      ..writeByte(11)
      ..write(obj.localImagePath)
      ..writeByte(12)
      ..write(obj.serverImagePath);
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
