import 'package:certain/models/my_user.dart';
import 'package:equatable/equatable.dart';

abstract class SearchState extends Equatable {
  const SearchState();
  @override
  List<Object> get props => [];
}

class InitialSearchState extends SearchState {}

class LoadingState extends SearchState {}

class LoadUserState extends SearchState {
  final MyUser user;

  LoadUserState(this.user);
}

class LoadCurrentUserState extends SearchState {
  final MyUser currentUser;

  LoadCurrentUserState(this.currentUser);

  @override
  List<Object> get props => [currentUser];
}

class HasMatchedState extends SearchState {}
