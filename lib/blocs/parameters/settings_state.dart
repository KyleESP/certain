import 'package:certain/models/user_model.dart';
import 'package:flutter/cupertino.dart';

@immutable
class SettingsState {
  final bool isFailure;

  SettingsState({@required this.isFailure});

  factory SettingsState.failure() {
    return SettingsState(
      isFailure: true,
    );
  }
}

class SettingsInitialState extends SettingsState {}

class LoadingState extends SettingsState {}

class LoadSettingsToState extends SettingsState {}

class LoadUserState extends SettingsState {
  final UserModel user;

  LoadUserState(this.user);
}
