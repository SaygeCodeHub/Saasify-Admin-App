import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saasify/bloc/category/category_bloc.dart';
import 'package:saasify/configs/app_spacing.dart';
import 'package:saasify/configs/app_theme.dart';
import 'package:saasify/models/category/product_categories.dart';
import 'package:saasify/screens/widgets/image_picker_widget.dart';
import 'package:saasify/screens/widgets/label_and_textfield_widget.dart';
import 'package:saasify/utils/responsive_form.dart';

class AddProductSection extends StatefulWidget {
  final List<ProductCategories> categories;
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final TextEditingController supplierController;
  final TextEditingController taxController;
  final TextEditingController minStockLevelController;
  final TextEditingController priceController;
  final TextEditingController quantityController;
  final Map soldByMap;
  static String image = '';

  const AddProductSection(
      {super.key,
      required this.categories,
      required this.nameController,
      required this.descriptionController,
      required this.supplierController,
      required this.taxController,
      required this.minStockLevelController,
      required this.priceController,
      required this.quantityController,
      required this.soldByMap});

  @override
  State<AddProductSection> createState() => _AddProductSectionState();
}

class _AddProductSectionState extends State<AddProductSection> {
  final soldByList = ['Each', 'Quantity'];
  final quantity = ['kg', 'ltr', 'gm'];

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SizedBox(height: spacingStandard),
      ImagePickerWidget(
          onImagePicked: (String imagePath) {
            AddProductSection.image = imagePath;
          },
          label: 'Product display image'),
      const SizedBox(height: spacingStandard),
      Text('Category', style: Theme.of(context).textTheme.fieldLabelTextStyle),
      const SizedBox(height: spacingSmall),
      ResponsiveForm(formWidgets: [
        DropdownButtonHideUnderline(
          child: DropdownButtonFormField<String>(
            value: context.read<CategoryBloc>().selectedCategory,
            hint: const Text("Select an item"),
            items: widget.categories.map((category) {
              return DropdownMenuItem<String>(
                value: category.categoryId,
                child: Text(category.name),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                context.read<CategoryBloc>().selectedCategory = newValue!;
              });
            },
          ),
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
          textFieldController: widget.nameController,
        ),
        LabelAndTextFieldWidget(
          prefixIcon: const Icon(Icons.description),
          label: 'Description',
          textFieldController: widget.descriptionController,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Sold by',
                style: Theme.of(context).textTheme.fieldLabelTextStyle),
            const SizedBox(height: spacingSmall),
            DropdownButtonHideUnderline(
              child: DropdownButtonFormField<String>(
                value: widget.soldByMap['selected_value'],
                hint: const Text("Select an item"),
                items: soldByList.map((soldBy) {
                  return DropdownMenuItem<String>(
                    value: soldBy.toString(),
                    child: Text(soldBy.toString()),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    widget.soldByMap['selected_value'] = newValue!;
                  });
                },
              ),
            ),
          ],
        ),
        if (widget.soldByMap['selected_value'] == 'Each')
          LabelAndTextFieldWidget(
              prefixIcon: const Icon(Icons.ad_units_outlined),
              label: 'Quantity',
              keyboardType: TextInputType.number,
              textFieldController: widget.quantityController),
        if (widget.soldByMap['selected_value'] == 'Quantity')
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Select Quantity',
                  style: Theme.of(context).textTheme.fieldLabelTextStyle),
              const SizedBox(height: spacingSmall),
              DropdownButtonHideUnderline(
                child: DropdownButtonFormField<String>(
                  value: widget.soldByMap['selected_quantity'],
                  hint: const Text("Select an item"),
                  items: quantity.map((soldBy) {
                    return DropdownMenuItem<String>(
                      value: soldBy.toString(),
                      child: Text(soldBy.toString()),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      widget.soldByMap['selected_quantity'] = newValue!;
                    });
                  },
                ),
              ),
            ],
          ),
        if (widget.soldByMap['selected_value'] == 'Quantity')
          LabelAndTextFieldWidget(
              prefixIcon: const Icon(Icons.ad_units_outlined),
              label: 'Quantity',
              keyboardType: TextInputType.number,
              textFieldController: widget.quantityController),
        LabelAndTextFieldWidget(
            prefixIcon: const Icon(Icons.price_change_rounded),
            label: 'Price',
            keyboardType: TextInputType.number,
            textFieldController: widget.priceController),
        LabelAndTextFieldWidget(
          prefixIcon: const Icon(Icons.supervisor_account),
          label: 'Supplier',
          textFieldController: widget.supplierController,
        ),
        if (widget.soldByMap['selected_quantity'] == 'None')
          LabelAndTextFieldWidget(
              prefixIcon: const Icon(Icons.ad_units_outlined),
              label: 'Tax',
              keyboardType: TextInputType.number,
              textFieldController: widget.taxController),
        LabelAndTextFieldWidget(
          prefixIcon: const Icon(Icons.local_shipping),
          label: 'Minimum Stock Level',
          keyboardType: TextInputType.number,
          textFieldController: widget.minStockLevelController,
        )
      ])
    ]);
  }
}
