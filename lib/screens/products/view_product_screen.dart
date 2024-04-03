import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saasify/bloc/category/category_bloc.dart';
import 'package:saasify/bloc/category/category_event.dart';
import 'package:saasify/bloc/category/category_state.dart';
import 'package:saasify/configs/app_spacing.dart';
import 'package:saasify/configs/app_theme.dart';
import 'package:saasify/screens/category/add_category_screen.dart';
import 'package:saasify/screens/widgets/product_card_widget.dart';
import 'package:saasify/screens/widgets/skeleton_screen.dart';
import 'package:saasify/utils/error_display.dart';
import '../../configs/app_colors.dart';

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
              return Padding(
                padding: const EdgeInsets.all(spacingStandard),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Categories',
                              style: Theme.of(context)
                                  .textTheme
                                  .fieldLabelTextStyle),
                          const SizedBox(height: spacingSmall),
                          Wrap(
                            spacing: 8.0,
                            runSpacing: 4.0,
                            children: state.categories.map((label) {
                              bool isSelected = label.categoryId.toString() ==
                                  context.read<CategoryBloc>().selectedCategory;
                              return InkWell(
                                onTap: () {
                                  context
                                          .read<CategoryBloc>()
                                          .selectedCategory =
                                      label.categoryId.toString();
                                  context.read<CategoryBloc>().add(
                                      FetchProductsForSelectedCategory(
                                          categories: state.categories));
                                },
                                child: Chip(
                                  label: Text(
                                    label.name,
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                  backgroundColor: isSelected
                                      ? Colors.blue
                                      : Colors.grey[200],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    side: const BorderSide(
                                      color: AppColors.lighterGrey,
                                      width: 1,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          const Divider(),
                          const SizedBox(height: spacingSmall),
                          Text(
                            'Product',
                            style:
                                Theme.of(context).textTheme.fieldLabelTextStyle,
                          ),
                          const SizedBox(height: spacingXHuge),
                          SingleChildScrollView(
                              child: ProductCardWidget(
                                  list: state.categories, isFromCart: false)),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is CategoriesWithProductsNotFetched) {
              return Center(
                child: ErrorDisplay(
                    text: state.errorMessage,
                    buttonText: 'Add Category',
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddCategoryScreen()));
                    }),
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
        bottomBarButtons: const []);
  }
}
