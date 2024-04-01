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
