import 'package:certain/models/user_model.dart';
import 'package:flutter/cupertino.dart';

@immutable
class SettingsState {
  final bool isSubmitting;
  final bool isFailure;
  final bool isSuccess;

  SettingsState(
      {this.isFailure = false,
      this.isSubmitting = false,
      this.isSuccess = false});

  factory SettingsState.submitting() {
    return SettingsState(
      isFailure: false,
      isSubmitting: true,
      isSuccess: false
    );
  }

  factory SettingsState.success() {
    return SettingsState(
        isFailure: false,
        isSubmitting: false,
        isSuccess: true
    );
  }

  factory SettingsState.failure() {
    return SettingsState(
        isFailure: true,
        isSubmitting: false,
        isSuccess: false
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
