abstract class AuthenticationState {}

class AuthenticationInitial extends AuthenticationState {}

class AuthenticatingUser extends AuthenticationState {}

class UserAuthenticated extends AuthenticationState {}

class UserAuthenticatedWithoutCompany extends AuthenticationState {}

class UserNotAuthenticated extends AuthenticationState {
  final String errorMessage;

  UserNotAuthenticated({required this.errorMessage});
}

class LoggingOutOfSession extends AuthenticationState {}

class LoggedOutOfSession extends AuthenticationState {}

class LoggingOutFailed extends AuthenticationState {}
