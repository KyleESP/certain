import 'dart:async';
import 'package:certain/repositories/user_repository.dart';

import 'bloc.dart';

import 'package:bloc/bloc.dart';

import 'package:certain/models/user_model.dart';
import 'package:certain/repositories/search_repository.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchRepository _searchRepository;
  UserRepository _userRepository;

  SearchBloc(this._searchRepository, this._userRepository)
      : super(InitialSearchState());

  @override
  Stream<SearchState> mapEventToState(
    SearchEvent event,
  ) async* {
    if (event is LoadCurrentUserEvent) {
      yield* _mapLoadCurrentUserToState(currentUserId: event.userId);
    } else if (event is LoadUserEvent) {
      yield* _mapLoadUserToState();
    }
  }

  Stream<SearchState> _mapLoadUserToState() async* {
    yield LoadingState();

    UserModel user = await _userRepository.getUser();
    List<UserModel> usersToShow = await _searchRepository.getUsersToShow();

    yield LoadUserState(user, usersToShow);
  }

  Stream<SearchState> _mapLoadCurrentUserToState(
      {String currentUserId}) async* {
    yield LoadCurrentUserState();
  }
}
