import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saasify/data/customer_cache/customer_cache.dart';
import 'package:saasify/data/models/authentication/authentication_model.dart';
import '../../di/app_module.dart';
import '../../repositories/authentication/authentication_repository.dart';
import 'authentication_event.dart';
import 'authentication_states.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvents, AuthenticationStates> {
  final CustomerCache _customerCache = getIt<CustomerCache>();
  FirebaseAuth auth = FirebaseAuth.instance;

  final AuthenticationRepository _authenticationRepository =
      getIt<AuthenticationRepository>();

  AuthenticationStates get initialState => AuthenticationInitial();

  AuthenticationBloc() : super(AuthenticationInitial()) {
    on<SwitchAuthentication>(_switchLogin);
    on<GetOtp>(_getOtp);
    on<OtpReceivedOnPhone>(_otpReceivedOnPhone);
    on<VerifyOtp>(_onVerifyOtp);
    on<OtpVerified>(_loginWithCredential);
    on<OtpVerificationError>(_onOtpVerificationError);
    on<TextFieldChange>(_textFieldChange);
    on<CheckIfLoggedIn>(_checkIfLoggedIn);
    on<LogOut>(_logOut);
  }

  FutureOr<void> _switchLogin(
      SwitchAuthentication event, Emitter<AuthenticationStates> emit) {
    bool isLogin = !event.isLogin;
    emit(AuthenticationFormLoaded(
        isLogin: isLogin, focusField: event.focusField));
  }

  FutureOr<void> _textFieldChange(
      TextFieldChange event, Emitter<AuthenticationStates> emit) {
    emit(AuthenticationFormLoaded(
        isLogin: event.isLogin, focusField: event.focusField));
  }

  _otpReceivedOnPhone(
      OtpReceivedOnPhone event, Emitter<AuthenticationStates> emit) async {
    emit(OtpReceived(
        verificationId: event.verificationId, userName: event.userName));
  }

  FutureOr<void> _getOtp(
      GetOtp event, Emitter<AuthenticationStates> emit) async {
    emit(OtpLoading());
    try {
      await _authenticationRepository.verifyPhoneNumber(
        phoneNumber: event.phoneNo,
        verificationCompleted: (PhoneAuthCredential credential) async {
          add(OtpVerified(credential: credential, userName: event.userName));
        },
        codeSent: (String verificationId, int? resendToken) {
          add(OtpReceivedOnPhone(
              verificationId: verificationId,
              token: resendToken,
              userName: event.userName));
        },
        verificationFailed: (FirebaseAuthException e) {
          add(OtpVerificationError(error: e.code));
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      emit(PhoneAuthError(error: e.toString()));
    }
  }

  FutureOr<void> _onVerifyOtp(
      VerifyOtp event, Emitter<AuthenticationStates> emit) async {
    try {
      emit(OtpLoading());
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: event.verificationId,
        smsCode: event.otpCode,
      );
      add(OtpVerified(credential: credential, userName: event.userName));
    } catch (e) {
      emit(PhoneAuthError(error: e.toString()));
    }
  }

  FutureOr<void> _loginWithCredential(
      OtpVerified event, Emitter<AuthenticationStates> emit) async {
    try {
      await auth.signInWithCredential(event.credential).then((user) async {
        if (user.user != null) {
          Map userDetailsMap = {
            'user_id': user.user!.uid,
            'user_name': (event.userName.toString() == "")
                ? ""
                : event.userName.toString(),
            'user_contact': user.user?.phoneNumber!.replaceAll('+', '')
          };
          AuthenticationModel authenticationModel =
              await _authenticationRepository.authenticateUser(userDetailsMap);
          if (authenticationModel.status == 200) {
            _customerCache.setIsLoggedIn(true);
            _customerCache.setUserId(user.user!.uid);
            emit(PhoneOtpVerified(userData: authenticationModel.data));
          } else if (authenticationModel.status == 404) {
            emit(PhoneAuthError(error: authenticationModel.message.toString()));
            emit(AuthenticationFormLoaded(isLogin: true, focusField: ''));
          } else {
            emit(PhoneAuthError(error: authenticationModel.message));
          }
        }
      });
    } on FirebaseAuthException catch (e) {
      emit(PhoneAuthError(error: e.code));
    } catch (e) {
      emit(PhoneAuthError(error: e.toString()));
    }
  }

  _onOtpVerificationError(
      OtpVerificationError event, Emitter<AuthenticationStates> emit) async {
    emit(PhoneAuthError(error: event.error));
    emit(AuthenticationFormLoaded(isLogin: true, focusField: ''));
  }

  FutureOr<void> _checkIfLoggedIn(
      CheckIfLoggedIn event, Emitter<AuthenticationStates> emit) async {
    bool? isLoggedIn = await _customerCache.getIsLoggedIn();
    if (isLoggedIn == true) {
      emit(IsLoggedIn());
    }
  }

  FutureOr<void> _logOut(LogOut event, Emitter<AuthenticationStates> emit) {
    _customerCache.clearAll();
    emit(LoggedOut());
  }
}
