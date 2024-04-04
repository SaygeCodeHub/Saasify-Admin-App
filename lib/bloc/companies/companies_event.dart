import '../../models/companies/company.dart';

abstract class CompaniesEvent {}

class AddCompany extends CompaniesEvent {
  final Company companyDetailsMap;

  AddCompany({required this.companyDetailsMap});
}
