import '../../models/product/product_model.dart';

abstract class ProductEvent {}

class AddProduct extends ProductEvent {
  final ProductsModel products;

  AddProduct({required this.products});
}

class FetchProduct extends ProductEvent {
  final String categoryId;
  final String productId;

  FetchProduct({required this.categoryId, required this.productId});
}

class AddVariant extends ProductEvent {
  final String categoryId;

  AddVariant({required this.categoryId});
}
