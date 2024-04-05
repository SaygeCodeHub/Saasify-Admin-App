import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:saasify/bloc/customers/customer_states.dart';
import 'package:saasify/models/customer/add_customer_model.dart';
import 'package:saasify/screens/home/home_screen.dart';
import 'package:saasify/screens/widgets/custom_dialogs.dart';
import 'package:saasify/utils/progress_bar.dart';
import 'package:saasify/utils/responsive_form.dart';
import '../../../configs/app_spacing.dart';
import '../../bloc/customers/customer_bloc.dart';
import '../../bloc/customers/customer_events.dart';
import '../widgets/date_picker.dart';
import '../widgets/label_and_textfield_widget.dart';
import '../widgets/skeleton_screen.dart';
import '../widgets/buttons/primary_button.dart';

class AddCustomerScreen extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  final TextEditingController dobController = TextEditingController();

  AddCustomerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SkeletonScreen(
      appBarTitle: 'Add Customer',
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
                    label: 'Customer Name',
                    isRequired: true,
                    onTextFieldChanged: (String? value) {
                      context.read<CustomerBloc>().addCustomerMap['name'] =
                          value!;
                    },
                  ),
                  CustomDatePickerWidget(
                      label: 'Date of Birth', dateController: dobController),
                  LabelAndTextFieldWidget(
                    prefixIcon: const Icon(Icons.email),
                    label: 'Email Address',
                    isRequired: false,
                    onTextFieldChanged: (String? value) {
                      context.read<CustomerBloc>().addCustomerMap['email'] =
                          value!;
                    },
                  ),
                  LabelAndTextFieldWidget(
                    prefixIcon: const Icon(Icons.call),
                    label: 'Mobile Number',
                    isRequired: true,
                    onTextFieldChanged: (String? value) {
                      context.read<CustomerBloc>().addCustomerMap['contact'] =
                          value!;
                    },
                  ),
                ])
              ],
            )),
      ),
      bottomBarButtons: _buildBottomBarButtons(context),
    );
  }

  List<Widget> _buildBottomBarButtons(BuildContext context) {
    return [
      BlocListener<CustomerBloc, CustomerState>(
        listener: (context, state) {
          if (state is CustomerAdding) {
            ProgressBar.show(context);
          } else if (state is CustomerAddedSuccessfully) {
            showDialog(
                context: context,
                builder: (context) {
                  return CustomDialogs().showSuccessDialog(
                      context, 'Customer added successfully!',
                      onPressed: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomeScreen())));
                });
          } else if (state is CustomerAddingError) {
            ProgressBar.dismiss(context);
            showDialog(
                context: context,
                builder: (context) {
                  return CustomDialogs().showAlertDialog(context,
                      'Something went wrong, could not add the customer!',
                      onPressed: () => Navigator.pop(context));
                });
          }
        },
        child: PrimaryButton(
          buttonTitle: 'Add Customer',
          onPressed: () async {
            if (formKey.currentState!.validate()) {
              final DateFormat formatter = DateFormat('dd/MM/yyyy');
              final DateTime dob = formatter.parseStrict(dobController.text);
              context.read<CustomerBloc>().add(AddCustomer(
                  customerModel: AddCustomerModel(
                      name: context.read<CustomerBloc>().addCustomerMap['name'],
                      email: context
                              .read<CustomerBloc>()
                              .addCustomerMap['email'] ??
                          '',
                      contact: context
                              .read<CustomerBloc>()
                              .addCustomerMap['contact'] ??
                          '',
                      dob: dob,
                      loyaltyPoints: 0)));
            }
          },
        ),
      ),
    ];
  }
}
