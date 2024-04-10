import 'package:hive/hive.dart';
import 'package:saasify/configs/hive_type_ids.dart';

part 'add_supplier_model.g.dart';

@HiveType(
    typeId:
        HiveTypeIds.suppliers) // Replace with a unique integer for this model
class AddSupplierModel extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String email;

  @HiveField(2)
  final String contact;

  AddSupplierModel({
    required this.name,
    required this.email,
    required this.contact,
  });

  Map<String, dynamic> toMap() {
    return {'name': name, 'email': email, 'contact': contact};
  }
}
