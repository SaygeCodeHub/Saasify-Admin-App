import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saasify/bloc/category/category_bloc.dart';
import 'package:saasify/bloc/category/category_event.dart';
import 'package:saasify/bloc/category/category_state.dart';
import 'package:saasify/screens/home/home_screen.dart';
import 'package:saasify/screens/widgets/buttons/primary_button.dart';
import 'package:saasify/screens/widgets/custom_dialogs.dart';
import 'package:saasify/utils/progress_bar.dart';

import '../../../models/category/categories_model.dart';

class AddCategoryButton extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  const AddCategoryButton({super.key, required this.formKey});

  @override
  State<AddCategoryButton> createState() => _AddCategoryButtonState();
}

class _AddCategoryButtonState extends State<AddCategoryButton> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<CategoryBloc, CategoryState>(
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
                    Navigator.pushAndRemoveUntil<void>(
                        context,
                        MaterialPageRoute<void>(
                            builder: (BuildContext context) =>
                                const HomeScreen()),
                        (route) => false);
                  });
                });
          } else if (state is CategoryNotAdded) {
            showDialog(
                context: context,
                builder: (context) {
                  return CustomDialogs().showAlertDialog(
                      context, state.errorMessage, onPressed: () {
                    ProgressBar.dismiss(context);
                    Navigator.pop(context);
                  });
                });
          }
        },
        child: PrimaryButton(
            buttonTitle: 'Add Category',
            onPressed: () async {
              if (widget.formKey.currentState!.validate()) {
                CategoriesModel categoryInputData = CategoriesModel.fromMap(
                    context.read<CategoryBloc>().categoryInputData);
                context
                    .read<CategoryBloc>()
                    .add(AddCategory(categoriesModel: categoryInputData));
              }
            }));
  }
}
