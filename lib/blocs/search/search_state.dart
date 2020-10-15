import 'package:certain/models/user.dart';
import 'package:equatable/equatable.dart';

abstract class SearchState extends Equatable {
  const SearchState();
  @override
  List<Object> get props => [];
}

class InitialSearchState extends SearchState {}

class LoadingState extends SearchState {}

class LoadUserState extends SearchState {
  final User user;

  LoadUserState(this.user);

  @override
  List<Object> get props => [user];
}
