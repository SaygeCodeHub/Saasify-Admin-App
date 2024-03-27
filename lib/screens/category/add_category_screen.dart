import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:saasify/bloc/category/category_bloc.dart';
import 'package:saasify/bloc/category/category_event.dart';
import 'package:saasify/bloc/category/category_state.dart';
import 'package:saasify/utils/custom_dialogs.dart';
import 'package:saasify/utils/global.dart';
import '../../configs/app_spacing.dart';
import '../../models/category/product_categories.dart';
import '../widgets/buttons/primary_button.dart';
import '../skeleton_screen.dart';
import '../widgets/image_picker_widget.dart';
import '../widgets/lable_and_textfield_widget.dart';

class AddCategoryScreen extends StatefulWidget {
  const AddCategoryScreen({super.key});

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final TextEditingController textEditingController = TextEditingController();
  Uint8List? _imageBytes;
  final Map categoryMap = {};

  void _handleImagePicked(Uint8List imageBytes) {
    setState(() {
      _imageBytes = imageBytes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SkeletonScreen(
        appBarTitle: 'Add Category',
        bodyContent: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ImagePickerWidget(
                label: 'Category Display Image',
                initialImage: _imageBytes,
                onImagePicked: _handleImagePicked,
              ),
              const SizedBox(height: spacingHuge),
              LabelAndTextFieldWidget(
                prefixIcon: const Icon(Icons.category),
                label: 'Category Name',
                isRequired: true,
                textFieldController: textEditingController,
              ),
            ],
          ),
        ),
        bottomBarButtons: [
          BlocListener<CategoryBloc, CategoryState>(
              listener: (context, state) {
                if (state is AddingCategory) {
                  const CircularProgressIndicator();
                } else if (state is CategoryAdded) {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return CustomDialogs().showSuccessDialog(
                            context, state.successMessage, onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        });
                      });
                } else if (state is CategoryNotAdded) {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return CustomDialogs().showSuccessDialog(
                            context, state.errorMessage,
                            onPressed: () => Navigator.pop(context));
                      });
                }
              },
              child: PrimaryButton(
                  buttonTitle: 'Add Category',
                  onPressed: () async {
                    if (offlineModule) {
                      final category = ProductCategories(
                          name: textEditingController.text,
                          imageBytes: _imageBytes);
                      final categoriesBox =
                          Hive.box<ProductCategories>('categories');
                      await categoriesBox.add(category).whenComplete(() {
                        Navigator.pop(context);
                      });
                    } else {
                      categoryMap['category_name'] = textEditingController.text;
                      categoryMap['image'] = _imageBytes;
                      context
                          .read<CategoryBloc>()
                          .add(AddCategory(addCategoryMap: categoryMap));
                    }
                  }))
        ]);
  }
}
