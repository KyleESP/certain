import 'package:flutter/cupertino.dart';

@immutable
class PlayMcqState {
  final bool isCompleted;
  final String status;

  PlayMcqState({this.isCompleted = false, this.status = ""});

  factory PlayMcqState.completed(String status) {
    return PlayMcqState(isCompleted: true, status: status);
  }
}

class PlayMcqInitialState extends PlayMcqState {}

class LoadingState extends PlayMcqState {}
