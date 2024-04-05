import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:saasify/services/firebase_services.dart';
import 'package:saasify/services/service_locator.dart';
import 'package:saasify/utils/global.dart';

import '../../models/customer/add_customer_model.dart';
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
    emit(CustomerAdding());
    try {
      if (kIsOfflineModule) {
        await _addToHive(event.customerModel);
      } else {
        await _addToFirestore(event, emit);
      }
    } catch (e) {
      emit(CustomerAddingError('Failed to add customer. Please try again.'));
    }
  }

  Future<void> _addToHive(AddCustomerModel customerModel) async {
    final box = await Hive.openBox<AddCustomerModel>('customers');
    await box.add(customerModel);
  }

  Future<void> _addToFirestore(
      AddCustomer event, Emitter<CustomerState> emit) async {
    DocumentReference customerRef = await firebaseService
        .getCustomersCollectionRef()
        .add(event.customerModel.toMap());
    if (customerRef.id.isNotEmpty) {
      emit(CustomerAddedSuccessfully());
    } else {
      emit(CustomerAddingError('Failed to add customer. Please try again.'));
    }
  }
}
