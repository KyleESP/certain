import 'package:equatable/equatable.dart';

abstract class PlayMcqState extends Equatable {
  const PlayMcqState();

  @override
  List<Object> get props => [];
}

class PlayMcqInitialState extends PlayMcqState {}

class LoadingState extends PlayMcqState {}

class CompletedState extends PlayMcqState {
  final String message;

  CompletedState(this.message);

  @override
  List<Object> get props => [message];
}
