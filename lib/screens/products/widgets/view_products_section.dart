import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saasify/bloc/category/category_bloc.dart';
import 'package:saasify/bloc/category/category_event.dart';
import 'package:saasify/configs/app_colors.dart';
import 'package:saasify/configs/app_spacing.dart';
import 'package:saasify/configs/app_theme.dart';
import 'package:saasify/models/category/categories_model.dart';
import 'package:saasify/screens/widgets/product_card_widget.dart';

class ViewProductsSection extends StatelessWidget {
  final List<CategoriesModel> categories;

  const ViewProductsSection({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
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
                    style: Theme.of(context).textTheme.fieldLabelTextStyle),
                const SizedBox(height: spacingSmall),
                Wrap(
                  spacing: spacingXSmall,
                  runSpacing: spacingXXSmall,
                  children: categories.map((label) {
                    bool isSelected = label.categoryId.toString() ==
                        context.read<CategoryBloc>().selectedCategory;
                    return InkWell(
                      onTap: () {
                        context.read<CategoryBloc>().selectedCategory =
                            label.categoryId.toString();
                        context.read<CategoryBloc>().add(
                            FetchProductsForSelectedCategory(
                                categories: categories));
                      },
                      child: Chip(
                        label: Text(
                          label.name!,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                        backgroundColor:
                            isSelected ? Colors.blue : Colors.grey[200],
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
                  style: Theme.of(context).textTheme.fieldLabelTextStyle,
                ),
                const SizedBox(height: spacingXHuge),
                SingleChildScrollView(
                    child:
                        ProductCardWidget(list: categories, isFromCart: false)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
