// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductsModelAdapter extends TypeAdapter<ProductsModel> {
  @override
  final int typeId = 2;

  @override
  ProductsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductsModel(
      productId: fields[0] as String?,
      name: fields[1] as String?,
      categoryId: fields[2] as String?,
      tax: fields[3] as double?,
      supplier: fields[4] as String?,
      description: fields[5] as String?,
      localImagePath: fields[6] as String?,
      dateAdded: fields[7] as DateTime?,
      isActive: fields[8] as bool?,
      soldBy: fields[9] as String?,
      serverImagePath: fields[10] as String?,
      isUploadedToServer: fields[11] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, ProductsModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.productId)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.categoryId)
      ..writeByte(3)
      ..write(obj.tax)
      ..writeByte(4)
      ..write(obj.supplier)
      ..writeByte(5)
      ..write(obj.description)
      ..writeByte(6)
      ..write(obj.localImagePath)
      ..writeByte(7)
      ..write(obj.dateAdded)
      ..writeByte(8)
      ..write(obj.isActive)
      ..writeByte(9)
      ..write(obj.soldBy)
      ..writeByte(10)
      ..write(obj.serverImagePath)
      ..writeByte(11)
      ..write(obj.isUploadedToServer);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
