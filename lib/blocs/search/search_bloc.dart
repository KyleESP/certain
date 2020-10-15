import 'dart:async';
import 'bloc.dart';

import 'package:bloc/bloc.dart';

import 'package:certain/models/user.dart';
import 'package:certain/repositories/search_repository.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchRepository _searchRepository;

  SearchBloc(this._searchRepository) : super(InitialSearchState());

  @override
  Stream<SearchState> mapEventToState(
    SearchEvent event,
  ) async* {
    if (event is SelectUserEvent) {
      yield* _mapSelectToState(
          currentUserId: event.currentUserId,
          selectedUserId: event.selectedUserId);
    }
    if (event is PassUserEvent) {
      yield* _mapPassToState(
        currentUserId: event.currentUserId,
        selectedUserId: event.selectedUserId,
      );
    }
    if (event is LoadUserEvent) {
      yield* _mapLoadUserToState(currentUserId: event.userId);
    }
  }

  Stream<SearchState> _mapSelectToState(
      {String currentUserId, String selectedUserId}) async* {
    yield LoadingState();

    User user = await _searchRepository.likeUser(currentUserId, selectedUserId);

    yield LoadUserState(user);
  }

  Stream<SearchState> _mapPassToState(
      {String currentUserId, String selectedUserId}) async* {
    yield LoadingState();

    User user = await _searchRepository.passUser(currentUserId, selectedUserId);

    yield LoadUserState(user);
  }

  Stream<SearchState> _mapLoadUserToState({String currentUserId}) async* {
    yield LoadingState();

    User user = await _searchRepository.getUser(currentUserId);

    yield LoadUserState(user);
  }
}
