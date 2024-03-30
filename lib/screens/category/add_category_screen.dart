import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saasify/bloc/category/category_bloc.dart';
import 'package:saasify/bloc/category/category_event.dart';
import 'package:saasify/bloc/category/category_state.dart';
import 'package:saasify/bloc/imagePicker/image_picker_bloc.dart';
import 'package:saasify/screens/home/home_screen.dart';
import 'package:saasify/screens/widgets/custom_dialogs.dart';
import 'package:saasify/utils/progress_bar.dart';
import 'package:saasify/utils/responsive_form.dart';
import '../../configs/app_spacing.dart';
import '../widgets/buttons/primary_button.dart';
import '../widgets/skeleton_screen.dart';
import '../widgets/image_picker_widget.dart';
import '../widgets/label_and_textfield_widget.dart';

class AddCategoryScreen extends StatelessWidget {
  AddCategoryScreen({super.key});

  final TextEditingController textEditingController = TextEditingController();
  final Map categoryMap = {};
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    textEditingController.text = '';
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
                  initialImage: categoryMap['image'] ?? '',
                  onImagePicked: (String imagePath) {
                    categoryMap['image'] = imagePath;
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
                    textFieldController: textEditingController,
                  )
                ])
              ],
            ),
          ),
        ),
        bottomBarButtons: [
          BlocListener<CategoryBloc, CategoryState>(
              listener: (context, state) {
                if (state is AddingCategory) {
                  ProgressBar.show(context);
                } else if (state is CategoryAdded) {
                  ProgressBar.dismiss(context);
                  showDialog(
                      context: context,
                      builder: (context) {
                        return CustomDialogs().showSuccessDialog(
                            context, state.successMessage, onPressed: () {
                          Navigator.pop(context);
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomeScreen()));
                        });
                      });
                } else if (state is CategoryNotAdded) {
                  ProgressBar.dismiss(context);
                  showDialog(
                      context: context,
                      builder: (context) {
                        return CustomDialogs().showAlertDialog(
                            context, state.errorMessage,
                            onPressed: () => Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const HomeScreen())));
                      });
                }
              },
              child: PrimaryButton(
                  buttonTitle: 'Add Category',
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      categoryMap['category_name'] = textEditingController.text;
                      context
                          .read<CategoryBloc>()
                          .add(AddCategory(addCategoryMap: categoryMap));
                    }
                  }))
        ]);
  }
}
