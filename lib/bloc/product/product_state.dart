import 'package:saasify/models/category/product_categories.dart';
import 'package:saasify/models/product/products.dart';

abstract class ProductState {}

final class ProductInitial extends ProductState {}

final class AddingProduct extends ProductState {}

final class ProductAdded extends ProductState {
  final String successMessage;

  ProductAdded({required this.successMessage});
}

final class ProductNotAdded extends ProductState {
  final String errorMessage;

  ProductNotAdded({required this.errorMessage});
}

final class FetchingProducts extends ProductState {}

final class ProductsFetched extends ProductState {
  final List<Products> products;
  final List<ProductCategories> categories;
  final String categoryId;

  ProductsFetched(
      {required this.categories,
      required this.products,
      required this.categoryId});
}

final class ProductsCouldNotFetch extends ProductState {
  final String errorMessage;

  ProductsCouldNotFetch({required this.errorMessage});
}
