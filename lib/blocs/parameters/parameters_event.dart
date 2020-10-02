import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class ParametersEvent extends Equatable {
  const ParametersEvent();

  @override
  List<Object> get props => [];
}

class NameChanged extends ParametersEvent {
  final String name;

  NameChanged({@required this.name});

  @override
  List<Object> get props => [name];
}

class PhotoChanged extends ParametersEvent {
  final File photo;

  PhotoChanged({@required this.photo});

  @override
  List<Object> get props => [photo];
}

class AgeChanged extends ParametersEvent {
  final DateTime age;

  AgeChanged({@required this.age});

  @override
  List<Object> get props => [age];
}

class GenderChanged extends ParametersEvent {
  final String gender;

  GenderChanged({@required this.gender});

  @override
  List<Object> get props => [gender];
}

class InterestedInChanged extends ParametersEvent {
  final String interestedIn;

  InterestedInChanged({@required this.interestedIn});

  @override
  List<Object> get props => [interestedIn];
}

class LocationChanged extends ParametersEvent {
  final GeoPoint location;

  LocationChanged({@required this.location});

  @override
  List<Object> get props => [location];
}

class Submitted extends ParametersEvent {
  final String name, gender, interestedIn;
  final DateTime age;
  final GeoPoint location;
  final File photo;

  Submitted(
      {@required this.name,
      @required this.gender,
      @required this.interestedIn,
      @required this.age,
      @required this.location,
      @required this.photo});

  @override
  List<Object> get props => [location, name, age, gender, interestedIn, photo];
}
