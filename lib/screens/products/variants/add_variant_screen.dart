import 'dart:io';

import 'package:flutter/material.dart';
import 'package:saasify/configs/app_theme.dart';
import 'package:saasify/screens/widgets/buttons/primary_button.dart';

import '../../../configs/app_colors.dart';
import '../../../configs/app_dimensions.dart';
import '../../../configs/app_spacing.dart';
import '../../../enums/product_by_quantity_enum.dart';
import '../../../models/product/product_model.dart';
import '../../widgets/label_and_textfield_widget.dart';
import '../../widgets/label_dropdown_widget.dart';
import '../../widgets/skeleton_screen.dart';

class AddVariantScreen extends StatefulWidget {
  final ProductsModel productsModel;

  const AddVariantScreen({super.key, required this.productsModel});

  @override
  State<AddVariantScreen> createState() => _AddVariantScreenState();
}

class _AddVariantScreenState extends State<AddVariantScreen> {
  @override
  void initState() {
    // TODO: implement initState
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
                              onTextFieldChanged: (String? value) {})
                          : const SizedBox(),
                      const SizedBox(height: spacingSmall),
                      (widget.productsModel.soldBy == 'Each')
                          ? LabelAndTextFieldWidget(
                              prefixIcon: const Icon(Icons.ac_unit),
                              label: 'Quantity',
                              keyboardType: TextInputType.number,
                              onTextFieldChanged: (String? value) {})
                          : LabelDropdownWidget<ProductByQuantityEnum>(
                              label: 'Select Quantity',
                              initialValue: ProductByQuantityEnum.kg,
                              items: ProductByQuantityEnum.values
                                  .map((byQuantity) {
                                return DropdownMenuItem<ProductByQuantityEnum>(
                                  value: byQuantity,
                                  child: Text("${byQuantity.name} "),
                                );
                              }).toList(),
                              onChanged: (ProductByQuantityEnum? newValue) {
                                setState(() {});
                              },
                            ),
                      const SizedBox(height: spacingSmall),
                      LabelAndTextFieldWidget(
                          prefixIcon: const Icon(Icons.price_change_rounded),
                          label: 'Price',
                          isRequired: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'This field is required';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.number,
                          onTextFieldChanged: (String? value) {}),
                      const SizedBox(height: spacingSmall),
                      LabelAndTextFieldWidget(
                          prefixIcon: const Icon(Icons.local_shipping),
                          label: 'Minimum Stock Level',
                          keyboardType: TextInputType.number,
                          onTextFieldChanged: (String? value) {
                            //   products.minStockLevel = int.parse(value ?? '0');
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
        PrimaryButton(onPressed: () {}, buttonTitle: 'Add Variant')
      ],
    );
  }
}
