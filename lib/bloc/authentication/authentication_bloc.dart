import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saasify/bloc/authentication/authentication_event.dart';
import 'package:saasify/bloc/authentication/authentication_state.dart';
import 'package:saasify/cache/company_cache.dart';
import 'package:saasify/enums/firestore_collections_enum.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../cache/user_cache.dart';
import '../../enums/currency_enum.dart';
import '../../services/firebase_services.dart';
import '../../services/service_locator.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final FirebaseServices firebaseServices = getIt<FirebaseServices>();
  final SharedPreferences sharedPreferences = getIt<SharedPreferences>();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  AuthenticationBloc() : super(AuthenticationInitial()) {
    on<AuthenticateUser>(_authenticateUser);
    on<LogOutOfSession>(_logOutOfSession);
    on<CheckActiveSession>(_checkActiveSession);
  }

  Future<void> _checkActiveSession(
      CheckActiveSession event, Emitter<AuthenticationState> emit) async {
    bool isLoggedIn = await UserCache.getUserLoggedIn();
    if (isLoggedIn) {
      String? companyId = CompanyCache.getCompanyId();
      if (companyId != null && companyId.isNotEmpty) {
        emit(UserAuthenticated(userName: await UserCache.getUsername() ?? ''));
      } else {
        emit(UserAuthenticatedWithoutCompany());
      }
    } else {
      emit(InActiveSession());
    }
  }

  Future<void> _logOutOfSession(
      LogOutOfSession event, Emitter<AuthenticationState> emit) async {
    emit(LoggingOutOfSession());
    try {
      await FirebaseAuth.instance.signOut();
      await sharedPreferences.clear();
      emit(LoggedOutOfSession());
    } catch (error) {
      emit(LoggingOutFailed(
          errorMessage: 'Failed to log out: ${error.toString()}'));
    }
  }

  Future<void> _authenticateUser(
      AuthenticateUser event, Emitter<AuthenticationState> emit) async {
    emit(AuthenticatingUser());
    try {
      User? user;
      if (event.authenticationMap['is_sign_in'] == true) {
        user = await _signIn(event.authenticationMap['email'],
            event.authenticationMap['password']);
      } else {
        user = await _signUp(event.authenticationMap['email'],
            event.authenticationMap['password']);
      }

      if (user != null && user.uid.isNotEmpty) {
        await _updateUserData(user, event.authenticationMap);
        await _saveToLocalCache(user);

        if (await _checkUserCompanies(user.uid)) {
          emit(
              UserAuthenticated(userName: await UserCache.getUsername() ?? ''));
        } else {
          emit(UserAuthenticatedWithoutCompany());
        }
      } else {
        emit(UserNotAuthenticated(
            errorMessage: 'User not found after authentication.'));
      }
    } on FirebaseAuthException catch (e) {
      emit(UserNotAuthenticated(errorMessage: _handleFirebaseAuthError(e)));
    } catch (e) {
      emit(UserNotAuthenticated(
          errorMessage:
              'An unexpected error occurred. Please try again later.'));
    }
  }

  Future<bool> _checkUserCompanies(String userUid) async {
    final QuerySnapshot companiesSnapshot =
        await firebaseServices.getCompaniesCollectionRef().get();
    return companiesSnapshot.docs.isNotEmpty;
  }

  Future<User?> _signIn(String email, String password) async {
    final credential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    return credential.user;
  }

  Future<User?> _signUp(String email, String password) async {
    final credential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    return credential.user;
  }

  Future<void> _updateUserData(User user, Map<dynamic, dynamic> authMap) async {
    String userName = '';
    if (authMap['is_sign_in'] == true) {
      final userDocRef = firestore
          .collection(FirestoreCollection.users.collectionName)
          .doc(user.uid);
      final userDocSnapshot = await userDocRef.get();

      if (userDocSnapshot.exists) {
        userName = userDocSnapshot.get('name') ?? '';
      } else {
        userName = 'DefaultUserName';
      }
    }
    await firestore.collection('users').doc(user.uid).set({
      'name': authMap['name'] ?? userName,
      'email': authMap['email'],
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> _saveToLocalCache(User user) async {
    final DocumentSnapshot userDoc = await firestore
        .collection(FirestoreCollection.users.collectionName)
        .doc(user.uid)
        .get();
    String userName = userDoc.get('name') ?? '';

    final QuerySnapshot companyRef = await firestore
        .collection(FirestoreCollection.users.collectionName)
        .doc(user.uid)
        .collection(FirestoreCollection.companies.collectionName)
        .get();
    for (var item in companyRef.docs) {
      Map<String, dynamic> companyData = item.data() as Map<String, dynamic>;
      await CompanyCache.setCompanyId(item.id);
      await CompanyCache.setCurrency(companyData['currency']);
      await CompanyCache.setCompanyGstNo(companyData['einNumber']);
      await CompanyCache.setCompanyLicenseNo(companyData['licenseNo']);
      await CompanyCache.setCompanyLogoUrl(companyData['logoUrl']);
      await CompanyCache.setIndustry(companyData['industryName']);
      await CompanyCache.setUserAddress(companyData['address']);
      await saveCompanyCurrencySymbol(companyData['currency']);
    }

    await UserCache.setUserLoggedIn(true);
    await UserCache.setUserId(user.uid);
    await UserCache.setUsername(userName);
    await UserCache.setUserEmail(user.email ?? '');
    await UserCache.setUserCreatedAt(DateTime.now());
  }

  Future<void> saveCompanyCurrencySymbol(currencySelected) async {
    String currency;
    switch (currencySelected) {
      case 'EUR':
        currency = Currency.euro.symbol;
        break;
      case 'INR':
        currency = Currency.indianRupee.symbol;
        break;
      case 'USD':
        currency = Currency.usDollar.symbol;
        break;
      default:
        currency = Currency.indianRupee.symbol;
        break;
    }
    await CompanyCache.setCurrencySymbol(currency);
  }

  String _handleFirebaseAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Wrong password provided for that user.';
      case 'email-already-in-use':
        return 'The account already exists for that email.';
      default:
        return 'An error occurred: ${e.message}';
    }
  }
}
