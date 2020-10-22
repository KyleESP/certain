import 'package:equatable/equatable.dart';

abstract class PlayMcqEvent extends Equatable {
  const PlayMcqEvent();

  @override
  List<Object> get props => [];
}

class CompletedEvent extends PlayMcqEvent {
  final String currentUserId, selectedUserId, status;

  CompletedEvent({this.currentUserId, this.selectedUserId, this.status});

  @override
  List<Object> get props => [currentUserId, selectedUserId, status];
}
