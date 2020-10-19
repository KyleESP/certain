import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

class LoadUserEvent extends SettingsEvent {
  final String userId;

  LoadUserEvent({this.userId});

  @override
  List<Object> get props => [userId];
}

class PhotoChanged extends SettingsEvent {
  final File photo;

  PhotoChanged({@required this.photo});

  @override
  List<Object> get props => [photo];
}

class InterestedInChanged extends SettingsEvent {
  final String interestedIn;

  InterestedInChanged({@required this.interestedIn});

  @override
  List<Object> get props => [interestedIn];
}

class MaxDistanceChanged extends SettingsEvent {
  final int maxDistance;

  MaxDistanceChanged({@required this.maxDistance});

  @override
  List<Object> get props => [maxDistance];
}

class AgeRangeChanged extends SettingsEvent {
  final int minAge;
  final int maxAge;

  AgeRangeChanged({@required this.minAge, @required this.maxAge});

  @override
  List<Object> get props => [minAge, maxAge];
}
