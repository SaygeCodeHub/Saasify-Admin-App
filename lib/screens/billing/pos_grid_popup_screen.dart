import 'package:flutter/material.dart';
import 'package:saasify/configs/app_dimensions.dart';
import 'package:saasify/configs/app_spacing.dart';
import 'package:saasify/configs/app_theme.dart';

import '../../configs/app_colors.dart';
import '../../utils/global.dart';

class POSGridPopupScreen extends StatelessWidget {
  final String screenTitle;
  final List<dynamic> items;

  const POSGridPopupScreen(
      {super.key, required this.items, required this.screenTitle});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(child: Text(screenTitle)),
      content: SizedBox(
        width: MediaQuery.sizeOf(context).width * 0.50,
        height: MediaQuery.sizeOf(context).width * 0.85,
        child: GridView.count(
          crossAxisCount: 2,
          children: List.generate(items.length, (index) {
            final item = items[index];
            return Container(
              margin: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                  color: AppColors.ghostWhite,
                  borderRadius:
                      BorderRadius.circular(kProductCategoryCardRadius)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    item.variantName,
                    style: Theme.of(context)
                        .textTheme
                        .labelTextStyle
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: spacingXSmall),
                  Text(
                    '$currencySymbol ${item.sellingPrice.toString()}',
                    style: Theme.of(context)
                        .textTheme
                        .labelTextStyle
                        .copyWith(fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
      ],
    );
  }
}
