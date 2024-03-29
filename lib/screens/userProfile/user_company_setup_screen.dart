import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saasify/bloc/companies/companies_bloc.dart';
import 'package:saasify/bloc/companies/companies_event.dart';
import 'package:saasify/bloc/companies/companies_state.dart';
import 'package:saasify/bloc/imagePicker/image_picker_bloc.dart';
import 'package:saasify/screens/home/home_screen.dart';
import 'package:saasify/utils/custom_dialogs.dart';
import 'package:saasify/utils/progress_bar.dart';
import '../../../configs/app_spacing.dart';
import '../widgets/skeleton_screen.dart';
import '../widgets/buttons/primary_button.dart';
import '../widgets/form_widgets.dart';
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
          child: _buildFormBody(context),
        ),
      ),
      bottomBarButtons: _buildBottomBarButtons(context),
    );
  }

  Widget _buildFormBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        ImagePickerWidget(
            label: 'Company Logo',
            initialImage: _imagePath,
            onImagePicked: (String imagePath) {
              _imagePath = imagePath;
            }),
        const SizedBox(height: spacingHuge),
        buildTextField(
            companyNameController, 'Company Name', Icons.business, true),
        const SizedBox(height: spacingMedium),
        buildTextField(identificationNumberController, 'EIN / TIN / GST Number',
            Icons.numbers_outlined, false),
        const SizedBox(height: spacingMedium),
        buildTextField(addressController, 'Address', Icons.location_city, false,
            maxLines: 2),
      ],
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
                  return CustomDialogs().showAlertDialog(
                      context, 'Company not registered.',
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
