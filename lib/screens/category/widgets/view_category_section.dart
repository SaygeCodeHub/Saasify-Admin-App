import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:saasify/configs/app_colors.dart';
import 'package:saasify/configs/app_dimensions.dart';
import 'package:saasify/configs/app_spacing.dart';
import 'package:saasify/configs/app_theme.dart';
import 'package:saasify/models/category/product_categories.dart';

class ViewCategorySection extends StatelessWidget {
  final List<ProductCategories> categories;

  const ViewCategorySection({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(spacingStandard),
        child: Wrap(spacing: spacingLarge, runSpacing: spacingSmall, children: [
          ...List<Widget>.generate(categories.length, (index) {
            return Stack(clipBehavior: Clip.none, children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(kProductCategoryCardRadius),
                    border: Border.all(color: AppColors.lighterGrey)),
                width: MediaQuery.sizeOf(context).width * 0.089,
                height: MediaQuery.sizeOf(context).height * 0.145,
                child: Card(
                  borderOnForeground: false,
                  color: AppColors.lightGrey,
                  elevation: 0.0,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: spacingXXExcel),
                      Text(categories[index].name!,
                          style: Theme.of(context)
                              .textTheme
                              .gridViewLabelTextStyle,
                          textAlign: TextAlign.center)
                    ],
                  ),
                ),
              ),
              Positioned(
                  top: -35,
                  left: 0,
                  right: 0,
                  child: CircleAvatar(
                      radius: kProductCategoryCircleAvatarRadius,
                      backgroundColor: Colors.white,
                      child: ClipOval(
                          child: CachedNetworkImage(
                        imageUrl: categories[index].imagePath.toString(),
                        placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                        width: kProductCategoryCircleAvatarTogether,
                        height: kProductCategoryCircleAvatarTogether,
                        fit: BoxFit.cover,
                      ))))
            ]);
          })
        ]));
  }
}
