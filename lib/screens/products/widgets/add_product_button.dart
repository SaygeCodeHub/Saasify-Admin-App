import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saasify/bloc/category/category_bloc.dart';
import 'package:saasify/bloc/product/product_bloc.dart';
import 'package:saasify/bloc/product/product_event.dart';
import 'package:saasify/bloc/product/product_state.dart';
import 'package:saasify/models/category/categories_model.dart';
import 'package:saasify/models/product/products.dart';
import 'package:saasify/screens/home/home_screen.dart';
import 'package:saasify/screens/widgets/buttons/primary_button.dart';
import 'package:saasify/screens/widgets/custom_dialogs.dart';
import 'package:saasify/services/service_locator.dart';
import 'package:saasify/utils/progress_bar.dart';

class AddProductButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final List<CategoriesModel> categories;
  final Products products = getIt<Products>();

  AddProductButton(
      {super.key, required this.formKey, required this.categories});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductBloc, ProductState>(
        listener: (context, state) {
          if (state is AddingProduct) {
            ProgressBar.show(context);
          } else if (state is ProductAdded) {
            ProgressBar.dismiss(context);
            showDialog(
                context: context,
                builder: (context) {
                  return CustomDialogs().showSuccessDialog(
                      context, state.successMessage, onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeScreen()));
                  });
                });
          } else if (state is ProductNotAdded) {
            ProgressBar.dismiss(context);
            showDialog(
                context: context,
                builder: (context) {
                  return CustomDialogs().showAlertDialog(
                      context, state.errorMessage,
                      onPressed: () => Navigator.pop(context));
                });
          }
        },
        child: PrimaryButton(
            buttonTitle: 'Add Product',
            onPressed: () {
              if (formKey.currentState!.validate()) {
                products.categoryId!.isEmpty
                    ? products.categoryId =
                        context.read<CategoryBloc>().selectedCategory
                    : products.categoryId;
                context
                    .read<ProductBloc>()
                    .add(AddProduct(categories: categories));
              }
            }));
  }
}
