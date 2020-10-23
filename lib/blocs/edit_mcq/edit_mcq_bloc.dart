import 'dart:async';

import 'package:bloc/bloc.dart';

import 'bloc.dart';
import 'package:certain/repositories/questions_repository.dart';
import 'package:certain/models/question_model.dart';

class EditMcqBloc extends Bloc<EditMcqEvent, EditMcqState> {
  QuestionsRepository _questionsRepository;

  EditMcqBloc(this._questionsRepository) : super(EditMcqInitialState());

  @override
  Stream<EditMcqState> mapEventToState(EditMcqEvent event) async* {
    if (event is LoadMcqEvent) {
      yield* _mapLoadMcqToState(event.userId);
    } else if (event is LoadedMcqEvent) {
      yield* _mapLoadedMcqToState();
    } else if (event is SubmittedMcqEvent) {
      yield* _mapSubmittedMcqToState(
          userId: event.userId, userQuestions: event.userQuestions);
    }
  }

  Stream<EditMcqState> _mapLoadMcqToState(String userId) async* {
    yield LoadingState();

    List<QuestionModel> mcq = await _questionsRepository.getMcq(userId);

    yield LoadMcqState(mcq);
  }

  Stream<EditMcqState> _mapLoadedMcqToState() async* {
    yield ShowMcqState();
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
