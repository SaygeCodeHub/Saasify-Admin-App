import 'package:flutter/material.dart';
import 'package:saasify/configs/app_spacing.dart';
import 'package:saasify/configs/app_theme.dart';

import '../../configs/app_colors.dart';
import '../../utils/global.dart';

class POSGridPopupScreen extends StatefulWidget {
  final String screenTitle;
  final List<dynamic> items;

  const POSGridPopupScreen(
      {super.key, required this.items, required this.screenTitle});

  @override
  State<POSGridPopupScreen> createState() => _POSGridPopupScreenState();
}

class _POSGridPopupScreenState extends State<POSGridPopupScreen> {
  Map<String, int> cartItems = {};

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(widget.screenTitle),
          IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.close))
        ],
      ),
      content: SizedBox(
          width: MediaQuery.sizeOf(context).width * 0.50,
          height: MediaQuery.sizeOf(context).width * 0.85,
          child: ListView.separated(
              shrinkWrap: true,
              itemCount: widget.items.length,
              separatorBuilder: (context, index) {
                return const SizedBox(height: spacingSmall);
              },
              itemBuilder: (context, index) {
                final item = widget.items[index];
                int currentCount = cartItems[item.variantId] ?? 0;
                return ListTile(
                  visualDensity: VisualDensity.compact,
                  minVerticalPadding: 0.0,
                  onTap: () {
                    setState(() {
                      cartItems[item.variantId] = currentCount + 1;
                    });
                  },
                  tileColor: (currentCount > 0)
                      ? AppColors.honeydew
                      : AppColors.antiWhite,
                  title: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item.variantName,
                        style: Theme.of(context)
                            .textTheme
                            .labelTextStyle
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            if (cartItems.containsKey(item.variantId)) {
                              cartItems.remove(item.variantId);
                            }
                          });
                        },
                        child: const Text('Clear'),
                      )
                    ],
                  ),
                  subtitle: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '$currencySymbol ${item.sellingPrice.toString()}',
                            style: Theme.of(context)
                                .textTheme
                                .labelTextStyle
                                .copyWith(fontWeight: FontWeight.w400),
                          ),
                          const SizedBox(height: spacingXSmall),
                          Text(
                            'x $currentCount',
                            style: Theme.of(context)
                                .textTheme
                                .labelTextStyle
                                .copyWith(fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                      const SizedBox(height: spacingSmall)
                    ],
                  ),
                );
              })),
      actions: <Widget>[
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              onPressed: () {
                print('cart data ${cartItems}');
              },
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.shopping_cart, size: 16),
                  SizedBox(width: spacingSmall),
                  Text('Go to cart'),
                ],
              ),
            )),
      ],
    );
  }
}
