import 'package:certain/models/user_model.dart';
import 'package:flutter/cupertino.dart';

@immutable
class SearchState {
  final bool hasMatched;

  SearchState({this.hasMatched = false});

  factory SearchState.matched() {
    return SearchState(hasMatched: true);
  }
}

class InitialSearchState extends SearchState {}

class LoadingState extends SearchState {}

class LoadUserState extends SearchState {
  final List<UserModel> usersToShow;
  final UserModel user;

  LoadUserState(this.user, this.usersToShow);
}

class LoadCurrentUserState extends SearchState {}
