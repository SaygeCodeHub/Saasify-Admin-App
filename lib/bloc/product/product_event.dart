import 'package:saasify/models/cart_model.dart';
import 'package:saasify/models/category/product_categories.dart';

abstract class ProductEvent {}

class AddProduct extends ProductEvent {
  final Map productMap;
  final List<ProductCategories> categories;

  AddProduct({required this.categories, required this.productMap});
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
  final Map variantMap;

  AddVariant({required this.variantMap});
}

class AddToCart extends ProductEvent {
  final List<Billing> billingList;
  final Billing billing;

  AddToCart({required this.billingList, required this.billing});
}

class IncrementVariantCount extends ProductEvent {
  final List<Billing> billingList;

  IncrementVariantCount({required this.billingList});
}

class DecrementVariantCount extends ProductEvent {
  final List<Billing> billingList;

  DecrementVariantCount({required this.billingList});
}

class CalculateBill extends ProductEvent {
  final List<Billing> billingList;

  CalculateBill({required this.billingList});
}

class ClearCart extends ProductEvent {
  final List<Billing> billingList;

  ClearCart({required this.billingList});
}
