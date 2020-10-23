import 'dart:async';
import 'bloc.dart';

import 'package:bloc/bloc.dart';

import 'package:certain/repositories/matches_repository.dart';

class PlayMcqBloc extends Bloc<PlayMcqEvent, PlayMcqState> {
  MatchesRepository _matchesRepository;

  PlayMcqBloc(this._matchesRepository) : super(PlayMcqInitialState());

  @override
  Stream<PlayMcqState> mapEventToState(PlayMcqEvent event) async* {
    if (event is CompletedEvent) {
      yield* _mapCompletedToState(
          currentUserId: event.currentUserId,
          selectedUserId: event.selectedUserId,
          status: event.status);
    }
  }

  Stream<PlayMcqState> _mapCompletedToState(
      {currentUserId, selectedUserId, status}) async* {
    yield LoadingState();

    if (status == "s") {
      bool openChat = await _matchesRepository.passedMcq(
          currentUserId: currentUserId, selectedUserId: selectedUserId);
      if (openChat) {
        yield CompletedState(
            "Vous avez tout deux réussi vos QCM. Vous pouvez maintenant parler.");
      } else {
        yield CompletedState(
            "Vous avez réussi le QCM. Patientez que l'autre réussisse aussi.");
      }
    } else {
      await _matchesRepository.removeMatch(currentUserId, selectedUserId);
      yield CompletedState("Vous avez raté le QCM... Dommage !");
    }
  }
}
