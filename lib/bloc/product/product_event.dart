import 'package:saasify/models/category/product_categories.dart';

abstract class ProductEvent {}

class AddProduct extends ProductEvent {
  final Map productMap;
  final List<ProductCategories> categories;

  AddProduct({required this.categories, required this.productMap});
}

class ViewProducts extends ProductEvent {}

class SelectCategory extends ProductEvent {
  final String categoryId;
  final List<ProductCategories> categories;

  SelectCategory({required this.categoryId, required this.categories});
}
