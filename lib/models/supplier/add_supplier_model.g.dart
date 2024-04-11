// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_supplier_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AddSupplierModelAdapter extends TypeAdapter<AddSupplierModel> {
  @override
  final int typeId = 6;

  @override
  AddSupplierModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AddSupplierModel(
      name: fields[0] as String,
      email: fields[1] as String,
      contact: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, AddSupplierModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.contact);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AddSupplierModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}