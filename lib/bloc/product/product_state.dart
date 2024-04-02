import 'package:saasify/models/cart_model.dart';
import 'package:saasify/models/category/product_categories.dart';
import 'package:saasify/models/product/products.dart';

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

class FetchingProducts extends ProductState {}

class ProductsFetched extends ProductState {
  final List<Products> products;
  final List<ProductCategories> categories;
  final String categoryId;
  final List selectedCategories;

  ProductsFetched(
      {required this.categories,
      required this.products,
      required this.categoryId,
      required this.selectedCategories});
}

class ProductsCouldNotFetch extends ProductState {
  final String errorMessage;

  ProductsCouldNotFetch({required this.errorMessage});
}

class FetchingProduct extends ProductState {}

class ProductFetched extends ProductState {
  final Products products;

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

class BillDataFetched extends ProductState {
  final List<Billing> billingList;

  BillDataFetched({required this.billingList});
}
