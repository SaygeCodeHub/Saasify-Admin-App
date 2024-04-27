import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saasify/bloc/product/product_bloc.dart';
import 'package:saasify/bloc/product/product_state.dart';
import 'package:saasify/configs/app_theme.dart';
import 'package:saasify/screens/billing/pos_grid_popup_screen.dart';
import 'package:saasify/screens/widgets/skeleton_screen.dart';
import '../../bloc/product/product_event.dart';
import '../../configs/app_colors.dart';
import '../../configs/app_dimensions.dart';
import '../../configs/app_spacing.dart';
import '../../models/product/product_model.dart';
import '../../services/server_data_services.dart';
import '../../utils/device_util.dart';
import '../widgets/label_dropdown_widget.dart';

class POSViewCategoryWiseProductScreen extends StatefulWidget {
  const POSViewCategoryWiseProductScreen({super.key});

  @override
  State<POSViewCategoryWiseProductScreen> createState() =>
      _POSViewCategoryWiseProductScreenState();
}

class _POSViewCategoryWiseProductScreenState
    extends State<POSViewCategoryWiseProductScreen> {
  String? selectedCategory;
  ServerDataServices serviceDataServices = ServerDataServices();
  List<DropdownMenuItem<String>> dropdownMenuItems = [];

  @override
  void initState() {
    context.read<ProductBloc>().add(FetchProducts());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SkeletonScreen(
      appBarTitle: 'All Products',
      bottomBarButtons: const [],
      bodyContent: BlocConsumer<ProductBloc, ProductState>(
        listener: (context, state) {
          if (state is ProductsFetched) {
            dropdownMenuItems = state.categoryWiseProductsVariants.entries
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
            return Column(
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
                    itemCount: state
                            .categoryWiseProductsVariants[selectedCategory]
                            ?.keys
                            .length ??
                        0,
                    itemBuilder: (context, productIndex) {
                      ProductsModel product = state
                          .categoryWiseProductsVariants[selectedCategory]!.keys
                          .toList()[productIndex];
                      return InkWell(
                        onTap: () async {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return POSGridPopupScreen(
                                  items: state.categoryWiseProductsVariants[
                                      selectedCategory]![product]!,
                                  screenTitle: 'Variants');
                            },
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  kProductCategoryCardRadius),
                              border: Border.all(color: AppColors.lighterGrey)),
                          child: Padding(
                            padding: const EdgeInsets.all(spacingMedium),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                    backgroundColor: AppColors.lighterGrey,
                                    radius: 45,
                                    backgroundImage: FileImage(
                                        File(product.localImagePath!)),
                                    onBackgroundImageError: (_, __) =>
                                        const AssetImage(
                                            'assets/no_image.jpeg')),
                                const SizedBox(height: spacingMedium),
                                Text(product.name!,
                                    maxLines: 2,
                                    style: Theme.of(context)
                                        .textTheme
                                        .gridViewLabelTextStyle,
                                    textAlign: TextAlign.center),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          } else if (state is ProductNotFetched) {
            return Center(child: Text(state.errorMessage));
          }
          return Container(color: AppColors.white);
        },
      ),
    );
  }
}
