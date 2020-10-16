import 'package:certain/models/my_user.dart';
import 'package:certain/models/question.dart';
import 'package:flutter/cupertino.dart';

@immutable
class QuestionsState {
  final bool isFailure;

  QuestionsState({@required this.isFailure});

  factory QuestionsState.failure() {
    return QuestionsState(
      isFailure: true,
    );
  }
}

class QuestionsInitialState extends QuestionsState {}

class LoadingState extends QuestionsState {}

class LoadQuestionsState extends QuestionsState {
  final List<Question> questionList;

  LoadQuestionsState(this.questionList);
}
