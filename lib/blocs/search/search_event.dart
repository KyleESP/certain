import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadUserEvent extends SearchEvent {
  final String userId;

  LoadUserEvent({this.userId});

  @override
  List<Object> get props => [userId];
}

class LoadCurrentUserEvent extends SearchEvent {
  final String userId;

  LoadCurrentUserEvent({this.userId});

  @override
  List<Object> get props => [userId];
}

class LikeUserEvent extends SearchEvent {
  final String currentUserId,
      selectedUserId,
      selectedUserName,
      selectedUserPhotoUrl,
      currentUserName,
      currentUserPhotoUrl;

  LikeUserEvent(
      {this.currentUserId,
      this.selectedUserId,
      this.selectedUserName,
      this.selectedUserPhotoUrl,
      this.currentUserName,
      this.currentUserPhotoUrl});

  @override
  List<Object> get props => [
        currentUserId,
        selectedUserId,
        selectedUserName,
        selectedUserPhotoUrl,
        currentUserName,
        currentUserPhotoUrl
      ];
}

class DislikeUserEvent extends SearchEvent {
  final String currentUserId, selectedUserId;

  DislikeUserEvent(this.currentUserId, this.selectedUserId);

  @override
  List<Object> get props => [currentUserId, selectedUserId];
}
