import 'package:certain/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

abstract class MatchesState extends Equatable {
  const MatchesState();

  @override
  List<Object> get props => [];
}

class LoadingState extends MatchesState {}

class LoadCurrentUserState extends MatchesState {
  final UserModel currentUser;

  LoadCurrentUserState({this.currentUser});

  @override
  List<Object> get props => [currentUser];
}

class LoadUserState extends MatchesState {
  final Stream<QuerySnapshot> matchedList;

  LoadUserState({this.matchedList});

  @override
  List<Object> get props => [matchedList];
}

class IsSelectedState extends MatchesState {
  final UserModel selectedUser;

  IsSelectedState({this.selectedUser});

  @override
  List<Object> get props => [selectedUser];
}
