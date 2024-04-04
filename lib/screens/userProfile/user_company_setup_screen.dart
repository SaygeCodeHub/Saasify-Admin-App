import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saasify/bloc/companies/companies_bloc.dart';
import 'package:saasify/screens/userProfile/widgets/save_company_button.dart';
import 'package:saasify/utils/responsive_form.dart';
import '../../../configs/app_spacing.dart';
import '../../enums/currency_enum.dart';
import '../../enums/industry_enum.dart';
import '../widgets/label_and_textfield_widget.dart';
import '../widgets/label_dropdown_widget.dart';
import '../widgets/skeleton_screen.dart';
import '../widgets/image_picker_widget.dart';

class UserCompanySetupScreen extends StatelessWidget {
  UserCompanySetupScreen({super.key});

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
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
                    initialImage: '',
                    onImagePicked: (String imagePath) {
                      context
                          .read<CompaniesBloc>()
                          .companyDetailsMap['logoUrl'] = imagePath;
                    }),
                const SizedBox(height: spacingLarge),
                ResponsiveForm(formWidgets: [
                  LabelDropdownWidget<Industry>(
                    label: 'Select Industry',
                    initialValue: Industry.foodAndBeverage,
                    items: Industry.values.map((industry) {
                      return DropdownMenuItem<Industry>(
                        value: industry,
                        child: Text("${industry.name} "),
                      );
                    }).toList(),
                    onChanged: (Industry? newValue) {
                      context
                          .read<CompaniesBloc>()
                          .companyDetailsMap['industryName'] = newValue!;
                    },
                  ),
                  LabelAndTextFieldWidget(
                    prefixIcon: const Icon(Icons.business),
                    label: 'Company Name',
                    isRequired: true,
                    onTextFieldChanged: (value) {
                      context
                          .read<CompaniesBloc>()
                          .companyDetailsMap['companyName'] = value!;
                    },
                  ),
                  LabelAndTextFieldWidget(
                    prefixIcon: const Icon(Icons.phone_android),
                    label: 'Contact number',
                    isRequired: true,
                    keyboardType: TextInputType.number,
                    onTextFieldChanged: (value) {
                      context
                          .read<CompaniesBloc>()
                          .companyDetailsMap['contactNumber'] = value!;
                    },
                  ),
                  LabelAndTextFieldWidget(
                    prefixIcon: const Icon(Icons.numbers_outlined),
                    label: 'EIN / TIN / GST Number',
                    isRequired: false,
                    onTextFieldChanged: (value) {
                      context
                          .read<CompaniesBloc>()
                          .companyDetailsMap['einNumber'] = value!;
                    },
                  ),
                  LabelAndTextFieldWidget(
                    prefixIcon: const Icon(Icons.credit_card_rounded),
                    label: 'Shop License Number',
                    isRequired: false,
                    onTextFieldChanged: (value) {
                      context
                          .read<CompaniesBloc>()
                          .companyDetailsMap['licenseNo'] = value!;
                    },
                  ),
                  LabelDropdownWidget<Currency>(
                    label: 'Currency',
                    initialValue: Currency.euro,
                    items: Currency.values.map((currency) {
                      return DropdownMenuItem<Currency>(
                        value: currency,
                        child: Text("${currency.symbol} - ${currency.name}"),
                      );
                    }).toList(),
                    onChanged: (Currency? newValue) {
                      context
                          .read<CompaniesBloc>()
                          .companyDetailsMap['currency'] = newValue!;
                    },
                  ),
                  LabelAndTextFieldWidget(
                    prefixIcon: const Icon(Icons.location_city),
                    label: 'Address',
                    isRequired: false,
                    onTextFieldChanged: (value) {
                      context
                          .read<CompaniesBloc>()
                          .companyDetailsMap['address'] = value!;
                    },
                  ),
                ])
              ],
            )),
      ),
      bottomBarButtons: [SaveCompanyButton(formKey: formKey)],
    );
  }
}
