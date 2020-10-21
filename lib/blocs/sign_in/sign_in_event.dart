import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class SignInEvent extends Equatable {
  const SignInEvent();

  @override
  List<Object> get props => [];
}

class EmailChanged extends SignInEvent {
  final String email;

  EmailChanged({@required this.email});

  @override
  List<Object> get props => [email];

  @override
  String toString() => 'Email changé {email: $email}';
}

class PasswordChanged extends SignInEvent {
  final String password;

  PasswordChanged({@required this.password});

  @override
  List<Object> get props => [password];

  @override
  String toString() => 'Mot de passe changé {password: $password}';
}

class Submitted extends SignInEvent {
  final String email;
  final String password;

  Submitted({this.email, this.password});

  @override
  List<Object> get props => [email, password];
}

class LoginWithCredentialsPressed extends SignInEvent {
  final String email;
  final String password;

  LoginWithCredentialsPressed({@required this.email, @required this.password});

  @override
  List<Object> get props => [email, password];
}
