import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saasify/bloc/suppliers/supplier_event.dart';
import 'package:saasify/bloc/suppliers/supplier_state.dart';
import 'package:saasify/services/firebase_services.dart';
import 'package:saasify/services/service_locator.dart';

class SupplierBloc extends Bloc<SupplierEvent, SupplierState> {
  SupplierState get initialState => SupplierInitial();
  final firebaseService = getIt<FirebaseServices>();

  SupplierBloc() : super(SupplierInitial()) {
    on<AddSupplier>(_addSupplier);
  }

  FutureOr<void> _addSupplier(
      AddSupplier event, Emitter<SupplierState> emit) async {
    try {
      emit(AddingSupplier());
      DocumentReference supplierRef = await firebaseService
          .getModulesCollectionRef()
          .doc('supplier document')
          .collection('suppliers')
          .add(event.addSupplierData.toMap());
      if (supplierRef.id.isNotEmpty) {
        emit(SupplierAdded(successMessage: 'Supplier added successfully!'));
      } else {
        emit(CouldNotAddSupplier(
            errorMessage: 'Something went wrong, could not add the supplier!'));
      }
    } catch (e) {
      emit(CouldNotAddSupplier(
          errorMessage: 'Could not add the supplier: ${e.toString()}'));
    }
  }
}
