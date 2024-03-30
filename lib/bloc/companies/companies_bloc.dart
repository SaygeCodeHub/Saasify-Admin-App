import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:saasify/bloc/companies/companies_event.dart';
import 'package:saasify/bloc/companies/companies_state.dart';
import 'package:saasify/cache/cache.dart';
import 'package:saasify/models/user/user_details.dart';
import 'package:saasify/utils/global.dart';
import 'package:saasify/utils/retrieve_image_from_firebase.dart';

class CompaniesBloc extends Bloc<CompaniesEvent, CompaniesState> {
  CompaniesState get initialState => CompaniesInitial();

  CompaniesBloc() : super(CompaniesInitial()) {
    on<AddCompany>(_addCompany);
  }

  FutureOr<void> _addCompany(
      AddCompany event, Emitter<CompaniesState> emit) async {
    try {
      if (kIsOfflineModule) {
        final newCompany = UserDetails(
          ownerName: event.companyDetailsMap['owner_name'] ?? '',
          companyName: event.companyDetailsMap['company_name'] ?? '',
          identificationNumber: event.companyDetailsMap['einNumber'] ?? '',
          logo: event.companyDetailsMap['logoUrl'] ?? '',
          address: event.companyDetailsMap['address'] ?? '',
        );
        final companiesBox = Hive.box<UserDetails>('userDetails');
        await companiesBox.add(newCompany);
        emit(CompanyAdded());
      } else {
        emit(AddingCompany());
        FirebaseFirestore firestore = FirebaseFirestore.instance;
        User? user = FirebaseAuth.instance.currentUser;
        CollectionReference usersCollection = firestore.collection('users');
        DocumentReference userDocRef = usersCollection.doc(user?.uid);
        await userDocRef.collection('companies').add({
          'ownerUid': user?.uid,
          'ownerName': event.companyDetailsMap['owner_name'],
          'name': event.companyDetailsMap['company_name'],
          'einNumber': event.companyDetailsMap['einNumber'],
          'logoUrl': await RetrieveImageFromFirebase()
              .getImage(event.companyDetailsMap['logoUrl']),
          'address': event.companyDetailsMap['address'],
          'createdAt': FieldValue.serverTimestamp()
        });
        CollectionReference companiesRef = userDocRef.collection('companies');
        QuerySnapshot snapshot = await companiesRef.get();
        for (var doc in snapshot.docs) {
          await CustomerCache.setCompanyId(doc.id);
        }
        emit(CompanyAdded());
      }
    } catch (e) {
      emit(CompanyNotAdded(errorMessage: 'Cannot add company: $e'));
    }
  }
}
