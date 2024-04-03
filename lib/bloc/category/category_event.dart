import 'package:saasify/models/category/product_categories.dart';

abstract class CategoryEvent {}

class AddCategory extends CategoryEvent {
  final Map addCategoryMap;

  AddCategory({required this.addCategoryMap});
}

class FetchCategoriesWithProducts extends CategoryEvent {}

class FetchProductsForSelectedCategory extends CategoryEvent {
  final List<ProductCategories> categories;

  FetchProductsForSelectedCategory({required this.categories});
}
