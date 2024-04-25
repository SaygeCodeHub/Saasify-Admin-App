import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:saasify/configs/app_colors.dart';
import 'package:saasify/configs/app_dimensions.dart';
import 'package:saasify/configs/app_spacing.dart';
import 'package:saasify/models/product/product_model.dart';

class ProductDetailsSection extends StatelessWidget {
  final ProductsModel products;

  const ProductDetailsSection({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ListTile(
              contentPadding: const EdgeInsets.all(spacingSmall),
              leading: CachedNetworkImage(
                  width: kNetworkImageWidth,
                  height: kNetworkImageHeight,
                  imageUrl: products.localImagePath ?? '',
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Container(
                      color: AppColors.lighterGrey,
                      height: kNetworkImageContainerHeight,
                      child:
                          const Icon(Icons.image, size: kNetworkImageIconSize)),
                  fit: BoxFit.cover),
              title: Text('Product Name: ${products.name}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: spacingXXSmall),
                  Text('Category: ${products.categoryId}'),
                  Text('Description: ${products.description}'),
                  Text('Supplier: ${products.supplier}'),
                ],
              )),
        ),
        TextButton(onPressed: () {}, child: const Text('Edit Product'))
      ],
    );
  }
}
