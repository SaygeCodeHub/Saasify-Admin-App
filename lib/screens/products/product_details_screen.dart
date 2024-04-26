import 'dart:io';
import 'package:flutter/material.dart';
import 'package:saasify/cache/company_cache.dart';
import 'package:saasify/configs/app_spacing.dart';
import 'package:saasify/configs/app_theme.dart';
import 'package:saasify/models/companies/company.dart';
import 'package:saasify/models/product/product_model.dart';
import 'package:saasify/screens/products/variants/add_variant_screen.dart';
import 'package:saasify/screens/widgets/skeleton_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../configs/app_colors.dart';
import '../../configs/app_dimensions.dart';
import '../../models/product/product_variant.dart';
import '../../services/service_locator.dart';
import '../../utils/global.dart';

class ProductDetailsScreen extends StatelessWidget {
  final ProductsModel productsModel;
  final List<ProductVariant> variants;

  const ProductDetailsScreen(
      {super.key, required this.productsModel, required this.variants});

  @override
  Widget build(BuildContext context) {
    return SkeletonScreen(
      appBarTitle: 'Product Details',
      bottomBarButtons: const [],
      bodyContent: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(kProductCategoryCardRadius),
                    border: Border.all(color: AppColors.lighterGrey),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(spacingMedium),
                    child: CircleAvatar(
                      backgroundColor: AppColors.lighterGrey,
                      radius: 60,
                      backgroundImage:
                          FileImage(File(productsModel.localImagePath!)),
                      onBackgroundImageError: (_, __) =>
                          const AssetImage('assets/no_image.jpeg'),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () {}, child: const Text('Edit Product')),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddVariantScreen(
                                      productsModel: productsModel)));
                        },
                        child: const Text('Add Variant')),
                    TextButton(
                        onPressed: () {}, child: const Text('Delete Product')),
                  ],
                ),
              ],
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: spacingMedium),
                  ListTile(
                    visualDensity: VisualDensity.compact,
                    contentPadding: EdgeInsets.zero,
                    horizontalTitleGap: 0.0,
                    minVerticalPadding: 0.0,
                    title: Text(productsModel.name!,
                        style: Theme.of(context)
                            .textTheme
                            .labelTextStyle
                            .copyWith(
                                fontWeight: FontWeight.w700, fontSize: 16),
                        textAlign: TextAlign.start),
                    subtitle: Text(
                      productsModel.description ?? 'No description provided.',
                      style: Theme.of(context)
                          .textTheme
                          .labelTextStyle
                          .copyWith(fontWeight: FontWeight.w100, fontSize: 14),
                      textAlign: TextAlign.start,
                      maxLines: 15,
                    ),
                  ),
                  const SizedBox(height: spacingXSmall),
                  TabBar(
                    labelStyle: Theme.of(context)
                        .textTheme
                        .labelTextStyle
                        .copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: AppColors.blue),
                    tabs: const [
                      Tab(text: 'Details'),
                      Tab(text: 'Variants'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: _buildDetailList(context),
                          ),
                        ),
                        SingleChildScrollView(
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: variants.length,
                              itemBuilder: (context, index) {
                                return (variants.isEmpty)
                                    ? const Text('No Variants')
                                    : ListTile(
                                        visualDensity: VisualDensity.compact,
                                        contentPadding: EdgeInsets.zero,
                                        horizontalTitleGap: 0.0,
                                        minVerticalPadding: 0.0,
                                        leading: Image.file(
                                            File(productsModel.localImagePath!),
                                            width: 100,
                                            height: 100),
                                        title: Text(
                                            variants[index]
                                                .variantName
                                                .toString(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelTextStyle
                                                .copyWith(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 15)),
                                        subtitle: Text(
                                            '$currencySymbol ${variants[index].sellingPrice.toString()}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelTextStyle
                                                .copyWith(
                                                    fontSize: 13,
                                                    color:
                                                        AppColors.cementGrey)),
                                      );
                              }),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildDetailList(BuildContext context) {
    return [
      _buildDetailRow(context, 'Tax', productsModel.tax?.toString() ?? 'N/A'),
      _buildDetailRow(context, 'Supplier', productsModel.supplier ?? 'N/A'),
      _buildDetailRow(context, 'Sold By', productsModel.soldBy),
      _buildDetailRow(
          context, 'Active', productsModel.isActive == true ? 'Yes' : 'No'),
      _buildDetailRow(context, 'Product ID', productsModel.productId),
      _buildDetailRow(context, 'Category ID', productsModel.categoryId),
      _buildDetailRow(context, 'Synced to Server',
          productsModel.isUploadedToServer == true ? 'Yes' : 'No'),
    ];
  }

  Widget _buildDetailRow(BuildContext context, String label, String? value) {
    return ListTile(
      visualDensity: VisualDensity.compact,
      contentPadding: EdgeInsets.zero,
      horizontalTitleGap: 0.0,
      minVerticalPadding: 0.0,
      title: Text('$label : ',
          style: Theme.of(context)
              .textTheme
              .labelMedium
              ?.copyWith(fontWeight: FontWeight.bold)),
      subtitle: Text(value ?? 'Not specified',
          style: Theme.of(context)
              .textTheme
              .labelMedium
              ?.copyWith(color: AppColors.cementGrey)),
    );
  }
}
