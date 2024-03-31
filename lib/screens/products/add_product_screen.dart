import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saasify/bloc/category/category_bloc.dart';
import 'package:saasify/bloc/category/category_event.dart';
import 'package:saasify/bloc/category/category_state.dart';
import 'package:saasify/bloc/imagePicker/image_picker_bloc.dart';
import 'package:saasify/bloc/product/product_bloc.dart';
import 'package:saasify/bloc/product/product_state.dart';
import 'package:saasify/screens/category/add_category_screen.dart';
import 'package:saasify/screens/products/add_product_section.dart';
import 'package:saasify/screens/widgets/buttons/primary_button.dart';
import 'package:saasify/screens/widgets/custom_dialogs.dart';
import 'package:saasify/utils/error_display.dart';
import 'package:saasify/utils/progress_bar.dart';
import '../../bloc/product/product_event.dart';
import '../../models/category/product_categories.dart';
import '../widgets/skeleton_screen.dart';

class AddProductScreen extends StatelessWidget {
  AddProductScreen({super.key});

  static List<ProductCategories> categories = [];
  final formKey = GlobalKey<FormState>();

  static String image = '';

  static Map soldByMap = {'selected_value': 'Each', 'selected_quantity': 'kg'};
  final Map productMap = {};

  @override
  Widget build(BuildContext context) {
    context.read<CategoryBloc>().add(FetchCategories());
    context.read<ImagePickerBloc>().imagePath = '';
    return SkeletonScreen(
        appBarTitle: 'Add Product',
        bodyContent: Form(
          key: formKey,
          child: BlocBuilder<CategoryBloc, CategoryState>(
            builder: (context, state) {
              if (state is FetchingCategories) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is CategoriesFetched) {
                categories = state.categories;
                return SingleChildScrollView(
                    child: _buildForm(context, state.imagePath));
              } else if (state is CategoriesNotFetched) {
                return SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: MediaQuery.sizeOf(context).width * 0.2),
                    child: Center(
                      child: ErrorDisplay(
                        text: state.errorMessage,
                        buttonText: 'Add Category',
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddCategoryScreen()));
                        },
                      ),
                    ),
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ),
        bottomBarButtons: [
          BlocListener<ProductBloc, ProductState>(
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
                          Navigator.pop(context);
                        });
                      });
                } else if (state is ProductNotAdded) {
                  ProgressBar.dismiss(context);
                  showDialog(
                      context: context,
                      builder: (context) {
                        return CustomDialogs().showSuccessDialog(
                            context, state.errorMessage,
                            onPressed: () => Navigator.pop(context));
                      });
                }
              },
              child: PrimaryButton(
                  buttonTitle: 'Add Product',
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      if (productMap['category_id'] == null) {
                        productMap['category_id'] =
                            context.read<CategoryBloc>().selectedCategory;
                        context.read<ProductBloc>().add(AddProduct(
                            categories: categories, productMap: productMap));
                      } else {
                        context.read<ProductBloc>().add(AddProduct(
                            categories: categories, productMap: productMap));
                      }
                    }
                  }))
        ]);
  }

  Widget _buildForm(BuildContext context, String imagePath) {
    return AddProductSection(
        categories: categories, soldByMap: soldByMap, productMap: productMap);
  }
}
