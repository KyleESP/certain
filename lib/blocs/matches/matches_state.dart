import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

abstract class MatchesState extends Equatable {
  const MatchesState();

  @override
  List<Object> get props => [];
}

class LoadingState extends MatchesState {}

class LoadUserState extends MatchesState {
  final Stream<QuerySnapshot> matchedList;

  LoadUserState({this.matchedList});

  @override
  List<Object> get props => [matchedList];
}
