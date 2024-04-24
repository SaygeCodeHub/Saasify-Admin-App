import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saasify/bloc/product/product_bloc.dart';
import 'package:saasify/bloc/product/product_state.dart';
import 'package:saasify/configs/app_spacing.dart';
import 'package:saasify/screens/products/add_product_screen.dart';
import 'package:saasify/screens/products/widgets/product_details_section.dart';
import 'package:saasify/screens/products/widgets/product_variant_details_label.dart';
import 'package:saasify/screens/products/widgets/product_variants_section.dart';
import 'package:saasify/screens/widgets/skeleton_screen.dart';
import 'package:saasify/utils/error_display.dart';

class ProductDetailsScreen extends StatelessWidget {
  final String categoryId;
  final String productId;

  const ProductDetailsScreen(
      {super.key, required this.categoryId, required this.productId});

  @override
  Widget build(BuildContext context) {
    // context
    //     .read<ProductBloc>()
    //     .add(FetchProducts(categoryId: categoryId, productId: productId));
    return SkeletonScreen(
      appBarTitle: 'Product Details',
      bodyContent: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is FetchingProducts) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProductFetched) {
            return Padding(
              padding: const EdgeInsets.all(spacingMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProductDetailsSection(products: state.products),
                  const SizedBox(height: spacingSmall),
                  const Divider(),
                  const SizedBox(height: spacingSmall),
                  ProductVariantDetailsLabel(
                      categoryId: categoryId, productId: productId),
                  if (state.products.variants != null &&
                      state.products.variants!.isNotEmpty)
                    ProductVariantsSection(
                        variants: state.products.variants ?? [])
                ],
              ),
            );
          } else if (state is ProductNotFetched) {
            return ErrorDisplay(
                text: state.errorMessage,
                buttonText: 'Add Product',
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddProductScreen()));
                });
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
      bottomBarButtons: const [],
    );
  }
}
