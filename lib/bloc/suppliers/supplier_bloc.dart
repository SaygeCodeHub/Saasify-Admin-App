import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saasify/bloc/suppliers/supplier_event.dart';
import 'package:saasify/bloc/suppliers/supplier_state.dart';
import 'package:saasify/cache/cache.dart';
import 'package:saasify/utils/firestore_services.dart';

class SupplierBloc extends Bloc<SupplierEvent, SupplierState> {
  SupplierState get initialState => SupplierInitial();

  SupplierBloc() : super(SupplierInitial()) {
    on<AddSupplier>(_addSupplier);
  }

  FutureOr<void> _addSupplier(
      AddSupplier event, Emitter<SupplierState> emit) async {
    try {
      emit(AddingSupplier());
      CollectionReference collectionReference = FirebaseService()
          .getModulesCollectionRef(CustomerCache.getUserCompany() ?? '');
      final supplierRef =
          collectionReference.doc('supplier document').collection('suppliers');
      if (event.addSupplierData.toMap().isNotEmpty) {
        await supplierRef.add(event.addSupplierData.toMap());
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
