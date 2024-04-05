abstract class OrdersState {}

class OrdersInitial extends OrdersState {}

class FetchingOrders extends OrdersState {}

class OrdersFetched extends OrdersState {
  final List ordersList;

  OrdersFetched({required this.ordersList});
}

class OrdersNotFetched extends OrdersState {
  final String errorMessage;

  OrdersNotFetched({required this.errorMessage});
}
