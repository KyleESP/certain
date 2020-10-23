import 'dart:async';

import 'package:bloc/bloc.dart';

import 'bloc.dart';
import 'package:certain/repositories/questions_repository.dart';

class EditMcqBloc extends Bloc<EditMcqEvent, EditMcqState> {
  QuestionsRepository _questionsRepository;

  EditMcqBloc(this._questionsRepository) : super(EditMcqInitialState());

  @override
  Stream<EditMcqState> mapEventToState(EditMcqEvent event) async* {
    if (event is SubmittedMcqEvent) {
      yield* _mapSubmittedMcqToState(
          userId: event.userId, userQuestions: event.userQuestions);
    }
  }

  Stream<EditMcqState> _mapSubmittedMcqToState(
      {String userId, List<Map<String, String>> userQuestions}) async* {
    yield EditMcqState.loading();

    try {
      await _questionsRepository.editMcq(
          userId: userId, userQuestions: userQuestions);

      yield EditMcqState.success();
    } catch (_) {
      EditMcqState.failure();
    }
  }
}
