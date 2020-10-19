import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class ParametersEvent extends Equatable {
  const ParametersEvent();

  @override
  List<Object> get props => [];
}

class LoadUserEvent extends ParametersEvent {
  final String userId;

  LoadUserEvent({this.userId});

  @override
  List<Object> get props => [userId];
}

class LoadParametersEvent extends ParametersEvent {
  LoadParametersEvent();

  @override
  List<Object> get props => [];
}

class PhotoChanged extends ParametersEvent {
  final File photo;

  PhotoChanged({@required this.photo});

  @override
  List<Object> get props => [photo];
}

class InterestedInChanged extends ParametersEvent {
  final String interestedIn;

  InterestedInChanged({@required this.interestedIn});

  @override
  List<Object> get props => [interestedIn];
}

class MaxDistanceChanged extends ParametersEvent {
  final int maxDistance;

  MaxDistanceChanged({@required this.maxDistance});

  @override
  List<Object> get props => [maxDistance];
}

class AgeRangeChanged extends ParametersEvent {
  final int minAge;
  final int maxAge;

  AgeRangeChanged({@required this.minAge, @required this.maxAge});

  @override
  List<Object> get props => [minAge, maxAge];
}
