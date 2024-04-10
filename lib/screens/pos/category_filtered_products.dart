import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saasify/bloc/category/category_event.dart';
import 'package:saasify/configs/app_dimensions.dart';
import 'package:saasify/configs/app_theme.dart';
import 'package:saasify/screens/category/add_category_screen.dart';
import 'package:saasify/utils/error_display.dart';

import '../../bloc/category/category_bloc.dart';
import '../../bloc/category/category_state.dart';
import '../../configs/app_colors.dart';
import '../../configs/app_spacing.dart';
import '../widgets/product_card_widget.dart';

class CategoryFilteredProducts extends StatelessWidget {
  const CategoryFilteredProducts({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(spacingSmall),
      child: BlocBuilder<CategoryBloc, CategoryState>(
        builder: (context, state) {
          if (state is FetchingCategoriesWithProducts) {
            return Padding(
                padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.width * 0.15,
                    horizontal: spacingLarge),
                child: const Center(child: CircularProgressIndicator()));
          } else if (state is CategoriesWithProductsFetched) {
            if (state.categories.isNotEmpty) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('Categories',
                      style: Theme.of(context).textTheme.fieldLabelTextStyle),
                  const SizedBox(height: spacingSmall),
                  Wrap(
                    spacing: spacingXSmall,
                    runSpacing: spacingXXSmall,
                    children: state.categories.map((label) {
                      bool isSelected = label.categoryId.toString() ==
                          context.read<CategoryBloc>().selectedCategory;
                      return InkWell(
                        onTap: () {
                          context.read<CategoryBloc>().selectedCategory =
                              label.categoryId.toString();
                          context.read<CategoryBloc>().add(
                              FetchProductsForSelectedCategory(
                                  categories: state.categories));
                        },
                        child: Chip(
                          label: Text(
                            label.name!,
                            style: TextStyle(
                              color: isSelected
                                  ? AppColors.white
                                  : AppColors.black,
                            ),
                          ),
                          backgroundColor:
                              isSelected ? AppColors.blue : Colors.grey[200],
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(kCategoryChipRadius),
                            side: const BorderSide(
                                color: AppColors.lighterGrey, width: 1),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const Divider(),
                  const SizedBox(height: spacingSmall),
                  Text(
                    'Product',
                    style: Theme.of(context).textTheme.fieldLabelTextStyle,
                  ),
                  const SizedBox(height: spacingXHuge),
                  SingleChildScrollView(
                      child: ProductCardWidget(
                          list: state.categories, isFromCart: true)),
                ],
              );
            } else {
              return Padding(
                padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.sizeOf(context).width * 0.13),
                child: Center(
                  child: ErrorDisplay(
                      pageNotFound: true,
                      text: 'No category found!',
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
    );
  }
}
