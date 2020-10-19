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
    } else if (event is LoadSettingsEvent) {
      yield* _mapLoadSettingsToState();
    }
  }

  Stream<SettingsState> _mapLoadUserToState() async* {
    yield LoadingState();
    UserModel user = await _userRepository.getUser();

    yield LoadUserState(user);
  }

  Stream<SettingsState> _mapLoadSettingsToState() async* {
    yield LoadSettingsToState();
  }

  Stream<SettingsState> _mapPhotoChangedToState(File photo) async* {
    try {
      await _userRepository.update(photo: photo);
    } catch (_) {
      yield SettingsState.failure();
    }
  }

  Stream<SettingsState> _mapInterestedInChangedToState(
      String interestedIn) async* {
    try {
      await _userRepository.update(interestedIn: interestedIn);
    } catch (_) {
      yield SettingsState.failure();
    }
  }

  Stream<SettingsState> _mapMaxDistanceChangedToState(
      int maxDistance) async* {
    try {
      await _userRepository.update(maxDistance: maxDistance);
    } catch (_) {
      yield SettingsState.failure();
    }
  }

  Stream<SettingsState> _mapAgeRangeChangedToState(
      int minAge, int maxAge) async* {
    try {
      await _userRepository.update(minAge: minAge, maxAge: maxAge);
    } catch (_) {
      yield SettingsState.failure();
    }
  }
}
