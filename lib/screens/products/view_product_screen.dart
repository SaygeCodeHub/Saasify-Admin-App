import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saasify/bloc/product/product_bloc.dart';
import 'package:saasify/bloc/product/product_event.dart';
import 'package:saasify/bloc/product/product_state.dart';
import 'package:saasify/configs/app_spacing.dart';
import 'package:saasify/configs/app_theme.dart';
import 'package:saasify/screens/category/add_category_screen.dart';
import 'package:saasify/screens/widgets/skeleton_screen.dart';
import 'package:saasify/utils/error_display.dart';

import '../../configs/app_colors.dart';

class AllProductsScreen extends StatelessWidget {
  const AllProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<ProductBloc>().add(ViewProducts());
    var width = MediaQuery.of(context).size.width;
    int crossAxisCount = width > 600 ? 5 : 2;
    return SkeletonScreen(
        appBarTitle: 'Products',
        bodyContent: BlocBuilder<ProductBloc, ProductState>(
          builder: (context, state) {
            if (state is FetchingProducts) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProductsFetched) {
              return Padding(
                padding: const EdgeInsets.all(spacingStandard),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Categories',
                        style:
                            Theme.of(context).textTheme.productLabelTextStyle),
                    const SizedBox(height: spacingSmall),
                    Wrap(
                      spacing: spacingSmall,
                      children: state.categories
                          .map((chip) => FilterChip(
                              label: Text(chip.name),
                              selected: state.selectedCategories
                                  .contains(chip.categoryId),
                              labelStyle: TextStyle(
                                  color: state.selectedCategories
                                          .contains(chip.categoryId)
                                      ? AppColors.grey
                                      : AppColors.black),
                              selectedColor: state.selectedCategories
                                      .contains(chip.categoryId)
                                  ? AppColors.successGreen
                                  : AppColors.grey,
                              onSelected: (value) {
                                context.read<ProductBloc>().add(SelectCategory(
                                    categoryId: chip.categoryId ?? '',
                                    categories: state.categories));
                              }))
                          .toList(),
                    ),
                    const SizedBox(height: spacingStandard),
                    Text('Products',
                        style:
                            Theme.of(context).textTheme.productLabelTextStyle),
                    Expanded(
                      child: GridView.builder(
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            mainAxisSpacing: 10.0,
                            crossAxisSpacing: 20,
                            childAspectRatio: 0.95),
                        itemCount: state.products.length,
                        itemBuilder: (context, index) {
                          return Padding(
                              padding: const EdgeInsets.all(10),
                              child: Stack(children: [
                                Positioned(
                                  top: 44,
                                  left: 0,
                                  right: 0,
                                  child: Material(
                                    borderRadius:
                                        BorderRadius.circular(spacingSmall),
                                    elevation: 4,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(spacingSmall),
                                      ),
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.all(spacingLarge),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            const SizedBox(
                                                height: spacingXXExcel),
                                            Text(
                                              state.products[index].name,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .gridViewLabelTextStyle,
                                            ),
                                            const SizedBox(
                                                height: spacingSmallest),
                                            Text(
                                                state.products[index]
                                                    .description,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium,
                                                textAlign: TextAlign.center),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                    top: 0,
                                    left: 0,
                                    right: 0,
                                    child: Center(
                                        child: ClipOval(
                                            child: SizedBox(
                                      height: 100,
                                      width: 100,
                                      child: CachedNetworkImage(
                                          imageUrl: state
                                              .products[index].imageUrl
                                              .toString(),
                                          placeholder: (context, url) =>
                                              const Center(
                                                  child:
                                                      CircularProgressIndicator()),
                                          errorWidget: (context, url, error) =>
                                              ClipOval(
                                                child: Container(
                                                    color:
                                                        AppColors.lighterGrey,
                                                    height: 100,
                                                    width: 100,
                                                    child: const Icon(
                                                        Icons.image,
                                                        size: 40)),
                                              ),
                                          fit: BoxFit.cover),
                                    ))))
                              ]));
                        },
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is ProductsCouldNotFetch) {
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
