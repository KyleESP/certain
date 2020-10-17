import 'dart:async';
import 'package:certain/models/question.dart';
import 'package:certain/repositories/questions_repository.dart';

import 'bloc.dart';

import 'package:bloc/bloc.dart';

class QuestionsBloc extends Bloc<QuestionsEvent, QuestionsState> {
  QuestionsRepository _questionsRepository;

  QuestionsBloc(this._questionsRepository) : super(QuestionsInitialState());

  @override
  Stream<QuestionsState> mapEventToState(QuestionsEvent event) async* {
    if (event is LoadQuestionsEvent) {
      yield* _mapLoadQuestionsToState();
    } else if (event is LoadQuestionEvent) {
      yield* _mapLoadQuestionToState();
    } else if (event is SubmittedMcqEvent) {
      yield* _mapSubmittedMcqToState(event.userQuestions);
    }
  }

  Stream<QuestionsState> _mapLoadQuestionsToState() async* {
    yield LoadingState();

    List<Question> questionList = await _questionsRepository.getQuestions();

    yield LoadQuestionsState(questionList);
  }

  Stream<QuestionsState> _mapLoadQuestionToState() async* {
    yield LoadQuestionState();
  }

  Stream<QuestionsState> _mapSubmittedMcqToState(
      Map<String, Map<String, dynamic>> userQuestions) async* {
    yield QuestionsState.loading();

    try {
      await _questionsRepository.createMcq(userQuestions);

      yield QuestionsState.success();
    } catch (_) {
      QuestionsState.failure();
    }
  }
}
