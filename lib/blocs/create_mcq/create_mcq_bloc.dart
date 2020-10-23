import 'dart:async';
import 'package:certain/models/question_model.dart';
import 'package:certain/repositories/questions_repository.dart';

import 'bloc.dart';

import 'package:bloc/bloc.dart';

class CreateMcqBloc extends Bloc<CreateMcqEvent, CreateMcqState> {
  QuestionsRepository _questionsRepository;

  CreateMcqBloc(this._questionsRepository) : super(QuestionsInitialState());

  @override
  Stream<CreateMcqState> mapEventToState(CreateMcqEvent event) async* {
    if (event is LoadQuestionsEvent) {
      yield* _mapLoadQuestionsToState();
    } else if (event is LoadQuestionEvent) {
      yield* _mapLoadQuestionToState();
    } else if (event is SubmittedMcqEvent) {
      yield* _mapSubmittedMcqToState(
          userId: event.userId, userQuestions: event.userQuestions);
    }
  }

  Stream<CreateMcqState> _mapLoadQuestionsToState() async* {
    yield LoadingState();

    List<QuestionModel> questionList =
        await _questionsRepository.getQuestions();

    yield LoadQuestionsState(questionList);
  }

  Stream<CreateMcqState> _mapLoadQuestionToState() async* {
    yield LoadQuestionState();
  }

  Stream<CreateMcqState> _mapSubmittedMcqToState(
      {userId, userQuestions}) async* {
    yield CreateMcqState.loading();

    try {
      await _questionsRepository.editMcq(
          userId: userId, userQuestions: userQuestions);

      yield CreateMcqState.success();
    } catch (_) {
      CreateMcqState.failure();
    }
  }
}
