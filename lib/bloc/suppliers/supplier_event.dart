import 'package:saasify/models/supplier/add_supplier_model.dart';

abstract class SupplierEvent {}

class AddSupplier extends SupplierEvent {
  final AddSupplierModel addSupplierData;

  AddSupplier({required this.addSupplierData});
}
