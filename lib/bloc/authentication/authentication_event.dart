abstract class AuthenticationEvent {}

class AuthenticateUser extends AuthenticationEvent {
  final Map authenticationMap;

  AuthenticateUser({required this.authenticationMap});
}

class CheckActiveSession extends AuthenticationEvent {}

class LogOutOfSession extends AuthenticationEvent {}
