import '../../models/product/product_model.dart';

abstract class ProductEvent {}

class AddProduct extends ProductEvent {
  final ProductsModel products;

  AddProduct({required this.products});
}

class FetchProducts extends ProductEvent {
  FetchProducts();
}

class AddVariant extends ProductEvent {
  final String categoryId;

  AddVariant({required this.categoryId});
}
