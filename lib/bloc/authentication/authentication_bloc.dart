import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saasify/bloc/authentication/authentication_event.dart';
import 'package:saasify/bloc/authentication/authentication_state.dart';

import '../../cache/cache.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc() : super(AuthenticationInitial()) {
    on<AuthenticateUser>(_authenticateUser);
    on<LogOutOfSession>(_logOutOfSession);
  }

  FutureOr<void> _logOutOfSession(
      LogOutOfSession event, Emitter<AuthenticationState> emit) async {
    emit(LoggingOutOfSession());

    try {
      await FirebaseAuth.instance.signOut();
      Cache().clearSharedPreferences();
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
        await _cacheUserData(user);
        if (await checkUserCompanies(user.uid)) {
          emit(UserAuthenticated());
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

  Future<bool> checkUserCompanies(String userUid) async {
    final FirebaseFirestore db = FirebaseFirestore.instance;
    final QuerySnapshot companiesSnapshot =
        await db.collection('users').doc(userUid).collection('companies').get();
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
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore.collection('users').doc(user.uid).set({
      'name': authMap['name'],
      'email': authMap['email'],
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> _cacheUserData(User user) async {
    await Cache.setUserLoggedIn(true);
    await Cache.setUserId(user.uid);
    await Cache.setUserName(user.displayName ?? '');
    await Cache.setUserEmail(user.email ?? '');
    await Cache.setUserCreatedAt(DateTime.now().toString());
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
