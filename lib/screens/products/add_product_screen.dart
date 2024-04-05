import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saasify/bloc/category/category_bloc.dart';
import 'package:saasify/bloc/category/category_event.dart';
import 'package:saasify/bloc/category/category_state.dart';
import 'package:saasify/bloc/imagePicker/image_picker_bloc.dart';
import 'package:saasify/enums/product_sold_by_enum.dart';
import 'package:saasify/models/product/products.dart';
import 'package:saasify/screens/category/add_category_screen.dart';
import 'package:saasify/screens/products/widgets/add_product_button.dart';
import 'package:saasify/screens/products/widgets/add_product_section.dart';
import 'package:saasify/services/service_locator.dart';
import 'package:saasify/utils/error_display.dart';
import '../../models/category/product_categories.dart';
import '../widgets/skeleton_screen.dart';

class AddProductScreen extends StatelessWidget {
  AddProductScreen({super.key});

  static List<ProductCategories> categories = [];
  final formKey = GlobalKey<FormState>();
  final Products products = getIt<Products>();

  @override
  Widget build(BuildContext context) {
    context.read<CategoryBloc>().add(FetchCategoriesWithProducts());
    context.read<ImagePickerBloc>().imagePath = '';
    products.soldBy = ProductSoldByEnum.each.soldBy;
    return SkeletonScreen(
        appBarTitle: 'Add Product',
        bodyContent: Form(
          key: formKey,
          child: BlocBuilder<CategoryBloc, CategoryState>(
            builder: (context, state) {
              if (state is FetchingCategoriesWithProducts) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is CategoriesWithProductsFetched) {
                categories = state.categories;
                return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: _buildForm(context, state.imagePath));
              } else if (state is CategoriesWithProductsNotFetched) {
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
          AddProductButton(formKey: formKey, categories: categories)
        ]);
  }

  Widget _buildForm(BuildContext context, String imagePath) {
    return AddProductSection(categories: categories);
  }
}
