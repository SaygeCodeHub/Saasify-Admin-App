import '../../models/product/product_model.dart';

abstract class ProductEvent {}

class AddProduct extends ProductEvent {
  final ProductsModel products;

  AddProduct({required this.products});
}

class FetchProducts extends ProductEvent {}

class FetchProductDetails extends ProductEvent {
  final String productId;
  FetchProductDetails({required this.productId});
}


class AddVariant extends ProductEvent {
  final String categoryId;

  AddVariant({required this.categoryId});
}
