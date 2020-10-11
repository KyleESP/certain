import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class NameChanged extends ProfileEvent {
  final String name;

  NameChanged({@required this.name});

  @override
  List<Object> get props => [name];
}

class PhotoChanged extends ProfileEvent {
  final File photo;

  PhotoChanged({@required this.photo});

  @override
  List<Object> get props => [photo];
}

class BirthdateChanged extends ProfileEvent {
  final DateTime birthdate;

  BirthdateChanged({@required this.birthdate});

  @override
  List<Object> get props => [birthdate];
}

class GenderChanged extends ProfileEvent {
  final String gender;

  GenderChanged({@required this.gender});

  @override
  List<Object> get props => [gender];
}

class InterestedInChanged extends ProfileEvent {
  final String interestedIn;

  InterestedInChanged({@required this.interestedIn});

  @override
  List<Object> get props => [interestedIn];
}

class LocationChanged extends ProfileEvent {
  final GeoPoint location;

  LocationChanged({@required this.location});

  @override
  List<Object> get props => [location];
}

class Submitted extends ProfileEvent {
  final String name, gender, interestedIn;
  final DateTime birthdate;
  final GeoPoint location;
  final File photo;

  Submitted(
      {@required this.name,
      @required this.gender,
      @required this.interestedIn,
      @required this.birthdate,
      @required this.location,
      @required this.photo});

  @override
  List<Object> get props => [location, name, birthdate, gender, interestedIn, photo];
}
