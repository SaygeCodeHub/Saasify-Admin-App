import 'package:saasify/models/supplier/add_supplier_model.dart';

abstract class SupplierEvent {}

class AddSupplier extends SupplierEvent {
  final AddSupplierModel addSupplierModel;

  AddSupplier({required this.addSupplierModel});
}
