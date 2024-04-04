import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saasify/bloc/imagePicker/image_picker_bloc.dart';
import 'package:saasify/models/category/product_categories.dart';
import 'package:saasify/screens/category/widgets/add_category_button.dart';
import 'package:saasify/services/service_locator.dart';
import 'package:saasify/utils/responsive_form.dart';
import '../../configs/app_spacing.dart';
import '../widgets/skeleton_screen.dart';
import '../widgets/image_picker_widget.dart';
import '../widgets/label_and_textfield_widget.dart';

class AddCategoryScreen extends StatelessWidget {
  AddCategoryScreen({super.key});

  final formKey = GlobalKey<FormState>();
  static ProductCategories productCategories = getIt<ProductCategories>();

  @override
  Widget build(BuildContext context) {
    context.read<ImagePickerBloc>().imagePath = '';
    return SkeletonScreen(
        appBarTitle: 'Add Category',
        bodyContent: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ImagePickerWidget(
                  label: 'Category Display Image',
                  initialImage: '',
                  onImagePicked: (String imagePath) {
                    productCategories.imagePath = imagePath;
                  },
                ),
                const SizedBox(height: spacingHuge),
                ResponsiveForm(formWidgets: [
                  LabelAndTextFieldWidget(
                    prefixIcon: const Icon(Icons.category),
                    label: 'Category Name',
                    isRequired: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field is required';
                      }
                      return null;
                    },
                    onTextFieldChanged: (String? value) {
                      productCategories.name = value!;
                    },
                  )
                ])
              ],
            ),
          ),
        ),
        bottomBarButtons: [AddCategoryButton(formKey: formKey)]);
  }
}
