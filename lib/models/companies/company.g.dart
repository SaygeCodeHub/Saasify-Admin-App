// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CompanyAdapter extends TypeAdapter<Company> {
  @override
  final int typeId = 0;

  @override
  Company read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Company(
      companyName: fields[0] as String,
      einNumber: fields[1] as String?,
      address: fields[2] as String?,
      logoUrl: fields[3] as String?,
      contactNumber: fields[4] as String,
      licenseNo: fields[5] as String?,
      currency: fields[6] as String?,
      currencySymbol: fields[9] as String?,
      industryName: fields[7] as String?,
      createdAt: fields[8] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Company obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.companyName)
      ..writeByte(1)
      ..write(obj.einNumber)
      ..writeByte(2)
      ..write(obj.address)
      ..writeByte(3)
      ..write(obj.logoUrl)
      ..writeByte(4)
      ..write(obj.contactNumber)
      ..writeByte(5)
      ..write(obj.licenseNo)
      ..writeByte(6)
      ..write(obj.currency)
      ..writeByte(7)
      ..write(obj.industryName)
      ..writeByte(8)
      ..write(obj.createdAt)
      ..writeByte(9)
      ..write(obj.currencySymbol);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CompanyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
