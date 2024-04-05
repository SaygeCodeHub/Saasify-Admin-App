import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saasify/bloc/pos/pos_bloc.dart';
import 'package:saasify/bloc/pos/pos_event.dart';
import 'package:saasify/configs/app_colors.dart';
import 'package:saasify/configs/app_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:saasify/models/pos_model.dart';
import 'package:saasify/models/product/product_variant.dart';
import 'package:saasify/screens/products/product_details_screen.dart';

import '../../configs/app_spacing.dart';

class ProductCardWidget extends StatelessWidget {
  final bool isFromCart;
  final List<dynamic> list;
  static List<PosModel> posDataList = [];

  const ProductCardWidget(
      {super.key, required this.list, required this.isFromCart});

  @override
  Widget build(BuildContext context) {
    posDataList.clear();
    return Wrap(
      spacing: 20,
      runSpacing: 10.0,
      children: [
        for (int i = 0; i < list.length; i++)
          if (list[i].products != null)
            ...List<Widget>.generate(list[i].products.length, (index) {
              return InkWell(
                onTap: () {
                  if (isFromCart) {
                    Map dataForCartMap = {
                      'product_name': list[i].products[index].name,
                      'description': list[i].products[index].description,
                      'image': list[i].products[index].imageUrl
                    };
                    if (list[i].products[index].variants.isNotEmpty) {
                      _showGridDialog(context, list[i].products[index].variants,
                          dataForCartMap);
                    }
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProductDetailsScreen(
                                categoryId: list[i].categoryId,
                                productId: list[i].products[index].productId)));
                  }
                },
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
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
                            Flexible(
                              child: Text(list[i].products[index].name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .gridViewLabelTextStyle,
                                  textAlign: TextAlign.center),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: -35,
                      left: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        child: ClipOval(
                          child: CachedNetworkImage(
                            imageUrl:
                                list[i].products[index].imageUrl.toString(),
                            placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            })
      ],
    );
  }

  void _showGridDialog(
      BuildContext context, List<ProductVariant> variants, Map dataForCartMap) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            width: MediaQuery.sizeOf(context).width * 0.35,
            child: GridView.count(
              crossAxisCount: 4,
              children: List.generate(variants.length, (variantIndex) {
                return InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    bool found = false;
                    for (var item in posDataList) {
                      if (item.variantId == variants[variantIndex].variantId) {
                        item.count++;
                        item.cost = item.variantCost * item.count;
                        found = true;
                        break;
                      }
                    }
                    if (!found) {
                      posDataList.add(PosModel(
                          cost: variants[variantIndex].price!,
                          name: dataForCartMap['product_name'],
                          quantity: variants[variantIndex]
                              .quantityAvailable
                              .toString(),
                          count: 1,
                          variantCost: variants[variantIndex].price ?? 0.0,
                          variantId: variants[variantIndex].variantId ?? '',
                          description: dataForCartMap['description'],
                          image: dataForCartMap['image'] ?? ''));
                    }
                    context.read<PosBloc>().add(AddToCart(
                        posDataList: posDataList,
                        selectedVariantIndex: variantIndex));
                  },
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue[(variantIndex + 1) * 100],
                      borderRadius:
                          BorderRadius.circular(10), // Rounded corners
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          variants[variantIndex].quantityAvailable.toString(),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
                        ),
                        Text(
                          '₹ ${variants[variantIndex].price.toString()}',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        );
      },
    );
  }
}
