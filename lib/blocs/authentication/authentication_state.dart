import 'package:equatable/equatable.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class Uninitialized extends AuthenticationState {}

class Authenticated extends AuthenticationState {
  final String userId;

  Authenticated(this.userId);

  @override
  List<Object> get props => [userId];

  @override
  String toString() => "{userId} authentifié";
}

class AuthenticatedButMcqNotSet extends AuthenticationState {
  final String userId;

  AuthenticatedButMcqNotSet(this.userId);

  @override
  List<Object> get props => [userId];
}

class AuthenticatedButProfileNotSet extends AuthenticationState {
  final String userId;

  AuthenticatedButProfileNotSet(this.userId);

  @override
  List<Object> get props => [userId];
}

class Unauthenticated extends AuthenticationState {}
