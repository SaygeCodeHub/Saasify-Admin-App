import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saasify/bloc/category/category_bloc.dart';
import 'package:saasify/bloc/category/category_event.dart';
import 'package:saasify/bloc/category/category_state.dart';
import 'package:saasify/screens/category/add_category_screen.dart';
import 'package:saasify/screens/products/widgets/view_products_section.dart';
import 'package:saasify/screens/widgets/skeleton_screen.dart';
import 'package:saasify/utils/error_display.dart';

class AllProductsScreen extends StatelessWidget {
  final bool isFromCart;

  const AllProductsScreen({super.key, this.isFromCart = false});

  @override
  Widget build(BuildContext context) {
    context.read<CategoryBloc>().add(FetchCategoriesWithProducts());
    return SkeletonScreen(
        appBarTitle: 'Products',
        bodyContent: BlocBuilder<CategoryBloc, CategoryState>(
          buildWhen: (previousState, currentState) =>
              currentState is FetchingCategoriesWithProducts ||
              currentState is CategoriesWithProductsFetched ||
              currentState is CategoriesWithProductsNotFetched,
          builder: (context, state) {
            if (state is FetchingCategoriesWithProducts) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is CategoriesWithProductsFetched) {
              if (state.categories.isNotEmpty) {
                return ViewProductsSection(categories: state.categories);
              } else {
                return Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.sizeOf(context).width * 0.13),
                  child: Center(
                    child: ErrorDisplay(
                        pageNotFound: true,
                        text: 'No product found!',
                        buttonText: 'Add Category',
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddCategoryScreen()));
                        }),
                  ),
                );
              }
            } else if (state is CategoriesWithProductsNotFetched) {
              return Padding(
                padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.sizeOf(context).width * 0.13),
                child: Center(
                  child: ErrorDisplay(
                      text: state.errorMessage,
                      buttonText: 'Add Category',
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddCategoryScreen()));
                      }),
                ),
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
        bottomBarButtons: const []);
  }
}
