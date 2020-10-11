import 'dart:async';
import 'dart:io';
import 'bloc.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bloc/bloc.dart';

import 'package:certain/repositories/user_repository.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  UserRepository _userRepository;

  ProfileBloc(this._userRepository) : super(ProfileState.empty());

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    if (event is NameChanged) {
      yield* _mapNameChangedToState(event.name);
    } else if (event is BirthdateChanged) {
      yield* _mapBirthdateChangedToState(event.birthdate);
    } else if (event is GenderChanged) {
      yield* _mapGenderChangedToState(event.gender);
    } else if (event is InterestedInChanged) {
      yield* _mapInterestedInChangedToState(event.interestedIn);
    } else if (event is LocationChanged) {
      yield* _mapLocationChangedToState(event.location);
    } else if (event is PhotoChanged) {
      yield* _mapPhotoChangedToState(event.photo);
    } else if (event is Submitted) {
      final uid = _userRepository.getUserId();
      yield* _mapSubmittedToState(
          photo: event.photo,
          name: event.name,
          gender: event.gender,
          userId: uid,
          birthdate: event.birthdate,
          location: event.location,
          interestedIn: event.interestedIn);
    }
  }

  Stream<ProfileState> _mapNameChangedToState(String name) async* {
    yield state.update(
      isNameEmpty: name == null,
    );
  }

  Stream<ProfileState> _mapPhotoChangedToState(File photo) async* {
    yield state.update(
      isPhotoEmpty: photo == null,
    );
  }

  Stream<ProfileState> _mapBirthdateChangedToState(DateTime birthdate) async* {
    yield state.update(
      isBirthdateEmpty: birthdate == null,
    );
  }

  Stream<ProfileState> _mapGenderChangedToState(String gender) async* {
    yield state.update(
      isGenderEmpty: gender == null,
    );
  }

  Stream<ProfileState> _mapInterestedInChangedToState(
      String interestedIn) async* {
    yield state.update(
      isInterestedInEmpty: interestedIn == null,
    );
  }

  Stream<ProfileState> _mapLocationChangedToState(GeoPoint location) async* {
    yield state.update(
      isLocationEmpty: location == null,
    );
  }

  Stream<ProfileState> _mapSubmittedToState(
      {File photo,
      String gender,
      String name,
      String userId,
      DateTime birthdate,
      GeoPoint location,
      String interestedIn}) async* {
    yield ProfileState.loading();
    try {
      await _userRepository.createProfile(
          photo, userId, name, gender, interestedIn, birthdate, location);
      yield ProfileState.success();
    } catch (_) {
      yield ProfileState.failure();
    }
  }
}
