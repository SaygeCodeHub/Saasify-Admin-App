import 'package:saasify/models/product/product_model.dart';

import '../../models/product/product_variant.dart';

abstract class ProductState {}

class ProductInitial extends ProductState {}

class AddingProduct extends ProductState {}

class ProductAdded extends ProductState {
  final String successMessage;

  ProductAdded({required this.successMessage});
}

class ProductNotAdded extends ProductState {
  final String errorMessage;

  ProductNotAdded({required this.errorMessage});
}

class ProductsFetched extends ProductState {
  final Map<String, Map<ProductsModel, List<ProductVariant>>>
      categoryWiseProductsVariants;

  ProductsFetched({required this.categoryWiseProductsVariants});
}

class FetchingProducts extends ProductState {}

class ProductFetched extends ProductState {
  final ProductsModel products;

  ProductFetched({required this.products});
}

class ProductNotFetched extends ProductState {
  final String errorMessage;

  ProductNotFetched({required this.errorMessage});
}

class AddingVariant extends ProductState {}

class VariantAdded extends ProductState {
  final String successMessage;

  VariantAdded({required this.successMessage});
}

class VariantNotAdded extends ProductState {
  final String errorMessage;

  VariantNotAdded({required this.errorMessage});
}
