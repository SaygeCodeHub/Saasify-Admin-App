import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saasify/bloc/product/product_bloc.dart';
import 'package:saasify/bloc/product/product_state.dart';
import 'package:saasify/configs/app_theme.dart';
import 'package:saasify/screens/widgets/skeleton_screen.dart';
import '../../bloc/product/product_event.dart';
import '../../configs/app_colors.dart';
import '../../configs/app_dimensions.dart';
import '../../configs/app_spacing.dart';
import '../../utils/device_util.dart';
import '../widgets/label_dropdown_widget.dart';

class AllProductsScreen extends StatefulWidget {
  final bool isFromCart;

  const AllProductsScreen({super.key, this.isFromCart = false});

  @override
  State<AllProductsScreen> createState() => _AllProductsScreenState();
}

class _AllProductsScreenState extends State<AllProductsScreen> {
  String? selectedCategory;
  List<DropdownMenuItem<String>> dropdownMenuItems = [];

  @override
  void initState() {
    context.read<ProductBloc>().add(FetchProducts());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductBloc, ProductState>(
      listener: (context, state) {
        if (state is ProductsFetched) {
          dropdownMenuItems = state.categoryWiseProducts.entries
              .map((entry) => DropdownMenuItem<String>(
                    value: entry.key,
                    child: Text(entry.key),
                  ))
              .toList();
          if (dropdownMenuItems.isNotEmpty && selectedCategory == null) {
            selectedCategory = dropdownMenuItems.first.value;
          }
        }
      },
      builder: (context, state) {
        if (state is FetchingProducts) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ProductsFetched) {
          return SkeletonScreen(
            appBarTitle: 'Products',
            bottomBarButtons: const [],
            bodyContent: Column(
              children: [
                LabelDropdownWidget<String>(
                  label: "Category",
                  initialValue: selectedCategory,
                  items: dropdownMenuItems,
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value;
                    });
                  },
                ),
                const SizedBox(height: spacingXLarge),
                Expanded(
                  child: GridView.builder(
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: DeviceUtils.isMobile(context) ? 2 : 6,
                      crossAxisSpacing: spacingLarge,
                      mainAxisSpacing: spacingSmall,
                      childAspectRatio:
                          DeviceUtils.isMobile(context) ? 0.8 : 0.73,
                    ),
                    itemCount:
                        state.categoryWiseProducts[selectedCategory]?.length ??
                            0,
                    itemBuilder: (context, index) {
                      var product =
                          state.categoryWiseProducts[selectedCategory]![index];
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(kProductCategoryCardRadius),
                          border: Border.all(color: AppColors.lighterGrey),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(spacingMedium),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundImage:
                                    FileImage(File(product.localImagePath!)),
                              ),
                              const SizedBox(height: spacingMedium),
                              Text(
                                product.name!,
                                style: Theme.of(context)
                                    .textTheme
                                    .gridViewLabelTextStyle,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        } else if (state is ProductNotFetched) {
          return Center(
            child: Text(state.errorMessage),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
