import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saasify/bloc/product/product_bloc.dart';
import 'package:saasify/bloc/product/product_state.dart';
import 'package:saasify/configs/app_theme.dart';
import 'package:saasify/models/product/product_variant.dart';
import 'package:saasify/screens/products/view_all_products_screen.dart';
import 'package:saasify/utils/progress_bar.dart';

import '../../../configs/app_colors.dart';
import '../../../configs/app_dimensions.dart';
import '../../../configs/app_spacing.dart';
import '../../../enums/product_by_quantity_enum.dart';
import '../../../models/product/product_model.dart';
import '../../../services/service_locator.dart';
import '../../widgets/label_and_textfield_widget.dart';
import '../../widgets/label_dropdown_widget.dart';
import '../../widgets/skeleton_screen.dart';
import 'add_variant_button.dart';

class AddVariantScreen extends StatefulWidget {
  final ProductsModel productsModel;

  const AddVariantScreen({super.key, required this.productsModel});

  @override
  State<AddVariantScreen> createState() => _AddVariantScreenState();
}

class _AddVariantScreenState extends State<AddVariantScreen> {
  ProductVariant productVariant = getIt<ProductVariant>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SkeletonScreen(
      appBarTitle: 'Add Variant',
      bodyContent: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
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
                          FileImage(File(widget.productsModel.localImagePath!)),
                      onBackgroundImageError: (_, __) =>
                          const AssetImage('assets/no_image.jpeg'),
                    ),
                  ),
                ),
                const SizedBox(height: spacingStandard),
                Text(widget.productsModel.name!,
                    style: Theme.of(context)
                        .textTheme
                        .labelTextStyle
                        .copyWith(fontWeight: FontWeight.w700, fontSize: 16)),
                const SizedBox(height: spacingXSmall),
                Text(widget.productsModel.description ??
                    'No description provided.'),
                const SizedBox(height: spacingXSmall),
                const Divider(),
                const SizedBox(height: spacingXSmall),
                Form(
                  child: Column(
                    children: [
                      (widget.productsModel.soldBy == 'Each')
                          ? LabelAndTextFieldWidget(
                              prefixIcon:
                                  const Icon(Icons.price_change_rounded),
                              label: 'Variant Name',
                              isRequired: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'This field is required';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.text,
                              onTextFieldChanged: (String? value) {
                                productVariant.variantName = value!;
                              })
                          : const SizedBox(),
                      const SizedBox(height: spacingSmall),
                      (widget.productsModel.soldBy == 'Each')
                          ? LabelAndTextFieldWidget(
                              prefixIcon: const Icon(Icons.ac_unit),
                              label: 'Quantity',
                              keyboardType: TextInputType.number,
                              onTextFieldChanged: (String? value) {
                                productVariant.quantity =
                                    int.tryParse(value ?? '0');
                              })
                          : LabelDropdownWidget<ProductByQuantityEnum>(
                              label: 'Select Weight',
                              initialValue: ProductByQuantityEnum.kg,
                              items: ProductByQuantityEnum.values
                                  .map((byQuantity) {
                                return DropdownMenuItem<ProductByQuantityEnum>(
                                  value: byQuantity,
                                  child: Text("${byQuantity.name} "),
                                );
                              }).toList(),
                              onChanged: (ProductByQuantityEnum? newValue) {
                                setState(() {
                                  productVariant.weight = newValue!.quantity;
                                });
                              },
                            ),
                      const SizedBox(height: spacingSmall),
                      LabelAndTextFieldWidget(
                          prefixIcon: const Icon(Icons.price_change_rounded),
                          label: 'Selling Price',
                          isRequired: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'This field is required';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.number,
                          onTextFieldChanged: (String? value) {
                            productVariant.sellingPrice =
                                double.parse(value ?? '0');
                          }),
                      const SizedBox(height: spacingSmall),
                      LabelAndTextFieldWidget(
                          prefixIcon: const Icon(Icons.price_change_rounded),
                          label: 'Purchase Price',
                          isRequired: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'This field is required';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.number,
                          onTextFieldChanged: (String? value) {
                            productVariant.purchasePrice =
                                double.parse(value ?? '0.00');
                          }),
                      const SizedBox(height: spacingSmall),
                      LabelAndTextFieldWidget(
                          prefixIcon: const Icon(Icons.local_shipping),
                          label: 'Minimum Stock Level',
                          keyboardType: TextInputType.number,
                          onTextFieldChanged: (String? value) {
                            productVariant.minStockLevel = int.tryParse(value!);
                          })
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
      bottomBarButtons: [
        BlocListener<ProductBloc, ProductState>(
            listener: (context, state) {
              if (state is AddingVariant) {
                ProgressBar.show(context);
              }
              if (state is VariantAdded) {
                ProgressBar.dismiss(context);
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ViewAllProductsScreen()));
              }
              if (state is VariantNotAdded) {
                ProgressBar.dismiss(context);
              }
            },
            child: AddVariantButton(productsModel: widget.productsModel))
      ],
    );
  }
}
