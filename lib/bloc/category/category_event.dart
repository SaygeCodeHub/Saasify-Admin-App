import 'package:saasify/models/category/categories_model.dart';

abstract class CategoryEvent {}

class InitializeCategoryEvent extends CategoryEvent {}

class AddCategory extends CategoryEvent {
  final CategoriesModel categoriesModel;
  AddCategory({required this.categoriesModel});
}

class FetchCategoriesWithProducts extends CategoryEvent {}

class FetchProductsForSelectedCategory extends CategoryEvent {
  final List<CategoriesModel> categories;

  FetchProductsForSelectedCategory({required this.categories});
}
