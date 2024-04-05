import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saasify/bloc/companies/companies_event.dart';
import 'package:saasify/bloc/companies/companies_state.dart';
import 'package:saasify/enums/firestore_collections_enum.dart';
import 'package:saasify/utils/global.dart';
import '../../cache/company_cache.dart';
import '../../models/companies/company.dart';
import '../../services/firebase_services.dart';
import '../../services/service_locator.dart';

class CompaniesBloc extends Bloc<CompaniesEvent, CompaniesState> {
  final firebaseServices = getIt<FirebaseServices>();
  final Map<dynamic, dynamic> companyDetailsMap = {};
  Company? company;
  CompaniesState get initialState => CompaniesInitial();

  CompaniesBloc() : super(CompaniesInitial()) {
    on<AddCompany>(_addCompany);
  }

  FutureOr<void> _addCompany(
      AddCompany event, Emitter<CompaniesState> emit) async {
    try {
      if (kIsOfflineModule) {
      } else {
        emit(AddingCompany());
        DocumentReference userDocRef = firebaseServices.usersRef;
        DocumentReference createdCompanyId = await userDocRef
            .collection(FirestoreCollection.companies.collectionName)
            .add(event.companyDetailsMap.toMap());
        if (createdCompanyId.id.isNotEmpty) {
          await saveToLocalCache(createdCompanyId.id, event);
          emit(CompanyAdded());
        } else {
          emit(CompanyNotAdded(errorMessage: 'Something went wrong'));
        }
      }
    } catch (e) {
      emit(CompanyNotAdded(errorMessage: 'Cannot add company: $e'));
    }
  }

  saveToLocalCache(String createdCompanyId, AddCompany event) async {
    await CompanyCache.setCompanyId(createdCompanyId);
    await CompanyCache.setUserAddress(event.companyDetailsMap.address!);
    await CompanyCache.setUserContact(event.companyDetailsMap.contactNumber);
    await CompanyCache.setCompanyGstNo(event.companyDetailsMap.einNumber!);
    await CompanyCache.setCompanyLicenseNo(event.companyDetailsMap.licenseNo!);
    await CompanyCache.setCurrency(event.companyDetailsMap.currency!);
    await CompanyCache.setIndustry(event.companyDetailsMap.industryName!);
    await CompanyCache.setCompanyLogoUrl(event.companyDetailsMap.logoUrl!);
  }
}
