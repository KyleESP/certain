import 'package:flutter/cupertino.dart';
import 'package:certain/models/question_model.dart';

@immutable
class EditMcqState {
  final bool isSuccess;
  final bool isSubmitting;
  final bool isFailure;

  EditMcqState(
      {this.isSuccess = false,
      this.isFailure = false,
      this.isSubmitting = false});

  factory EditMcqState.success() {
    return EditMcqState(
      isSubmitting: false,
      isSuccess: true,
      isFailure: false,
    );
  }

  factory EditMcqState.failure() {
    return EditMcqState(
      isSubmitting: false,
      isSuccess: false,
      isFailure: true,
    );
  }

  factory EditMcqState.loading() {
    return EditMcqState(
      isFailure: false,
      isSuccess: false,
      isSubmitting: true,
    );
  }
}

class EditMcqInitialState extends EditMcqState {}

class ShowMcqState extends EditMcqState {}

class LoadingState extends EditMcqState {}

class LoadMcqState extends EditMcqState {
  final List<QuestionModel> mcq;

  LoadMcqState(this.mcq);
}
