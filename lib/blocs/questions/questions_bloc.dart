import 'dart:async';
import 'dart:io';
import 'package:certain/models/my_user.dart';
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
    }
  }

  Stream<QuestionsState> _mapLoadQuestionsToState() async* {
    yield LoadingState();

    List<Question> questionList = await _questionsRepository.getQuestions();

    yield LoadQuestionsState(questionList);
  }
}
