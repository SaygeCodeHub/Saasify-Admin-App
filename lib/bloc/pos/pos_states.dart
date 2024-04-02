import 'package:saasify/models/cart_model.dart';

abstract class PosState {}

class PosInitial extends PosState {}

class PosDataFetched extends PosState {
  final List<PosModel> posDataList;

  PosDataFetched({required this.posDataList});
}
