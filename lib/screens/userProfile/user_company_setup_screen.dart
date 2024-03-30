import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saasify/bloc/companies/companies_bloc.dart';
import 'package:saasify/bloc/companies/companies_event.dart';
import 'package:saasify/bloc/companies/companies_state.dart';
import 'package:saasify/bloc/imagePicker/image_picker_bloc.dart';
import 'package:saasify/screens/home/home_screen.dart';
import 'package:saasify/screens/widgets/custom_dialogs.dart';
import 'package:saasify/utils/progress_bar.dart';
import 'package:saasify/utils/responsive_form.dart';
import '../../../configs/app_spacing.dart';
import '../widgets/label_and_textfield_widget.dart';
import '../widgets/skeleton_screen.dart';
import '../widgets/buttons/primary_button.dart';
import '../widgets/image_picker_widget.dart';

class UserCompanySetupScreen extends StatefulWidget {
  const UserCompanySetupScreen({super.key});

  @override
  UserCompanySetupScreenState createState() => UserCompanySetupScreenState();
}

class UserCompanySetupScreenState extends State<UserCompanySetupScreen> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController ownerNameController = TextEditingController();
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController identificationNumberController =
      TextEditingController();
  final TextEditingController addressController = TextEditingController();
  String _imagePath = '';

  @override
  Widget build(BuildContext context) {
    context.read<ImagePickerBloc>().imagePath = '';
    return SkeletonScreen(
      appBarTitle: 'Add Company',
      bodyContent: SingleChildScrollView(
        child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ImagePickerWidget(
                    label: 'Company Logo',
                    initialImage: _imagePath,
                    onImagePicked: (String imagePath) {
                      _imagePath = imagePath;
                    }),
                const SizedBox(height: spacingLarge),
                ResponsiveForm(formWidgets: [
                  LabelAndTextFieldWidget(
                    prefixIcon: const Icon(Icons.business),
                    label: 'Company Name',
                    isRequired: true,
                    textFieldController: companyNameController,
                    // onTextFieldChanged: onTextFieldChanged,
                  ),
                  LabelAndTextFieldWidget(
                    prefixIcon: const Icon(Icons.numbers_outlined),
                    label: 'EIN / TIN / GST Number',
                    isRequired: false,
                    textFieldController: identificationNumberController,
                    // onTextFieldChanged: onTextFieldChanged,
                  ),
                  LabelAndTextFieldWidget(
                    prefixIcon: const Icon(Icons.location_city),
                    label: 'Address',
                    isRequired: false,
                    textFieldController: addressController,
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
      BlocListener<CompaniesBloc, CompaniesState>(
        listener: (context, state) {
          if (state is AddingCompany) {
            ProgressBar.show(context);
          } else if (state is CompanyAdded) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const HomeScreen()));
          } else if (state is CompanyNotAdded) {
            ProgressBar.dismiss(context);
            showDialog(
                context: context,
                builder: (context) {
                  return CustomDialogs().showAlertDialog(context,
                      'Something went wrong, could not register the company!',
                      onPressed: () => Navigator.pop(context));
                });
          }
        },
        child: PrimaryButton(
          buttonTitle: 'Save Profile Details',
          onPressed: () async {
            if (formKey.currentState!.validate()) {
              context.read<CompaniesBloc>().add(AddCompany(companyDetailsMap: {
                    'company_name': companyNameController.text,
                    'einNumber': identificationNumberController.text,
                    'address': addressController.text,
                    'logoUrl': _imagePath
                  }));
            }
          },
        ),
      ),
    ];
  }
}
