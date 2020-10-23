import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:certain/helpers/functions.dart';
import 'package:certain/models/user_model.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:certain/repositories/matches_repository.dart';

import './bloc.dart';

class MatchesBloc extends Bloc<MatchesEvent, MatchesState> {
  MatchesRepository _matchesRepository;

  MatchesBloc(this._matchesRepository) : super(LoadingState());

  @override
  Stream<MatchesState> mapEventToState(
    MatchesEvent event,
  ) async* {
    if (event is LoadListsEvent) {
      yield* _mapLoadListToState(currentUserId: event.userId);
    } else if (event is LoadCurrentUserEvent) {
      yield* _mapLoadCurrentUserToState(currentUserId: event.userId);
    } else if (event is RemoveMatchEvent) {
      yield* _mapRemoveMatchToState(
          currentUserId: event.currentUser, selectedUserId: event.selectedUser);
    } else if (event is PassedMcqEvent) {
      yield* _mapPassedMcqToState(
          currentUserId: event.currentUser, selectedUserId: event.selectedUser);
    } else if (event is SelectedUserEvent) {
      yield* _mapSelectedUserToState(event.selectedUserId);
    }
  }

  Stream<MatchesState> _mapLoadCurrentUserToState(
      {String currentUserId}) async* {
    UserModel currentUser =
        await _matchesRepository.getUserDetails(currentUserId);

    yield LoadCurrentUserState(currentUser: currentUser);
  }

  Stream<MatchesState> _mapLoadListToState({String currentUserId}) async* {
    yield LoadingState();

    Stream<QuerySnapshot> matchedList =
        _matchesRepository.getMatchList(currentUserId);

    yield LoadUserState(matchedList: matchedList);
  }

  Stream<MatchesState> _mapRemoveMatchToState(
      {String currentUserId, String selectedUserId}) async* {
    yield LoadingState();

    await _matchesRepository.removeMatch(currentUserId, selectedUserId);
  }

  Stream<MatchesState> _mapPassedMcqToState(
      {String currentUserId, String selectedUserId}) async* {
    yield LoadingState();

    await _matchesRepository.passedMcq(
        currentUserId: currentUserId, selectedUserId: selectedUserId);
  }

  Stream<MatchesState> _mapSelectedUserToState(String selectedUserId) async* {
    yield LoadingState();

    UserModel selectedUser =
        await _matchesRepository.getUserDetails(selectedUserId);
    selectedUser.distance = await getDistance(selectedUser.location);

    yield IsSelectedState(selectedUser: selectedUser);
  }
}
