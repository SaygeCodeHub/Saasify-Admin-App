import 'dart:typed_data';
import 'package:hive/hive.dart';

import '../../configs/hive_type_ids.dart';

part 'user_details.g.dart';

@HiveType(typeId: HiveTypeIds.userDetails)
class UserDetails {
  @HiveField(0)
  String ownerName;

  @HiveField(1)
  String companyName;

  @HiveField(2)
  String identificationNumber;

  @HiveField(3)
  Uint8List? logo;

  @HiveField(4)
  String? address;

  UserDetails({
    required this.ownerName,
    required this.companyName,
    required this.identificationNumber,
    this.logo,
    this.address,
  });
}
