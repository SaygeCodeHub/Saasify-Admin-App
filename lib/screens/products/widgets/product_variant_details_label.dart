import 'package:flutter/material.dart';
import 'package:saasify/configs/app_theme.dart';

class ProductVariantDetailsLabel extends StatelessWidget {
  final String categoryId;
  final String productId;

  const ProductVariantDetailsLabel(
      {super.key, required this.categoryId, required this.productId});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Variants',
            style: Theme.of(context).textTheme.fieldLabelTextStyle),
        TextButton(
            onPressed: () {
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => AddVariantScreen(dataMap: {
              //               'category_id': categoryId,
              //               'product_id': productId
              //             })));
            },
            child: const Text('Add Variant'))
      ],
    );
  }
}
