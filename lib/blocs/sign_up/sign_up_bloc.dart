import 'dart:async';
import 'bloc.dart';

import 'package:rxdart/rxdart.dart';

import 'package:bloc/bloc.dart';

import 'package:certain/repositories/user_repository.dart';

import 'package:certain/helpers/validators.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  UserRepository _userRepository;

  SignUpBloc(this._userRepository) : super(SignUpState.empty());

  @override
  Stream<Transition<SignUpEvent, SignUpState>> transformEvents(
    Stream<SignUpEvent> events,
    Stream<Transition<SignUpEvent, SignUpState>> Function(SignUpEvent event)
        next,
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
  Stream<SignUpState> mapEventToState(
    SignUpEvent event,
  ) async* {
    if (event is EmailChanged) {
      yield* _mapEmailChangedToState(event.email);
    } else if (event is PasswordChanged) {
      yield* _mapPasswordChangedToState(event.password);
    } else if (event is SignUpWithCredentialsPressed) {
      yield* _mapSignUpWithCredentialsPressedToState(
          email: event.email, password: event.password);
    }
  }

  Stream<SignUpState> _mapEmailChangedToState(String email) async* {
    yield state.update(
      isEmailValid: Validators.isValidEmail(email),
    );
  }

  Stream<SignUpState> _mapPasswordChangedToState(String password) async* {
    yield state.update(isEmailValid: Validators.isValidPassword(password));
  }

  Stream<SignUpState> _mapSignUpWithCredentialsPressedToState({
    String email,
    String password,
  }) async* {
    yield SignUpState.loading();

    try {
      await _userRepository.signUpWithEmailAndPassword(email, password);

      yield SignUpState.success();
    } catch (_) {
      SignUpState.failure();
    }
  }
}
