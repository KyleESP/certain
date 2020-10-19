import 'dart:async';
import 'dart:io';
import 'package:certain/models/user_model.dart';

import 'bloc.dart';

import 'package:bloc/bloc.dart';

import 'package:certain/repositories/user_repository.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  UserRepository _userRepository;

  SettingsBloc(this._userRepository) : super(SettingsInitialState());

  @override
  Stream<SettingsState> mapEventToState(SettingsEvent event) async* {
    if (event is InterestedInChanged) {
      yield* _mapInterestedInChangedToState(event.interestedIn);
    } else if (event is PhotoChanged) {
      yield* _mapPhotoChangedToState(event.photo);
    } else if (event is MaxDistanceChanged) {
      yield* _mapMaxDistanceChangedToState(event.maxDistance);
    } else if (event is AgeRangeChanged) {
      yield* _mapAgeRangeChangedToState(event.minAge, event.maxAge);
    } else if (event is LoadUserEvent) {
      yield* _mapLoadUserToState();
    }
  }

  Stream<SettingsState> _mapLoadUserToState() async* {
    yield LoadingState();
    UserModel user = await _userRepository.getUser();

    yield LoadUserState(user);
  }

  Stream<SettingsState> _mapPhotoChangedToState(File photo) async* {
    yield SettingsState.submitting();

    try {
      await _userRepository.update(photo: photo);

      yield SettingsState.success();
    } catch (_) {
      yield SettingsState.failure();
    }
  }

  Stream<SettingsState> _mapInterestedInChangedToState(
      String interestedIn) async* {
    yield SettingsState.submitting();

    try {
      await _userRepository.update(interestedIn: interestedIn);

      yield SettingsState.success();
    } catch (_) {
      yield SettingsState.failure();
    }
  }

  Stream<SettingsState> _mapMaxDistanceChangedToState(int maxDistance) async* {
    yield SettingsState.submitting();

    try {
      await _userRepository.update(maxDistance: maxDistance);

      yield SettingsState.success();
    } catch (_) {
      yield SettingsState.failure();
    }
  }

  Stream<SettingsState> _mapAgeRangeChangedToState(
      int minAge, int maxAge) async* {
    yield SettingsState.submitting();

    try {
      await _userRepository.update(minAge: minAge, maxAge: maxAge);

      yield SettingsState.success();
    } catch (_) {
      yield SettingsState.failure();
    }
  }
}
