import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadUserEvent extends SearchEvent {
  @override
  List<Object> get props => [];
}

class LoadCurrentUserEvent extends SearchEvent {
  final String userId;

  LoadCurrentUserEvent({this.userId});

  @override
  List<Object> get props => [userId];
}