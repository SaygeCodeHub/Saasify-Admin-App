abstract class AuthenticationState {}

class AuthenticationInitial extends AuthenticationState {}

class AuthenticatingUser extends AuthenticationState {}

class UserAuthenticated extends AuthenticationState {
  final String userName;

  UserAuthenticated({required this.userName});
}

class UserAuthenticatedWithoutCompany extends AuthenticationState {}

class UserNotAuthenticated extends AuthenticationState {
  final String errorMessage;

  UserNotAuthenticated({required this.errorMessage});
}

class InActiveSession extends AuthenticationState {}

class LoggingOutOfSession extends AuthenticationState {}

class LoggedOutOfSession extends AuthenticationState {}

class LoggingOutFailed extends AuthenticationState {
  final String errorMessage;

  LoggingOutFailed({required this.errorMessage});
}
