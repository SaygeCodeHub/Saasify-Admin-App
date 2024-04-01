// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_customer_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AddCustomerModelAdapter extends TypeAdapter<AddCustomerModel> {
  @override
  final int typeId = 4;

  @override
  AddCustomerModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AddCustomerModel(
      name: fields[0] as String,
      email: fields[1] as String,
      contact: fields[2] as String,
      dob: fields[3] as DateTime,
      loyaltyPoints: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, AddCustomerModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.contact)
      ..writeByte(3)
      ..write(obj.dob)
      ..writeByte(4)
      ..write(obj.loyaltyPoints);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AddCustomerModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
