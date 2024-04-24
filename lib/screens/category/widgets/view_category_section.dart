import 'dart:io';
import 'package:flutter/material.dart';
import 'package:saasify/configs/app_colors.dart';
import 'package:saasify/configs/app_dimensions.dart';
import 'package:saasify/configs/app_spacing.dart';
import 'package:saasify/configs/app_theme.dart';
import 'package:saasify/models/category/categories_model.dart';

import '../../../utils/device_util.dart';

class ViewCategorySection extends StatelessWidget {
  final List<CategoriesModel> categories;

  const ViewCategorySection({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: DeviceUtils.isMobile(context) ? 2 : 6,
        crossAxisSpacing: spacingLarge,
        mainAxisSpacing: spacingSmall,
        childAspectRatio: DeviceUtils.isMobile(context) ? 0.8 : 0.73,
      ),
      itemCount: categories.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(kProductCategoryCardRadius),
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
                      FileImage(File(categories[index].localImagePath!)),
                ),
                const SizedBox(height: spacingMedium),
                Text(
                  categories[index].name!,
                  style: Theme.of(context).textTheme.gridViewLabelTextStyle,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
