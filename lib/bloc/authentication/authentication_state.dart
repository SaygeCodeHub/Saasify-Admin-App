abstract class AuthenticationState {}

final class AuthenticationInitial extends AuthenticationState {}

final class AuthenticatingUser extends AuthenticationState {}

final class UserAuthenticated extends AuthenticationState {}

final class UserAuthenticatedWithoutCompany extends AuthenticationState {}

final class UserNotAuthenticated extends AuthenticationState {
  final String errorMessage;

  UserNotAuthenticated({required this.errorMessage});
}
