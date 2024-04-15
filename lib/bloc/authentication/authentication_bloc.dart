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
import '../../services/firebase_services.dart';
import '../../services/service_locator.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final firebaseServices = getIt<FirebaseServices>();
  final sharedPreferences = getIt<SharedPreferences>();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  AuthenticationBloc() : super(AuthenticationInitial()) {
    on<AuthenticateUser>(_authenticateUser);
    on<LogOutOfSession>(_logOutOfSession);
    on<CheckActiveSession>(_checkActiveSession);
  }

  FutureOr<void> _checkActiveSession(
      CheckActiveSession event, Emitter<AuthenticationState> emit) async {
    bool isLoggedIn = await UserCache.getUserLoggedIn();
    if (isLoggedIn) {
      String? companyId = CompanyCache.getCompanyId();
      if (companyId != null || companyId!.isNotEmpty) {
        emit(UserAuthenticated(userName: await UserCache.getUsername() ?? ''));
      } else {
        emit(UserAuthenticatedWithoutCompany());
      }
    } else {
      emit(InActiveSession());
    }
  }

  FutureOr<void> _logOutOfSession(
      LogOutOfSession event, Emitter<AuthenticationState> emit) async {
    emit(LoggingOutOfSession());
    try {
      await FirebaseAuth.instance.signOut();
      sharedPreferences.clear();
      emit(LoggedOutOfSession());
    } catch (error) {
      emit(LoggingOutFailed());
    }
  }

  FutureOr<void> _authenticateUser(
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
        await saveToLocalCache(user);
        if (await checkUserCompanies(user.uid)) {
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
      emit(UserNotAuthenticated(errorMessage: e.toString()));
    } catch (e) {
      emit(UserNotAuthenticated(
          errorMessage:
              'An unexpected error occurred. Please try again later.'));
    }
  }

  Future<bool> checkUserCompanies(String userUid) async {
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
    if (authMap['is_sign_in']) {
      final usersRef = await firestore
          .collection(FirestoreCollection.users.collectionName)
          .doc(user.uid)
          .get();
      userName = await usersRef.get('name') ?? '';
    }
    await firestore.collection('users').doc(user.uid).set({
      'name': authMap['name'] ?? userName,
      'email': authMap['email'],
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> saveToLocalCache(User user) async {
    final usersRef = await firestore
        .collection(FirestoreCollection.users.collectionName)
        .doc(user.uid)
        .get();
    String userName = await usersRef.get('name') ?? '';
    final companyRef = await firestore
        .collection(FirestoreCollection.users.collectionName)
        .doc(user.uid)
        .collection(FirestoreCollection.companies.collectionName)
        .get();
    for (var item in companyRef.docs) {
      await CompanyCache.setCompanyId(item.id);
    }
    await UserCache.setUserLoggedIn(true);
    await UserCache.setUserId(user.uid);
    await UserCache.setUsername(userName);
    await UserCache.setUserEmail(user.email ?? '');
    await UserCache.setUserCreatedAt(DateTime.now());
  }

  String _handleFirebaseAuthError(FirebaseAuthException e) {
    print('insdide method----->${e.code}');
    switch (e.code) {
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Wrong password provided for that user.';
      case 'email-already-in-use':
        return 'The account already exists for that email.';
      case 'too-many-requests':
        return 'There are too many requests for this email';
      case 'invalid-credential':
        return 'The credentials entered are invalid';
      default:
        return 'An error occurred: ${e.message}';
    }
  }
}
