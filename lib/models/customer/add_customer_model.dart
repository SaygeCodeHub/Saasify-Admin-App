import 'package:hive/hive.dart';

import '../../configs/hive_type_ids.dart';

part 'add_customer_model.g.dart'; // This file will be generated

@HiveType(
    typeId: HiveTypeIds
        .customers) // Ensure that typeId is unique if you have other Hive objects
class AddCustomerModel extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String email;

  @HiveField(2)
  final String contact;

  @HiveField(3)
  final String dob; // Date of birth

  @HiveField(4)
  final int loyaltyPoints;

  AddCustomerModel({
    required this.name,
    required this.email,
    required this.contact,
    required this.dob,
    required this.loyaltyPoints,
  });
}
