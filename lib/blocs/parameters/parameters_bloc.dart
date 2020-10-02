import 'dart:async';
import 'dart:io';
import 'bloc.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bloc/bloc.dart';

import 'package:certain/repositories/user_repository.dart';

class ParametersBloc extends Bloc<ParametersEvent, ParametersState> {
  UserRepository _userRepository;

  ParametersBloc(this._userRepository) : super(ParametersState.empty());

  @override
  Stream<ParametersState> mapEventToState(ParametersEvent event) async* {
    if (event is NameChanged) {
      yield* _mapNameChangedToState(event.name);
    } else if (event is AgeChanged) {
      yield* _mapAgeChangedToState(event.age);
    } else if (event is GenderChanged) {
      yield* _mapGenderChangedToState(event.gender);
    } else if (event is InterestedInChanged) {
      yield* _mapInterestedInChangedToState(event.interestedIn);
    } else if (event is LocationChanged) {
      yield* _mapLocationChangedToState(event.location);
    } else if (event is PhotoChanged) {
      yield* _mapPhotoChangedToState(event.photo);
    } else if (event is Submitted) {
      final uid = await _userRepository.getUser();
      yield* _mapSubmittedToState(
          photo: event.photo,
          name: event.name,
          gender: event.gender,
          userId: uid,
          age: event.age,
          location: event.location,
          interestedIn: event.interestedIn);
    }
  }

  Stream<ParametersState> _mapNameChangedToState(String name) async* {
    yield state.update(
      isNameEmpty: name == null,
    );
  }

  Stream<ParametersState> _mapPhotoChangedToState(File photo) async* {
    yield state.update(
      isPhotoEmpty: photo == null,
    );
  }

  Stream<ParametersState> _mapAgeChangedToState(DateTime age) async* {
    yield state.update(
      isAgeEmpty: age == null,
    );
  }

  Stream<ParametersState> _mapGenderChangedToState(String gender) async* {
    yield state.update(
      isGenderEmpty: gender == null,
    );
  }

  Stream<ParametersState> _mapInterestedInChangedToState(
      String interestedIn) async* {
    yield state.update(
      isInterestedInEmpty: interestedIn == null,
    );
  }

  Stream<ParametersState> _mapLocationChangedToState(GeoPoint location) async* {
    yield state.update(
      isLocationEmpty: location == null,
    );
  }

  Stream<ParametersState> _mapSubmittedToState(
      {File photo,
      String gender,
      String name,
      String userId,
      DateTime age,
      GeoPoint location,
      String interestedIn}) async* {
    yield ParametersState.loading();
    try {
      await _userRepository.createProfile(
          photo, userId, name, gender, interestedIn, age, location);
      yield ParametersState.success();
    } catch (_) {
      yield ParametersState.failure();
    }
  }
}
