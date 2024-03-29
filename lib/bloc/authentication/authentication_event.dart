abstract class AuthenticationEvent {}

class AuthenticateUser extends AuthenticationEvent {
  final Map authenticationMap;

  AuthenticateUser({required this.authenticationMap});
}

class LogOutOfSession extends AuthenticationEvent {}
