import 'package:saasify/models/category/product_categories.dart';

abstract class CategoryState {}

class CategoryInitial extends CategoryState {}

class AddingCategory extends CategoryState {}

class CategoryAdded extends CategoryState {
  final String successMessage;

  CategoryAdded({required this.successMessage});
}

class CategoryNotAdded extends CategoryState {
  final String errorMessage;

  CategoryNotAdded({required this.errorMessage});
}

class FetchingCategoriesWithProducts extends CategoryState {}

class CategoriesWithProductsFetched extends CategoryState {
  final List<ProductCategories> categories;
  final String imagePath;

  CategoriesWithProductsFetched(
      {this.imagePath = '', required this.categories});
}

class CategoriesWithProductsNotFetched extends CategoryState {
  final String errorMessage;

  CategoriesWithProductsNotFetched({required this.errorMessage});
}
