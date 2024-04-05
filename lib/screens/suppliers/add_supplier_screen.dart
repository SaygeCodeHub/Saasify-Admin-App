import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saasify/bloc/suppliers/supplier_bloc.dart';
import 'package:saasify/bloc/suppliers/supplier_event.dart';
import 'package:saasify/bloc/suppliers/supplier_state.dart';
import 'package:saasify/models/supplier/add_supplier_model.dart';
import 'package:saasify/screens/home/home_screen.dart';
import 'package:saasify/screens/widgets/custom_dialogs.dart';
import 'package:saasify/utils/progress_bar.dart';
import 'package:saasify/utils/responsive_form.dart';
import '../../../configs/app_spacing.dart';
import '../widgets/label_and_textfield_widget.dart';
import '../widgets/skeleton_screen.dart';
import '../widgets/buttons/primary_button.dart';

class AddSupplierScreen extends StatelessWidget {
  final formKey = GlobalKey<FormState>();

  AddSupplierScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SkeletonScreen(
      appBarTitle: 'Add Supplier',
      bodyContent: SingleChildScrollView(
        child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: spacingLarge),
                ResponsiveForm(formWidgets: [
                  LabelAndTextFieldWidget(
                      prefixIcon: const Icon(Icons.person),
                      label: 'Supplier Name',
                      isRequired: true,
                      onTextFieldChanged: (String? value) {
                        context.read<SupplierBloc>().addSupplierMap['name'] =
                            value;
                      }),
                  LabelAndTextFieldWidget(
                      prefixIcon: const Icon(Icons.email),
                      label: 'Email Address',
                      isRequired: false,
                      onTextFieldChanged: (String? value) {
                        context.read<SupplierBloc>().addSupplierMap['email'] =
                            value;
                      }),
                  LabelAndTextFieldWidget(
                      prefixIcon: const Icon(Icons.call),
                      label: 'Mobile Number',
                      isRequired: true,
                      onTextFieldChanged: (String? value) {
                        context.read<SupplierBloc>().addSupplierMap['contact'] =
                            value;
                      }),
                ])
              ],
            )),
      ),
      bottomBarButtons: _buildBottomBarButtons(context),
    );
  }

  List<Widget> _buildBottomBarButtons(BuildContext context) {
    return [
      BlocListener<SupplierBloc, SupplierState>(
        listener: (context, state) {
          if (state is AddingSupplier) {
            ProgressBar.show(context);
          } else if (state is SupplierAdded) {
            showDialog(
                context: context,
                builder: (context) {
                  return CustomDialogs().showSuccessDialog(
                      context, state.successMessage,
                      onPressed: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomeScreen())));
                });
          } else if (state is CouldNotAddSupplier) {
            ProgressBar.dismiss(context);
            showDialog(
                context: context,
                builder: (context) {
                  return CustomDialogs().showAlertDialog(
                      context, state.errorMessage,
                      onPressed: () => Navigator.pop(context));
                });
          }
        },
        child: PrimaryButton(
          buttonTitle: 'Add Supplier',
          onPressed: () async {
            if (formKey.currentState!.validate()) {
              context.read<SupplierBloc>().add(AddSupplier(
                  addSupplierModel: AddSupplierModel(
                      name: context.read<SupplierBloc>().addSupplierMap['name'],
                      email: context
                              .read<SupplierBloc>()
                              .addSupplierMap['email'] ??
                          '',
                      contact: context
                              .read<SupplierBloc>()
                              .addSupplierMap['contact'] ??
                          '')));
            }
          },
        ),
      ),
    ];
  }
}
