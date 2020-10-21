import 'dart:async';
import 'bloc.dart';

import 'package:bloc/bloc.dart';

import 'package:certain/repositories/user_repository.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository _userRepository;

  AuthenticationBloc(this._userRepository) : super(Uninitialized());

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AppStarted) {
      yield* _mapAppStartedToState();
    } else if (event is LoggedIn) {
      yield* _mapLoggedInToState();
    } else if (event is LoggedOut) {
      yield* _mapLoggedOutToState();
    }
  }

  Stream<AuthenticationState> _mapAppStartedToState() async* {
    yield Unauthenticated();
  }

  Stream<AuthenticationState> _mapLoggedInToState() async* {
    final userExists = await _userRepository.userExists();
    var mcqExists = false;
    if (userExists) {
      mcqExists = await _userRepository.userMcqExists();
    }

    if (!userExists) {
      yield AuthenticatedButProfileNotSet(_userRepository.getUserId());
    } else if (!mcqExists) {
      yield AuthenticatedButMcqNotSet();
    } else {
      yield Authenticated(_userRepository.getUserId());
    }
  }

  Stream<AuthenticationState> _mapLoggedOutToState() async* {
    yield Unauthenticated();
    _userRepository.signOut();
  }
}
