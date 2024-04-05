import 'package:saasify/models/pos_model.dart';

abstract class PosState {}

class PosInitial extends PosState {}

class PosDataFetched extends PosState {
  final List<PosModel> posDataList;

  PosDataFetched({required this.posDataList});
}

class PlacingOrder extends PosState {}

class OrderPlaced extends PosState {
  final String successMessage;

  OrderPlaced({required this.successMessage});
}

class OrderNotPlaced extends PosState {
  final String errorMessage;

  OrderNotPlaced({required this.errorMessage});
}
