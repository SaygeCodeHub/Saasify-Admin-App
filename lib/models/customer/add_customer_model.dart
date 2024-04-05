import 'package:hive/hive.dart';

import '../../configs/hive_type_ids.dart';

part 'add_customer_model.g.dart';

@HiveType(typeId: HiveTypeIds.customers)
class AddCustomerModel extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String email;

  @HiveField(2)
  final String contact;

  @HiveField(3)
  final DateTime dob;

  @HiveField(4)
  final int loyaltyPoints;

  AddCustomerModel({
    required this.name,
    required this.email,
    required this.contact,
    required this.dob,
    required this.loyaltyPoints,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'conatct': contact,
      'dob': dob,
      'loyaltyPoints': loyaltyPoints
    };
  }
}
