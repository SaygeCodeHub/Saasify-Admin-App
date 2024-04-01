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

class FetchingCategories extends CategoryState {}

class CategoriesFetched extends CategoryState {
  final List<ProductCategories> categories;
  final String imagePath;

  CategoriesFetched({this.imagePath = '', required this.categories});
}

class CategoriesNotFetched extends CategoryState {
  final String errorMessage;

  CategoriesNotFetched({required this.errorMessage});
}
