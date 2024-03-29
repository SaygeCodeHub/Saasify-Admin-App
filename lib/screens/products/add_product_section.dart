import 'package:flutter/material.dart';
import 'package:saasify/configs/app_spacing.dart';
import 'package:saasify/models/category/product_categories.dart';
import 'package:saasify/screens/widgets/image_picker_widget.dart';

class AddProductSection extends StatelessWidget {
  final List<ProductCategories> categories;

  const AddProductSection({super.key, required this.categories});

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
    ]);
  }
}
