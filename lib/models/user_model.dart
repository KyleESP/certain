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
      this.maxAge});
}
