import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:saasify/bloc/category/category_bloc.dart';
import 'package:saasify/bloc/product/product_bloc.dart';
import 'package:saasify/bloc/product/product_event.dart';
import 'package:saasify/models/category/product_categories.dart';
import 'package:saasify/models/product/products.dart';
import 'package:saasify/screens/widgets/buttons/primary_button.dart';
import 'package:saasify/screens/widgets/custom_dialogs.dart';
import 'package:saasify/utils/global.dart';

class AddProductButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final List<ProductCategories> categories;
  final Map productMap;

  const AddProductButton(
      {super.key,
      required this.formKey,
      required this.categories,
      required this.productMap});

  @override
  Widget build(BuildContext context) {
    return PrimaryButton(
      buttonTitle: 'Add Product',
      onPressed: () async {
        if (kIsOfflineModule) {
          if (context.read<CategoryBloc>().selectedCategory.isNotEmpty) {
            final product = Products(
              productId: '0',
              name: productMap['name'],
              category: context.read<CategoryBloc>().selectedCategory,
              description: productMap['description'],
              imageUrl: '',
              supplier: productMap['supplier'],
              tax: double.tryParse(productMap['tax']) ?? 0,
              minStockLevel: int.tryParse(productMap['min_stock']) ?? 0,
              dateAdded: DateTime.now(),
              isActive: true,
              variants: [],
            );
            final productsBox = Hive.box<Products>('products');
            productsBox.add(product);
            if (productsBox.isNotEmpty) {
              showDialog(
                  context: context,
                  builder: (context) {
                    return CustomDialogs().showSuccessDialog(
                        context, 'Product added successfully', onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    });
                  });
            } else {
              showDialog(
                  context: context,
                  builder: (context) {
                    return CustomDialogs().showSuccessDialog(
                        context, 'Failed to add product.',
                        onPressed: () => Navigator.pop(context));
                  });
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Select a category!')));
          }
        } else {
          if (formKey.currentState!.validate()) {
            if (context.read<CategoryBloc>().selectedCategory.isNotEmpty) {
              context.read<ProductBloc>().add(AddProduct(
                  product: Products(
                    productId: '0',
                    name: productMap['name'],
                    category: context.read<CategoryBloc>().selectedCategory,
                    description: productMap['description'],
                    imageUrl: '',
                    supplier: productMap['supplier'],
                    tax: double.tryParse(productMap['tax']) ?? 0,
                    minStockLevel: int.tryParse(productMap['min_stock']) ?? 0,
                    dateAdded: DateTime.now(),
                    isActive: true,
                    variants: [],
                  ),
                  categories: categories));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Select a category!')));
            }
          }
        }
      },
    );
  }
}
