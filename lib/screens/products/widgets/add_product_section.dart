import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saasify/bloc/category/category_bloc.dart';
import 'package:saasify/configs/app_dimensions.dart';
import 'package:saasify/configs/app_spacing.dart';
import 'package:saasify/configs/app_theme.dart';
import 'package:saasify/enums/product_sold_by_enum.dart';
import 'package:saasify/models/category/categories_model.dart';
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

  @override
  Widget build(BuildContext context) {
    products.soldBy = ProductSoldByEnum.each.soldBy;
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
        LabelAndTextFieldWidget(
            prefixIcon: const Icon(Icons.percent),
            label: 'Tax',
            keyboardType: TextInputType.number,
            onTextFieldChanged: (String? value) {
              products.tax = double.parse(value ?? '0.0');
            }),
        LabelAndTextFieldWidget(
            prefixIcon: const Icon(Icons.supervisor_account),
            label: 'Supplier',
            onTextFieldChanged: (String? value) {
              products.supplier = value;
            }),
      ])
    ]);
  }
}
