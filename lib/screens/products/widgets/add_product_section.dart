import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saasify/bloc/category/category_bloc.dart';
import 'package:saasify/configs/app_dimensions.dart';
import 'package:saasify/configs/app_spacing.dart';
import 'package:saasify/configs/app_theme.dart';
import 'package:saasify/enums/product_by_quantity_enum.dart';
import 'package:saasify/enums/product_sold_by_enum.dart';
import 'package:saasify/models/category/categories_model.dart';
import 'package:saasify/models/product/product_variant.dart';
import 'package:saasify/models/product/product_model.dart';
import 'package:saasify/screens/widgets/image_picker_widget.dart';
import 'package:saasify/screens/widgets/label_and_textfield_widget.dart';
import 'package:saasify/screens/widgets/label_dropdown_widget.dart';
import 'package:saasify/services/service_locator.dart';
import 'package:saasify/utils/responsive_form.dart';

class AddProductSection extends StatefulWidget {
  final List<CategoriesModel> categories;

  static String image = '';

  const AddProductSection({super.key, required this.categories});

  @override
  State<AddProductSection> createState() => _AddProductSectionState();
}

class _AddProductSectionState extends State<AddProductSection> {
  ProductsModel products = getIt<ProductsModel>();
  ProductVariant productVariant = getIt<ProductVariant>();

  @override
  Widget build(BuildContext context) {
    products.unit = '';
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SizedBox(height: spacingStandard),
      ImagePickerWidget(
          onImagePicked: (String imagePath) {
            products.localImagePath = imagePath;
          },
          label: 'Product Display Image'),
      const SizedBox(height: spacingHuge),
      ResponsiveForm(formWidgets: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Category',
                style: Theme.of(context).textTheme.fieldLabelTextStyle),
            const SizedBox(height: spacingSmall),
            DropdownButtonHideUnderline(
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: kLabelDropdownVerticalPadding,
                      horizontal: kLabelDropdownHorizontalPadding),
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(kLabelDropdownBorderRadius),
                  ),
                ),
                value: context.read<CategoryBloc>().selectedCategory,
                hint: const Text("Select an item"),
                items: widget.categories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category.categoryId,
                    child: Text(category.name!),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    products.categoryId = newValue!;
                  });
                },
              ),
            ),
          ],
        ),
        LabelAndTextFieldWidget(
          prefixIcon: const Icon(Icons.drive_file_rename_outline),
          label: 'Name',
          isRequired: true,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'This field is required';
            }
            return null;
          },
          onTextFieldChanged: (String? value) {
            products.name = value;
          },
        ),
        LabelAndTextFieldWidget(
            prefixIcon: const Icon(Icons.description),
            label: 'Description',
            maxLines: 5,
            onTextFieldChanged: (String? value) {
              products.description = value;
            }),
        LabelDropdownWidget<ProductSoldByEnum>(
          label: 'Sold By',
          initialValue: ProductSoldByEnum.each,
          items: ProductSoldByEnum.values.map((soldBy) {
            return DropdownMenuItem<ProductSoldByEnum>(
              value: soldBy,
              child: Text("${soldBy.name} "),
            );
          }).toList(),
          onChanged: (ProductSoldByEnum? newValue) {
            setState(() {
              products.soldBy = newValue?.soldBy;
            });
          },
        ),
        if (products.soldBy == 'Each')
          LabelAndTextFieldWidget(
            prefixIcon: const Icon(Icons.ad_units_outlined),
            label: 'Quantity',
            isRequired: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'This field is required';
              }
              return null;
            },
            keyboardType: TextInputType.number,
            onTextFieldChanged: (String? value) {
              productVariant.quantityAvailable = int.parse(value!);
            },
          ),
        if (products.soldBy == 'Quantity')
          LabelDropdownWidget<ProductByQuantityEnum>(
            label: 'Select Quantity',
            initialValue: ProductByQuantityEnum.kg,
            items: ProductByQuantityEnum.values.map((byQuantity) {
              return DropdownMenuItem<ProductByQuantityEnum>(
                value: byQuantity,
                child: Text("${byQuantity.name} "),
              );
            }).toList(),
            onChanged: (ProductByQuantityEnum? newValue) {
              setState(() {
                productVariant.quantityAvailable =
                    int.parse(newValue!.quantity);
              });
            },
          ),
        if (products.soldBy == 'Quantity')
          LabelAndTextFieldWidget(
              prefixIcon: const Icon(Icons.ad_units_outlined),
              label: 'Quantity',
              isRequired: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'This field is required';
                }
                return null;
              },
              keyboardType: TextInputType.number,
              onTextFieldChanged: (String? value) {
                productVariant.quantityAvailable = int.parse(value ?? '0');
              }),
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
            onTextFieldChanged: (String? value) {
              productVariant.price = double.parse(value ?? '0.0');
            }),
        LabelAndTextFieldWidget(
            prefixIcon: const Icon(Icons.supervisor_account),
            label: 'Supplier',
            onTextFieldChanged: (String? value) {
              products.supplier = value;
            }),
        if (products.soldBy == 'None')
          LabelAndTextFieldWidget(
              prefixIcon: const Icon(Icons.ad_units_outlined),
              label: 'Tax',
              keyboardType: TextInputType.number,
              onTextFieldChanged: (String? value) {
                products.tax = double.parse(value ?? '0.0');
              }),
        LabelAndTextFieldWidget(
            prefixIcon: const Icon(Icons.local_shipping),
            label: 'Minimum Stock Level',
            keyboardType: TextInputType.number,
            onTextFieldChanged: (String? value) {
              products.minStockLevel = int.parse(value ?? '0');
            })
      ])
    ]);
  }
}
