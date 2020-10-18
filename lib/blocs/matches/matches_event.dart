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

class RemoveMatchEvent extends MatchesEvent {
  final String currentUser, selectedUser;

  RemoveMatchEvent({this.currentUser, this.selectedUser});

  @override
  List<Object> get props => [
        currentUser,
        selectedUser,
      ];
}

class OpenChatEvent extends MatchesEvent {
  final String currentUser, selectedUser;

  OpenChatEvent({this.currentUser, this.selectedUser});

  @override
  List<Object> get props => [
        currentUser,
        selectedUser,
      ];
}
