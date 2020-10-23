import 'package:certain/helpers/functions.dart';
import 'package:certain/models/question_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String uid;
  String name;
  String gender;
  String interestedIn;
  String photo;
  Timestamp birthdate;
  GeoPoint location;
  int maxDistance;
  int minAge;
  int maxAge;
  double distance;
  String bio;
  List<QuestionModel> mcq;

  int get age => calculateAge(birthdate.toDate());

  UserModel(
      {this.uid,
      this.name,
      this.gender,
      this.interestedIn,
      this.photo,
      this.birthdate,
      this.location,
      this.maxDistance,
      this.minAge,
      this.maxAge,
      this.distance,
      this.bio,
      this.mcq});
}
