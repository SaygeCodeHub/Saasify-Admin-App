import 'package:flutter/material.dart';
import 'package:saasify/models/feature_model.dart';
import 'package:saasify/screens/category/add_category_screen.dart';
import 'package:saasify/screens/category/view_category_screen.dart';
import 'package:saasify/screens/customers/add_customer_screen.dart';
import 'package:saasify/screens/products/add_product_screen.dart';
import 'package:saasify/screens/products/view_product_screen.dart';

List<FeatureCardModel> features = [
  FeatureCardModel(
      icon: Icons.category_outlined,
      label: 'Add Category',
      screen: AddCategoryScreen()),
  FeatureCardModel(
      icon: Icons.view_list_outlined,
      label: 'View Categories',
      screen: const ViewCategoryScreen()),
  FeatureCardModel(
      icon: Icons.add_box_outlined,
      label: 'Add Product',
      screen: AddProductScreen()),
  FeatureCardModel(
      icon: Icons.view_list_outlined,
      label: 'View Products',
      screen: const AllProductsScreen()),
  FeatureCardModel(
      icon: Icons.people,
      label: 'Add Customers',
      screen: const AddCustomerScreen()),
  FeatureCardModel(
      icon: Icons.people_outline,
      label: 'Add Suppliers',
      screen: const AddCustomerScreen()),
  FeatureCardModel(
      icon: Icons.people,
      label: 'Add Coupons',
      screen: const AddCustomerScreen())
];
