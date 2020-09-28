import 'dart:async';
import 'bloc.dart';

import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';

import 'package:certain/repositories/user_repository.dart';

import 'package:certain/views/validators.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  UserRepository _userRepository;

  LoginBloc(this._userRepository) : super(LoginState.empty());

  @override
  Stream<Transition<LoginEvent, LoginState>> transformEvents(
    Stream<LoginEvent> events,
    Stream<Transition<LoginEvent, LoginState>> Function(LoginEvent event) next,
  ) {
    final nonDebounceStream = events.where((event) {
      return (event is! EmailChanged || event is! PasswordChanged);
    });

    final debounceStream = events.where((event) {
      return (event is EmailChanged || event is PasswordChanged);
    }).debounceTime(Duration(milliseconds: 300));

    return super.transformEvents(
      nonDebounceStream.mergeWith([debounceStream]),
      next,
    );
  }

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is EmailChanged) {
      yield* _mapEmailChangedToState(event.email);
    } else if (event is PasswordChanged) {
      yield* _mapPasswordChangedToState(event.password);
    } else if (event is LoginWithCredentialsPressed) {
      yield* _mapLoginWithCredentialsPressedToState(
          email: event.email, password: event.password);
    }
  }

  Stream<LoginState> _mapEmailChangedToState(String email) async* {
    yield state.update(
      isEmailValid: Validators.isValidEmail(email),
    );
  }

  Stream<LoginState> _mapPasswordChangedToState(String password) async* {
    yield state.update(isEmailValid: Validators.isValidPassword(password));
  }

  Stream<LoginState> _mapLoginWithCredentialsPressedToState({
    String email,
    String password,
  }) async* {
    yield LoginState.loading();

    try {
      await _userRepository.signInWithEmail(email, password);

      yield LoginState.success();
    } catch (_) {
      LoginState.failure();
    }
  }
}
