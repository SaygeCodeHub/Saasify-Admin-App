abstract class AuthStates {}

class InitialiseAuthStates extends AuthStates {}

class CheckingLoggedInSession extends AuthStates {}

class ActiveSession extends AuthStates {}

class InactiveSession extends AuthStates {}

class RegisteringUser extends AuthStates {}

class UserRegistered extends AuthStates {}

class FailedToRegisterUser extends AuthStates {}

class UserAuthenticated extends AuthStates {}

class AuthenticatingUser extends AuthStates {}

class FailedToAuthenticateUser extends AuthStates {
  final String? errorMessage;

  FailedToAuthenticateUser({this.errorMessage});
}
