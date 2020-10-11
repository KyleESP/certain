import 'package:cloud_firestore/cloud_firestore.dart';
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
  final DocumentSnapshot user;

  LoadUserState(this.user);
}
