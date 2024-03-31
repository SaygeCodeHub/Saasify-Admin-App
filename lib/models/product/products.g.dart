// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'products.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductsAdapter extends TypeAdapter<Products> {
  @override
  final int typeId = 2;

  @override
  Products read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Products(
      productId: fields[0] as String,
      name: fields[1] as String,
      category: fields[2] as String,
      tax: fields[3] as double,
      supplier: fields[4] as String,
      minStockLevel: fields[5] as int,
      description: fields[7] as String,
      imageUrl: fields[8] as String,
      dateAdded: fields[9] as DateTime?,
      isActive: fields[10] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Products obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.productId)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.category)
      ..writeByte(3)
      ..write(obj.tax)
      ..writeByte(4)
      ..write(obj.supplier)
      ..writeByte(5)
      ..write(obj.minStockLevel)
      ..writeByte(6)
      ..write(obj.description)
      ..writeByte(7)
      ..write(obj.imageUrl)
      ..writeByte(8)
      ..write(obj.dateAdded)
      ..writeByte(9)
      ..write(obj.isActive);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
