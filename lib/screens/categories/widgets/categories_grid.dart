import 'package:flutter/material.dart';
import 'package:saasify/configs/app_theme.dart';
import '../../../configs/app_color.dart';
import '../../../configs/app_dimensions.dart';
import '../../../configs/app_spacing.dart';
import '../../../data/models/categories/fetch_all_categories_model.dart';
import 'categories_pop_up_menu_widget.dart';
import 'category_toggle_widget.dart';

class CategoriesGrid extends StatelessWidget {
  final List<ProductCategory> productCategory;

  const CategoriesGrid({super.key, required this.productCategory});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        shrinkWrap: true,
        itemCount: productCategory.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
              height: spacingStandard,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(kCircularRadius),
                  boxShadow: const [
                    BoxShadow(
                        color: AppColor.saasifyLightPaleGrey, blurRadius: 5.0)
                  ],
                  color: AppColor.saasifyWhite),
              child: Padding(
                  padding: const EdgeInsets.all(kCircularRadius),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                                productCategory[index]
                                        .categoryName
                                        .trim()
                                        .substring(0, 1)
                                        .toUpperCase() +
                                    productCategory[index]
                                        .categoryName
                                        .trim()
                                        .substring(
                                          1,
                                        )
                                        .toLowerCase(),
                                style: Theme.of(context)
                                    .textTheme
                                    .tiniest
                                    .copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: AppColor.saasifyDarkGrey)),
                            const SizedBox(height: spacingXSmall),
                            Text(
                              '12% GST',
                              style: Theme.of(context).textTheme.xxTiniest,
                            ),
                            const SizedBox(height: spacingXXSmall),
                            Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 8),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: AppColor.saasifyLighterGreen),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.circle,
                                        size: 8, color: AppColor.saasifyGreen),
                                    const SizedBox(width: 6),
                                    Text('GST Enabled',
                                        style: Theme.of(context)
                                            .textTheme
                                            .xxTiniest
                                            .copyWith(
                                                color: AppColor.saasifyGreen)),
                                  ],
                                ))
                          ],
                        ),
                        Row(children: [
                          CategoryToggleWidget(
                              productCategory: productCategory[index]),
                          SizedBox(
                              width: (productCategory[index].categoryName !=
                                      'uncategorized')
                                  ? spacingXSmall
                                  : spacingXXLarge),
                          Visibility(
                            visible: productCategory[index].categoryName !=
                                'uncategorized',
                            child: CategoriesPopUpMenuWidget(
                                productCategory: productCategory[index]),
                          )
                        ])
                      ])));
        },
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 4,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20));
  }
}
