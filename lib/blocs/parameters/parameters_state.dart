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
