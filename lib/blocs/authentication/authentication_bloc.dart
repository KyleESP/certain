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
    final isSignedIn = _userRepository.isSignedIn();
    if (isSignedIn) {
      final userExists = await _userRepository.userExists();
      var mcqExists = false;
      if (userExists) {
        mcqExists = await _userRepository.userMcqExists();
        if (mcqExists) {
          yield Authenticated(_userRepository.getUserId());
        } else {
          yield Unauthenticated();
        }
      } else {
        yield Unauthenticated();
      }
    } else {
      yield Unauthenticated();
    }
  }

  Stream<AuthenticationState> _mapLoggedInToState() async* {
    final userExists = await _userRepository.userExists();
    final uid = _userRepository.getUserId();
    var mcqExists = false;
    if (userExists) {
      mcqExists = await _userRepository.userMcqExists();
    }

    if (!userExists) {
      yield AuthenticatedButProfileNotSet(uid);
    } else if (!mcqExists) {
      yield AuthenticatedButMcqNotSet(uid);
    } else {
      yield Authenticated(uid);
    }
  }

  Stream<AuthenticationState> _mapLoggedOutToState() async* {
    yield Unauthenticated();
    _userRepository.signOut();
  }
}
