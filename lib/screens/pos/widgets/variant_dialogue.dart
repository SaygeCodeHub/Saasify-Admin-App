import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saasify/bloc/pos/billing_bloc.dart';
import 'package:saasify/bloc/pos/billing_event.dart';
import 'package:saasify/configs/app_color.dart';
import 'package:saasify/configs/app_spacing.dart';
import 'package:saasify/data/models/billing/fetch_products_by_category_model.dart';

class VariantDialogue extends StatelessWidget {
  final Product product;
  final List<CategoryWithProductsDatum> productsByCategories;

  const VariantDialogue({
    super.key,
    required this.product,
    required this.productsByCategories,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.all(spacingStandard),
        content: SizedBox(
            height: 450,
            width: 370,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.close))
              ]),
              const Text('Select Variants'),
              const SizedBox(height: spacingStandard),
              Expanded(
                  child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: GridView.builder(
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2, childAspectRatio: 1.2),
                          itemCount: product.variants.length,
                          itemBuilder: (context, index) {
                            return Padding(
                                padding: const EdgeInsets.all(spacingStandard),
                                child: InkWell(
                                    onTap: () {
                                      context
                                          .read<BillingBloc>()
                                          .add(SelectProduct(
                                            product: product,
                                            productsByCategories:
                                                productsByCategories,
                                            variantIndex: index,
                                          ));
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                        decoration: BoxDecoration(
                                            color:
                                                AppColor.saasifyLightDeepBlue,
                                            borderRadius: BorderRadius.circular(
                                                spacingStandard)),
                                        child: Center(
                                            child: Padding(
                                                padding: const EdgeInsets.all(
                                                    spacingMedium),
                                                child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                          product
                                                              .variants[index]
                                                              .stock
                                                              .toString(),
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: const TextStyle(
                                                              color: AppColor
                                                                  .saasifyWhite)),
                                                      const SizedBox(
                                                          height: spacingSmall),
                                                      Text(
                                                          '₹${product.variants[index].cost.toString()}',
                                                          style: const TextStyle(
                                                              color: AppColor
                                                                  .saasifyWhite))
                                                    ]))))));
                          })))
            ])));
  }
}
