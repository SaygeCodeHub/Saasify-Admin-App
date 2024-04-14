import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:saasify/services/firebase_services.dart';
import 'package:saasify/services/service_locator.dart';
import 'package:saasify/utils/global.dart';
import 'package:saasify/services/hive_box_service.dart';
import 'customer_events.dart';
import 'customer_states.dart';

class CustomerBloc extends Bloc<CustomerEvent, CustomerState> {
  CustomerState get initialState => CustomerInitial();
  Map<String, dynamic> addCustomerMap = {};
  final firebaseService = getIt<FirebaseServices>();

  CustomerBloc() : super(CustomerInitial()) {
    on<AddCustomer>(_addCustomer);
  }

  FutureOr<void> _addCustomer(
      AddCustomer event, Emitter<CustomerState> emit) async {
    try {
      await HiveBoxService.customersBox
          .add(event.customerModel)
          .whenComplete(() async {
        try {
          if (!kIsCloudVersion) {
            emit(CustomerAdding());
            DocumentReference customerRef = await firebaseService
                .getCustomersCollectionRef()
                .add(event.customerModel.toMap());
            if (customerRef.id.isNotEmpty) {
              emit(CustomerAddedSuccessfully());
            } else {
              emit(CustomerAddingError(
                  'Failed to add customer. Please try again.'));
            }
          } else {
            if (HiveBoxService.customersBox.isNotEmpty) {
              emit(CustomerAddedSuccessfully());
            } else {
              emit(CustomerAddingError(
                  'Failed to add customer. Please try again.'));
            }
          }
        } catch (e) {
          emit(
              CustomerAddingError('Failed to add customer. Please try again.'));
        }
      });
    } catch (e) {
      if (e is HiveError) {
        emit(CustomerAddingError('Failed to add customer. Please try again.'));
      } else {
        rethrow;
      }
    }
  }
}
