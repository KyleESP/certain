import 'package:equatable/equatable.dart';

abstract class MatchesEvent extends Equatable {
  const MatchesEvent();

  @override
  List<Object> get props => [];
}

class LoadListsEvent extends MatchesEvent {
  final String userId;

  LoadListsEvent({this.userId});

  @override
  List<Object> get props => [userId];
}

class LoadCurrentUserEvent extends MatchesEvent {
  final String userId;

  LoadCurrentUserEvent({this.userId});

  @override
  List<Object> get props => [userId];
}


class RemoveMatchEvent extends MatchesEvent {
  final String currentUser, selectedUser;

  RemoveMatchEvent({this.currentUser, this.selectedUser});

  @override
  List<Object> get props => [
        currentUser,
        selectedUser,
      ];
}

class PassedMcqEvent extends MatchesEvent {
  final String currentUser, selectedUser;

  PassedMcqEvent({this.currentUser, this.selectedUser});

  @override
  List<Object> get props => [
        currentUser,
        selectedUser,
      ];
}

class SelectedUserEvent extends MatchesEvent {
  final String selectedUserId;

  SelectedUserEvent(this.selectedUserId);

  @override
  List<Object> get props => [selectedUserId];
}
