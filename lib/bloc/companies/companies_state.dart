abstract class CompaniesState {}

class CompaniesInitial extends CompaniesState {}

class AddingCompany extends CompaniesState {}

class CompanyAdded extends CompaniesState {}

class CompanyNotAdded extends CompaniesState {
  final String errorMessage;

  CompanyNotAdded({required this.errorMessage});
}
