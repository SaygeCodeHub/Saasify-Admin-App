import 'package:saasify/bloc/companies/companies_bloc.dart';
import 'package:saasify/bloc/companies/companies_event.dart';
import 'package:saasify/bloc/companies/companies_state.dart';
import 'package:saasify/models/companies/company.dart';
import 'package:saasify/screens/home/home_screen.dart';
import 'package:saasify/screens/widgets/custom_dialogs.dart';
import 'package:saasify/utils/progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../widgets/buttons/primary_button.dart';

class SaveCompanyButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;

  const SaveCompanyButton({super.key, required this.formKey});

  @override
  Widget build(BuildContext context) {
    return BlocListener<CompaniesBloc, CompaniesState>(
      listener: (context, state) {
        print('SaveCompanyButton state == $state');
        if (state is AddingCompany) {
          ProgressBar.show(context);
        } else if (state is CompanyAdded) {
          ProgressBar.dismiss(context);
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
            var logoUrl = context
                .read<CompaniesBloc>()
                .companyDetailsMap['logoUrl']
                .toString();
            context.read<CompaniesBloc>().add(AddCompany(
                companyDetailsMap: Company(
                    companyName: context
                        .read<CompaniesBloc>()
                        .companyDetailsMap['companyName'],
                    contactNumber: context
                        .read<CompaniesBloc>()
                        .companyDetailsMap['contactNumber'],
                    currency: context
                        .read<CompaniesBloc>()
                        .companyDetailsMap['currency']
                        .toString(),
                    currencySymbol: context
                        .read<CompaniesBloc>()
                        .companyDetailsMap['currencySymbol']
                        .toString(),
                    logoUrl: logoUrl,
                    address: context
                        .read<CompaniesBloc>()
                        .companyDetailsMap['address'],
                    licenseNo: context
                        .read<CompaniesBloc>()
                        .companyDetailsMap['licenseNo'],
                    einNumber: context
                        .read<CompaniesBloc>()
                        .companyDetailsMap['einNumber'],
                    industryName: context
                        .read<CompaniesBloc>()
                        .companyDetailsMap['industryName']
                        .toString(),
                    createdAt: DateTime.now())));
          }
        },
      ),
    );
  }
}
