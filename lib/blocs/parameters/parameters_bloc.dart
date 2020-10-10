import 'dart:async';
import 'dart:io';
import 'bloc.dart';

import 'package:bloc/bloc.dart';

import 'package:certain/repositories/user_repository.dart';

class ParametersBloc extends Bloc<ParametersEvent, ParametersState> {
  UserRepository _userRepository;

  ParametersBloc(this._userRepository) : super(ParametersInitialState());

  @override
  Stream<ParametersState> mapEventToState(ParametersEvent event) async* {
    if (event is InterestedInChanged) {
      yield* _mapInterestedInChangedToState(event.interestedIn);
    } else if (event is PhotoChanged) {
      yield* _mapPhotoChangedToState(event.photo);
    } else if (event is MaxDistanceChanged) {
      yield* _mapMaxDistanceChangedToState(event.maxDistance);
    } else if (event is MinAgeChanged) {
      yield* _mapMinAgeChangedToState(event.minAge);
    } else if (event is MaxAgeChanged) {
      yield* _mapMaxAgeChangedToState(event.maxAge);
    }
  }

  Stream<ParametersState> _mapPhotoChangedToState(File photo) async* {
    try {
      await _userRepository.update(photo: photo);
    } catch (_) {
      yield ParametersState.failure();
    }
  }

  Stream<ParametersState> _mapInterestedInChangedToState(
      String interestedIn) async* {
    try {
      await _userRepository.update(interestedIn: interestedIn);
    } catch (_) {
      yield ParametersState.failure();
    }
  }

  Stream<ParametersState> _mapMaxDistanceChangedToState(
      int maxDistance) async* {
    try {
      await _userRepository.update(maxDistance: maxDistance);
    } catch (_) {
      yield ParametersState.failure();
    }
  }

  Stream<ParametersState> _mapMinAgeChangedToState(int minAge) async* {
    try {
      await _userRepository.update(minAge: minAge);
    } catch (_) {
      yield ParametersState.failure();
    }
  }

  Stream<ParametersState> _mapMaxAgeChangedToState(int maxAge) async* {
    try {
      await _userRepository.update(maxAge: maxAge);
    } catch (_) {
      yield ParametersState.failure();
    }
  }
}
