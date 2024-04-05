import 'package:saasify/models/category/product_categories.dart';

abstract class ProductEvent {}

class AddProduct extends ProductEvent {
  final List<ProductCategories> categories;

  AddProduct({required this.categories});
}

class FetchProducts extends ProductEvent {}

class SelectCategory extends ProductEvent {
  final String categoryId;
  final List<ProductCategories> categories;

  SelectCategory({required this.categoryId, required this.categories});
}

class FetchProduct extends ProductEvent {
  final String categoryId;
  final String productId;

  FetchProduct({required this.categoryId, required this.productId});
}

class AddVariant extends ProductEvent {
  final String categoryId;

  AddVariant({required this.categoryId});
}
