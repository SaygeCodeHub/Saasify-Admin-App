abstract class SupplierState {}

class SupplierInitial extends SupplierState {}

class AddingSupplier extends SupplierState {}

class SupplierAdded extends SupplierState {
  final String successMessage;

  SupplierAdded({required this.successMessage});
}

class CouldNotAddSupplier extends SupplierState {
  final String errorMessage;

  CouldNotAddSupplier({required this.errorMessage});
}
