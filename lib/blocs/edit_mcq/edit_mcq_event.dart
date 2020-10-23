import 'package:equatable/equatable.dart';

abstract class EditMcqEvent extends Equatable {
  const EditMcqEvent();

  @override
  List<Object> get props => [];
}

class SubmittedMcqEvent extends EditMcqEvent {
  final String userId;
  final List<Map<String, String>> userQuestions;

  SubmittedMcqEvent({this.userId, this.userQuestions});

  @override
  List<Object> get props => [userId, userQuestions];
}
