import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saasify/bloc/category/category_bloc.dart';
import 'package:saasify/configs/app_spacing.dart';
import 'package:saasify/configs/app_theme.dart';
import 'package:saasify/models/category/product_categories.dart';
import 'package:saasify/screens/widgets/image_picker_widget.dart';
import 'package:saasify/screens/widgets/label_and_textfield_widget.dart';
import 'package:saasify/utils/responsive_form.dart';

class AddProductSection extends StatelessWidget {
  final List<ProductCategories> categories;
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final TextEditingController supplierController;
  final TextEditingController taxController;
  final TextEditingController minStockLevelController;

  const AddProductSection(
      {super.key,
      required this.categories,
      required this.nameController,
      required this.descriptionController,
      required this.supplierController,
      required this.taxController,
      required this.minStockLevelController});

  static String image = '';

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SizedBox(height: spacingStandard),
      ImagePickerWidget(
          onImagePicked: (String imagePath) {
            image = imagePath;
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
            items: categories.map((category) {
              return DropdownMenuItem<String>(
                value: category.categoryId,
                child: Text(category.name),
              );
            }).toList(),
            onChanged: (String? newValue) {
              context.read<CategoryBloc>().selectedCategory = newValue!;
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
          textFieldController: nameController,
        ),
        LabelAndTextFieldWidget(
          prefixIcon: const Icon(Icons.description),
          label: 'Description',
          textFieldController: descriptionController,
        ),
        LabelAndTextFieldWidget(
          prefixIcon: const Icon(Icons.supervisor_account),
          label: 'Supplier',
          textFieldController: supplierController,
        ),
        LabelAndTextFieldWidget(
            prefixIcon: const Icon(Icons.attach_money),
            label: 'Tax',
            keyboardType: TextInputType.number,
            textFieldController: taxController),
        LabelAndTextFieldWidget(
          prefixIcon: const Icon(Icons.local_shipping),
          label: 'Minimum Stock Level',
          keyboardType: TextInputType.number,
          textFieldController: minStockLevelController,
        )
      ])
    ]);
  }
}
