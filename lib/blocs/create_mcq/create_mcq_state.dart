import 'package:certain/models/question_model.dart';
import 'package:flutter/cupertino.dart';

@immutable
class CreateMcqState {
  final bool isSuccess;
  final bool isSubmitting;
  final bool isFailure;

  CreateMcqState(
      {this.isSuccess = false,
      this.isFailure = false,
      this.isSubmitting = false});

  factory CreateMcqState.success() {
    return CreateMcqState(
      isSubmitting: false,
      isSuccess: true,
      isFailure: false,
    );
  }

  factory CreateMcqState.failure() {
    return CreateMcqState(
      isSubmitting: false,
      isSuccess: false,
      isFailure: true,
    );
  }

  factory CreateMcqState.loading() {
    return CreateMcqState(
      isFailure: false,
      isSuccess: false,
      isSubmitting: true,
    );
  }
}

class QuestionsInitialState extends CreateMcqState {}

class LoadingState extends CreateMcqState {}

class LoadQuestionsState extends CreateMcqState {
  final List<QuestionModel> questionList;

  LoadQuestionsState(this.questionList);
}

class LoadQuestionState extends CreateMcqState {}
