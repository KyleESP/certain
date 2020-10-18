import 'package:certain/models/user_model.dart';
import 'package:equatable/equatable.dart';

abstract class SearchState extends Equatable {
  const SearchState();
  @override
  List<Object> get props => [];
}

class InitialSearchState extends SearchState {}

class LoadingState extends SearchState {}

class LoadUserState extends SearchState {
  final List<UserModel> usersToShow;
  final UserModel user;

  LoadUserState(this.user, this.usersToShow);
}

class LoadCurrentUserState extends SearchState {
  @override
  List<Object> get props => [];
}

class HasMatchedState extends SearchState {}
