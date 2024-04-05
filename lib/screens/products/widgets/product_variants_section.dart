import 'package:flutter/material.dart';
import 'package:saasify/configs/app_colors.dart';
import 'package:saasify/configs/app_dimensions.dart';
import 'package:saasify/configs/app_spacing.dart';
import 'package:saasify/models/product/product_variant.dart';

class ProductVariantsSection extends StatelessWidget {
  final List<ProductVariant> variants;

  const ProductVariantsSection({super.key, required this.variants});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: GridView.builder(
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      itemCount: variants.length,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            contentPadding: const EdgeInsets.all(spacingSmall),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Quantity: ${variants[index].variantName}'),
                InkWell(
                    onTap: () {},
                    child: const Icon(Icons.edit,
                        size: kEditVariantIconSize, color: AppColors.blue))
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: spacingXXSmall),
                Text('₹ ${variants[index].price.toString()}'),
                Text('Stock: ${variants[index].quantityAvailable.toString()}')
              ],
            ),
          ),
        );
      },
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 15,
          childAspectRatio: 2.3),
    ));
  }
}
