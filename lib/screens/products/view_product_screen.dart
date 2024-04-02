import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saasify/bloc/product/product_bloc.dart';
import 'package:saasify/bloc/product/product_event.dart';
import 'package:saasify/bloc/product/product_state.dart';
import 'package:saasify/configs/app_spacing.dart';
import 'package:saasify/configs/app_theme.dart';
import 'package:saasify/models/cart_model.dart';
import 'package:saasify/screens/billing/billing_cart_screen.dart';
import 'package:saasify/screens/category/add_category_screen.dart';
import 'package:saasify/screens/products/product_detail.dart';
import 'package:saasify/screens/widgets/skeleton_screen.dart';
import 'package:saasify/utils/error_display.dart';
import '../../configs/app_colors.dart';

class AllProductsScreen extends StatelessWidget {
  final bool isFromCart;

  const AllProductsScreen({super.key, this.isFromCart = false});

  @override
  Widget build(BuildContext context) {
    context.read<ProductBloc>().add(FetchProducts());
    return SkeletonScreen(
        appBarTitle: 'Products',
        bodyContent: BlocBuilder<ProductBloc, ProductState>(
          buildWhen: (previousState, currentState) =>
              currentState is FetchingProducts ||
              currentState is ProductsFetched ||
              currentState is ProductsCouldNotFetch,
          builder: (context, state) {
            if (state is FetchingProducts) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProductsFetched) {
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
                                  .productLabelTextStyle),
                          const SizedBox(height: spacingSmall),
                          Wrap(
                            spacing: spacingSmall,
                            children: state.categories.map((chip) {
                              return FilterChip(
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
                                    context.read<ProductBloc>().add(
                                        SelectCategory(
                                            categoryId: chip.categoryId ?? '',
                                            categories: state.categories));
                                  });
                            }).toList(),
                          ),
                          const SizedBox(height: spacingStandard),
                          Text('Products',
                              style: Theme.of(context)
                                  .textTheme
                                  .productLabelTextStyle),
                          Expanded(
                            child: GridView.builder(
                              shrinkWrap: true,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 5,
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
                                          borderRadius: BorderRadius.circular(
                                              spacingSmall),
                                          elevation: 4,
                                          child: InkWell(
                                            onTap: () {
                                              if (isFromCart) {
                                                showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return Dialog(
                                                        child: Container(
                                                          width: 400,
                                                          height: 400,
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(16),
                                                          child: SizedBox(
                                                            height: 50,
                                                            width: 50,
                                                            child: GridView
                                                                .builder(
                                                                    shrinkWrap:
                                                                        true,
                                                                    itemCount: state
                                                                        .products[
                                                                            index]
                                                                        .variants
                                                                        .length,
                                                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                                                        crossAxisCount:
                                                                            2,
                                                                        mainAxisSpacing:
                                                                            10.0,
                                                                        crossAxisSpacing:
                                                                            20,
                                                                        childAspectRatio:
                                                                            1),
                                                                    itemBuilder:
                                                                        (context,
                                                                            variantIndex) {
                                                                      return InkWell(
                                                                        onTap:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context);
                                                                          List<Billing>
                                                                              billing =
                                                                              [];
                                                                          billing.add(Billing(
                                                                              cost: 0,
                                                                              name: state.products[index].name,
                                                                              quantity: state.products[index].variants[variantIndex].variantName,
                                                                              count: 0,
                                                                              variantCost: state.products[index].variants[variantIndex].price,
                                                                              showCart: true));
                                                                          context
                                                                              .read<ProductBloc>()
                                                                              .add(
                                                                                AddToCart(
                                                                                  billingList: billing,
                                                                                  billing: Billing(cost: 0, name: state.products[index].name, quantity: state.products[index].variants[variantIndex].variantName, count: 0, variantCost: state.products[index].variants[variantIndex].price, showCart: true),
                                                                                ),
                                                                              );
                                                                        },
                                                                        child:
                                                                            Card(
                                                                          child:
                                                                              Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: [
                                                                              Text(state.products[index].variants[variantIndex].variantName, style: Theme.of(context).textTheme.variantQuantityTextStyle),
                                                                              Text('₹ ${state.products[index].variants[variantIndex].price.toString()}'),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      );
                                                                    }),
                                                          ),
                                                        ),
                                                      );
                                                    });
                                              } else {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ProductDetails(
                                                                categoryId: state
                                                                    .products[
                                                                        index]
                                                                    .category,
                                                                productId: state
                                                                    .products[
                                                                        index]
                                                                    .productId)));
                                              }
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        spacingSmall),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(
                                                    spacingLarge),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    const SizedBox(
                                                        height: spacingXXExcel),
                                                    Text(
                                                      state
                                                          .products[index].name,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .gridViewLabelTextStyle,
                                                    ),
                                                    const SizedBox(
                                                        height:
                                                            spacingSmallest),
                                                    Text(
                                                        state.products[index]
                                                            .description,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyMedium,
                                                        textAlign:
                                                            TextAlign.center),
                                                    const SizedBox(
                                                        height:
                                                            spacingSmallest),
                                                  ],
                                                ),
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
                                                errorWidget:
                                                    (context, url, error) =>
                                                        ClipOval(
                                                          child: Container(
                                                              color: AppColors
                                                                  .lighterGrey,
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
                    ),
                    const BillingCartScreen()
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
