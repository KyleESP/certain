import 'package:certain/models/my_user.dart';
import 'package:flutter/cupertino.dart';

@immutable
class ParametersState {
  final bool isFailure;

  ParametersState({@required this.isFailure});

  factory ParametersState.failure() {
    return ParametersState(
      isFailure: true,
    );
  }
}

class ParametersInitialState extends ParametersState {}

class LoadingState extends ParametersState {}

class LoadUserState extends ParametersState {
  final MyUser user;

  LoadUserState(this.user);
}
