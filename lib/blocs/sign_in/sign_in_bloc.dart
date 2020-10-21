import 'dart:async';

import 'bloc.dart';

import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';

import 'package:certain/repositories/user_repository.dart';

import 'package:certain/helpers/validators.dart';
import 'package:certain/helpers/error_messages.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  UserRepository _userRepository;

  SignInBloc(this._userRepository) : super(SignInState.empty());

  @override
  Stream<Transition<SignInEvent, SignInState>> transformEvents(
    Stream<SignInEvent> events,
    Stream<Transition<SignInEvent, SignInState>> Function(SignInEvent event) next,
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
  Stream<SignInState> mapEventToState(
    SignInEvent event,
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

  Stream<SignInState> _mapEmailChangedToState(String email) async* {
    yield state.update(
      isEmailValid: Validators.isValidEmail(email),
    );
  }

  Stream<SignInState> _mapPasswordChangedToState(String password) async* {
    yield state.update(isEmailValid: Validators.isValidPassword(password));
  }

  Stream<SignInState> _mapLoginWithCredentialsPressedToState({
    String email,
    String password,
  }) async* {
    yield SignInState.loading();

    try {
      await _userRepository.signInWithEmail(email, password);

      yield SignInState.success();
    } catch (e) {
      var errorMessage = firebaseErrors[e.code] ?? e.message;
      yield SignInState.failure(errorMessage);
    }
  }
}
