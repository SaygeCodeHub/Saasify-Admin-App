// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_categories.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductCategoriesAdapter extends TypeAdapter<ProductCategories> {
  @override
  final int typeId = 1;

  @override
  ProductCategories read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductCategories(
      name: fields[0] as String,
      imagePath: fields[1] as String?,
      categoryId: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ProductCategories obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.imagePath)
      ..writeByte(2)
      ..write(obj.categoryId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductCategoriesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
