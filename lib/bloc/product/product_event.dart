import 'package:saasify/models/category/product_categories.dart';
import 'package:saasify/models/product/products.dart';

abstract class ProductEvent {}

class AddProduct extends ProductEvent {
  final List<ProductCategories> categories;
  final Products product;

  AddProduct({required this.product, required this.categories});
}

class ViewProducts extends ProductEvent {}

class SelectCategory extends ProductEvent {
  final String categoryId;
  final List<ProductCategories> categories;

  SelectCategory({required this.categoryId, required this.categories});
}
