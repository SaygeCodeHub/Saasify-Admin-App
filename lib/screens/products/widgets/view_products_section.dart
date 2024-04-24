import 'package:flutter/material.dart';
import 'package:saasify/models/category/categories_model.dart';

class ViewProductsSection extends StatelessWidget {
  final List<CategoriesModel> categories;

  const ViewProductsSection({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    print('ViewProductsSection');
    return Container();
  }
}
