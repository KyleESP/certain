import 'dart:async';
import 'package:bloc/bloc.dart';
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
    }
    if (event is LoadCurrentUserEvent) {
      yield* _mapLoadCurrentUserToState(currentUserId: event.userId);
    }
    if (event is RemoveMatchEvent) {
      yield* _mapRemoveMatchToState(
          currentUserId: event.currentUser, selectedUserId: event.selectedUser);
    }
    if (event is OpenChatEvent) {
      yield* _mapOpenChatToState(
          currentUserId: event.currentUser, selectedUserId: event.selectedUser);
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
    _matchesRepository.removeMatch(currentUserId, selectedUserId);
  }

  Stream<MatchesState> _mapOpenChatToState(
      {String currentUserId, String selectedUserId}) async* {
    _matchesRepository.openChat(
        currentUserId: currentUserId, selectedUserId: selectedUserId);
  }
}
