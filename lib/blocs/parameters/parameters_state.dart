import 'package:meta/meta.dart';

@immutable
class ParametersState {
  final bool isPhotoEmpty;
  final bool isNameEmpty;
  final bool isAgeEmpty;
  final bool isGenderEmpty;
  final bool isInterestedInEmpty;
  final bool isLocationEmpty;
  final bool isFailure;
  final bool isSubmitting;
  final bool isSuccess;

  bool get isFormValid =>
      isPhotoEmpty &&
      isNameEmpty &&
      isAgeEmpty &&
      isGenderEmpty &&
      isInterestedInEmpty;

  ParametersState({
    @required this.isPhotoEmpty,
    @required this.isNameEmpty,
    @required this.isAgeEmpty,
    @required this.isGenderEmpty,
    @required this.isInterestedInEmpty,
    @required this.isLocationEmpty,
    @required this.isFailure,
    @required this.isSubmitting,
    @required this.isSuccess,
  });

  factory ParametersState.empty() {
    return ParametersState(
      isPhotoEmpty: false,
      isFailure: false,
      isSuccess: false,
      isSubmitting: false,
      isNameEmpty: false,
      isAgeEmpty: false,
      isGenderEmpty: false,
      isInterestedInEmpty: false,
      isLocationEmpty: false,
    );
  }

  factory ParametersState.loading() {
    return ParametersState(
      isPhotoEmpty: false,
      isFailure: false,
      isSuccess: false,
      isSubmitting: true,
      isNameEmpty: false,
      isAgeEmpty: false,
      isGenderEmpty: false,
      isInterestedInEmpty: false,
      isLocationEmpty: false,
    );
  }

  factory ParametersState.failure() {
    return ParametersState(
      isPhotoEmpty: false,
      isFailure: true,
      isSuccess: false,
      isSubmitting: false,
      isNameEmpty: false,
      isAgeEmpty: false,
      isGenderEmpty: false,
      isInterestedInEmpty: false,
      isLocationEmpty: false,
    );
  }

  factory ParametersState.success() {
    return ParametersState(
      isPhotoEmpty: false,
      isFailure: false,
      isSuccess: true,
      isSubmitting: false,
      isNameEmpty: false,
      isAgeEmpty: false,
      isGenderEmpty: false,
      isInterestedInEmpty: false,
      isLocationEmpty: false,
    );
  }

  ParametersState update({
    bool isPhotoEmpty,
    bool isNameEmpty,
    bool isAgeEmpty,
    bool isGenderEmpty,
    bool isInterestedInEmpty,
    bool isLocationEmpty,
  }) {
    return copyWith(
      isFailure: false,
      isSuccess: false,
      isSubmitting: false,
      isPhotoEmpty: isPhotoEmpty,
      isNameEmpty: isNameEmpty,
      isAgeEmpty: isAgeEmpty,
      isGenderEmpty: isGenderEmpty,
      isInterestedInEmpty: isInterestedInEmpty,
      isLocationEmpty: isLocationEmpty,
    );
  }

  ParametersState copyWith({
    bool isPhotoEmpty,
    bool isNameEmpty,
    bool isAgeEmpty,
    bool isGenderEmpty,
    bool isInterestedInEmpty,
    bool isLocationEmpty,
    bool isSubmitting,
    bool isSuccess,
    bool isFailure,
  }) {
    return ParametersState(
      isPhotoEmpty: isPhotoEmpty ?? this.isPhotoEmpty,
      isNameEmpty: isNameEmpty ?? this.isNameEmpty,
      isLocationEmpty: isLocationEmpty ?? this.isLocationEmpty,
      isInterestedInEmpty: isInterestedInEmpty ?? this.isInterestedInEmpty,
      isGenderEmpty: isGenderEmpty ?? this.isGenderEmpty,
      isAgeEmpty: isAgeEmpty ?? this.isAgeEmpty,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
    );
  }
}
