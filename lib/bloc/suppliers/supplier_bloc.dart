import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:saasify/bloc/suppliers/supplier_event.dart';
import 'package:saasify/bloc/suppliers/supplier_state.dart';
import 'package:saasify/services/firebase_services.dart';
import 'package:saasify/services/service_locator.dart';
import 'package:saasify/utils/global.dart';
import 'package:saasify/services/hive_box_service.dart';

class SupplierBloc extends Bloc<SupplierEvent, SupplierState> {
  SupplierState get initialState => SupplierInitial();
  final firebaseService = getIt<FirebaseServices>();
  Map<String, dynamic> addSupplierMap = {};

  SupplierBloc() : super(SupplierInitial()) {
    on<AddSupplier>(_addSupplier);
  }

  FutureOr<void> _addSupplier(
      AddSupplier event, Emitter<SupplierState> emit) async {
    try {
      await HiveBoxService.suppliersBox
          .add(event.addSupplierModel)
          .whenComplete(() async {
        try {
          if (!kIsOfflineModule) {
            emit(AddingSupplier());
            DocumentReference supplierRef = await firebaseService
                .getSuppliersCollectionRef()
                .add(event.addSupplierModel.toMap());
            if (supplierRef.id.isNotEmpty) {
              emit(SupplierAdded(
                  successMessage: 'Supplier added successfully!'));
            } else {
              emit(CouldNotAddSupplier(
                  errorMessage:
                      'Something went wrong, could not add the supplier!'));
            }
          } else {
            if (HiveBoxService.suppliersBox.isNotEmpty) {
              emit(SupplierAdded(
                  successMessage: 'Supplier added successfully!'));
            } else {
              emit(CouldNotAddSupplier(
                  errorMessage: 'Could not add the supplier.'));
            }
          }
        } catch (e) {
          emit(CouldNotAddSupplier(
              errorMessage: 'Failed to add supplier. Please try again!'));
        }
      });
    } catch (e) {
      if (e is HiveError) {
        emit(CouldNotAddSupplier(
            errorMessage: 'Failed to add supplier. Please try again!'));
      } else {
        rethrow;
      }
    }
  }
}
