import 'package:certain/models/question_model.dart';
import 'package:equatable/equatable.dart';

abstract class CreateMcqEvent extends Equatable {
  const CreateMcqEvent();

  @override
  List<Object> get props => [];
}

class LoadQuestionsEvent extends CreateMcqEvent {
  final List<QuestionModel> questionList;

  LoadQuestionsEvent({this.questionList});

  @override
  List<Object> get props => [questionList];
}

class LoadQuestionEvent extends CreateMcqEvent {
  LoadQuestionEvent();

  @override
  List<Object> get props => [];
}

class SubmittedMcqEvent extends CreateMcqEvent {
  final List<Map<String, String>> userQuestions;

  SubmittedMcqEvent({this.userQuestions});

  @override
  List<Object> get props => [userQuestions];
}
