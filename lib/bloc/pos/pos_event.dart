import 'package:saasify/models/pos_model.dart';

abstract class PosEvent {}

class AddToCart extends PosEvent {
  final List<PosModel> posDataList;
  final int selectedVariantIndex;

  AddToCart({required this.posDataList, required this.selectedVariantIndex});
}

class IncrementVariantCount extends PosEvent {
  final List<PosModel> posDataList;
  final int selectedVariantIndex;

  IncrementVariantCount(
      {required this.posDataList, required this.selectedVariantIndex});
}

class DecrementVariantCount extends PosEvent {
  final List<PosModel> posDataList;
  final int selectedVariantIndex;

  DecrementVariantCount(
      {required this.posDataList, required this.selectedVariantIndex});
}

class CalculateBill extends PosEvent {
  final List<PosModel> posDataList;

  CalculateBill({required this.posDataList});
}

class ClearCart extends PosEvent {
  final List<PosModel> posDataList;

  ClearCart({required this.posDataList});
}

class GeneratePdf extends PosEvent {
  final List<PosModel> posDataList;

  GeneratePdf({required this.posDataList});
}

class PlaceOrder extends PosEvent {
  final List<PosModel> items;

  PlaceOrder({required this.items});
}
