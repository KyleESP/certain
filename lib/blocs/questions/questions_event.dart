import 'package:certain/models/question_model.dart';
import 'package:equatable/equatable.dart';

abstract class QuestionsEvent extends Equatable {
  const QuestionsEvent();

  @override
  List<Object> get props => [];
}

class LoadQuestionsEvent extends QuestionsEvent {
  final List<QuestionModel> questionList;

  LoadQuestionsEvent({this.questionList});

  @override
  List<Object> get props => [questionList];
}

class LoadQuestionEvent extends QuestionsEvent {
  LoadQuestionEvent();

  @override
  List<Object> get props => [];
}

class SubmittedMcqEvent extends QuestionsEvent {
  final Map<String, Map<String, dynamic>> userQuestions;

  SubmittedMcqEvent({this.userQuestions});

  @override
  List<Object> get props => [userQuestions];
}
