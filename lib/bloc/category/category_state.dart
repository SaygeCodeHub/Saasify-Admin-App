import 'package:saasify/models/category/product_categories.dart';

abstract class CategoryState {}

final class CategoryInitial extends CategoryState {}

final class AddingCategory extends CategoryState {}

final class CategoryAdded extends CategoryState {
  final String successMessage;

  CategoryAdded({required this.successMessage});
}

final class CategoryNotAdded extends CategoryState {
  final String errorMessage;

  CategoryNotAdded({required this.errorMessage});
}

final class FetchingCategories extends CategoryState {}

final class CategoriesFetched extends CategoryState {
  final List<ProductCategories> categories;
  final String imagePath;

  CategoriesFetched({this.imagePath = '', required this.categories});
}

final class CategoriesNotFetched extends CategoryState {
  final String errorMessage;

  CategoriesNotFetched({required this.errorMessage});
}
