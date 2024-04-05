import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saasify/bloc/orders/orders_event.dart';
import 'package:saasify/bloc/orders/orders_state.dart';
import 'package:saasify/services/firebase_services.dart';
import 'package:saasify/services/service_locator.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final firebaseService = getIt<FirebaseServices>();
  List ordersList = [];

  OrdersBloc() : super(OrdersInitial()) {
    on<FetchOrders>(_fetchOrders);
  }

  FutureOr<void> _fetchOrders(
      FetchOrders event, Emitter<OrdersState> emit) async {
    try {
      emit(FetchingOrders());
      QuerySnapshot ordersSnapshot =
          await firebaseService.getOrdersCollectionRef().get();
      ordersList.clear();
      for (var item in ordersSnapshot.docs) {
        List<dynamic>? items = item.get('items');
        if (items != null) {
          ordersList.addAll(items);
        }
      }
      emit(OrdersFetched(ordersList: ordersList));
    } catch (e) {
      emit(OrdersNotFetched(
          errorMessage: 'Could not fetch orders ${e.toString()}'));
    }
  }
}
