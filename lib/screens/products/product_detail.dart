import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saasify/bloc/product/product_bloc.dart';
import 'package:saasify/bloc/product/product_event.dart';
import 'package:saasify/bloc/product/product_state.dart';
import 'package:saasify/configs/app_colors.dart';
import 'package:saasify/configs/app_spacing.dart';
import 'package:saasify/configs/app_theme.dart';
import 'package:saasify/screens/products/add_product_screen.dart';
import 'package:saasify/screens/products/variants/add_variant_screen.dart';
import 'package:saasify/screens/widgets/skeleton_screen.dart';
import 'package:saasify/utils/error_display.dart';

class ProductDetails extends StatelessWidget {
  final String categoryId;
  final String productId;

  const ProductDetails(
      {super.key, required this.categoryId, required this.productId});

  @override
  Widget build(BuildContext context) {
    context
        .read<ProductBloc>()
        .add(FetchProduct(categoryId: categoryId, productId: productId));
    var width = MediaQuery.of(context).size.width;
    int crossAxisCount = width > 600 ? 5 : 2;
    return SkeletonScreen(
      appBarTitle: 'Product Details',
      bodyContent: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is FetchingProduct) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProductFetched) {
            return Padding(
              padding: const EdgeInsets.all(spacingMedium),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: () {},
                            child: const Text('Edit Product')),
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AddVariantScreen(
                                              dataMap: {
                                                'category_id': categoryId,
                                                'product_id': productId
                                              })));
                            },
                            child: const Text('Add Variant'))
                      ],
                    ),
                    SizedBox(
                      height: 150,
                      width: 150,
                      child: CachedNetworkImage(
                          imageUrl: state.products.imageUrl,
                          placeholder: (context, url) =>
                              const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) => Container(
                              color: AppColors.lighterGrey,
                              height: 50,
                              child: const Icon(Icons.image, size: 20)),
                          fit: BoxFit.fitHeight),
                    ),
                    const SizedBox(height: spacingMedium),
                    _buildDetailRow('Product Name:', state.products.name),
                    _buildDetailRow('Category:', state.products.category),
                    _buildDetailRow(
                      'Description:',
                      state.products.description,
                    ),
                    _buildDetailRow('Supplier:', state.products.supplier),
                    _buildDetailRow('Minimum Stock Level:',
                        state.products.minStockLevel.toString()),
                    const Divider(),
                    const SizedBox(height: spacingSmall),
                    Visibility(
                      visible: state.products.variants.isNotEmpty,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Variants',
                                style: Theme.of(context)
                                    .textTheme
                                    .fieldLabelTextStyle),
                            const SizedBox(height: spacingSmall),
                            GridView.builder(
                              physics: const BouncingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: state.products.variants.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  child: ListTile(
                                    contentPadding:
                                        const EdgeInsets.all(spacingSmall),
                                    title: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                            'Quantity: ${state.products.variants[index].variantName}'),
                                        InkWell(
                                            onTap: () {},
                                            child: const Icon(Icons.edit,
                                                size: 18,
                                                color: AppColors.blue)),
                                      ],
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: spacingXXSmall),
                                        Text(
                                            '₹ ${state.products.variants[index].price.toString()}'),
                                        Text(
                                            'Stock: ${state.products.variants[index].quantityAvailable.toString()}')
                                      ],
                                    ),
                                  ),
                                );
                              },
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: crossAxisCount,
                                      mainAxisSpacing: 10.0,
                                      crossAxisSpacing: 15,
                                      childAspectRatio: 2.3),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
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

  Widget _buildDetailRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: spacingSmall),
        Text(value),
        const SizedBox(height: spacingMedium),
      ],
    );
  }
}
