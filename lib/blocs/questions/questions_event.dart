import 'package:certain/models/question.dart';
import 'package:equatable/equatable.dart';

abstract class QuestionsEvent extends Equatable {
  const QuestionsEvent();

  @override
  List<Object> get props => [];
}

class LoadQuestionsEvent extends QuestionsEvent {
  final List<Question> questionList;

  LoadQuestionsEvent({this.questionList});

  @override
  List<Object> get props => [questionList];
}
