import 'dart:io';

import 'package:certain/helpers/functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:certain/models/user_model.dart';

class UserRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firebaseFirestore;

  UserRepository(
      {FirebaseAuth firebaseAuth, FirebaseFirestore firebaseFirestore})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  Future<void> signUpWithEmailAndPassword(String email, String password) async {
    return await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  Future<bool> userExists() async {
    bool userExists = false;
    await _firebaseFirestore
        .collection('users')
        .doc(_firebaseAuth.currentUser.uid)
        .get()
        .then((user) {
      userExists = user.exists;
    });

    return userExists;
  }

  Future<bool> userMcqExists() async {
    bool mcqExists = false;
    await _firebaseFirestore
        .collection('users')
        .doc(_firebaseAuth.currentUser.uid)
        .get()
        .then((user) {
      mcqExists = user.data().containsKey('mcq');
    });

    return mcqExists;
  }

  Future<void> signInWithEmail(String email, String password) {
    return _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<bool> isSignedIn() async {
    return _firebaseAuth.currentUser != null;
  }

  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }

  Future<UserModel> getUser() async {
    UserModel _user = UserModel();

    await _firebaseFirestore
        .collection('users')
        .doc(_firebaseAuth.currentUser.uid)
        .get()
        .then((user) {
      var data = user.data();
      _user.uid = user.id;
      _user.name = data['name'];
      _user.photo = data['photoUrl'];
      _user.birthdate = data['birthdate'];
      _user.location = data['location'];
      _user.gender = data['gender'];
      _user.interestedIn = data['interestedIn'];
      _user.maxDistance = data['maxDistance'];
      _user.minAge = data['minAge'];
      _user.maxAge = data['maxAge'];
      _user.bio = data['bio'];
    });

    return _user;
  }

  String getUserId() {
    return _firebaseAuth.currentUser.uid;
  }

  Future<void> createProfile(File photo, String name, String gender,
      String interestedIn, DateTime birthdate, GeoPoint location) async {
    final uid = _firebaseAuth.currentUser.uid;
    StorageUploadTask storageUploadTask;
    storageUploadTask = FirebaseStorage.instance
        .ref()
        .child('user_photos')
        .child(uid)
        .child(uid)
        .putFile(photo);

    final age = calculateAge(birthdate);

    return await storageUploadTask.onComplete.then((ref) async {
      await ref.ref.getDownloadURL().then((url) async {
        await _firebaseFirestore.collection('users').doc(uid).set({
          'uid': uid,
          'photoUrl': url,
          'name': name,
          'location': location,
          'gender': gender,
          'interestedIn': interestedIn,
          'birthdate': birthdate,
          'maxDistance': 30,
          'minAge': age - ((age - 18) >= 2 ? 2 : age - 18),
          'maxAge': age + ((55 - age) >= 2 ? 2 : 55 - age),
          'bio': ''
        });
      });
    });
  }

  Future update(
      {File photo,
      int maxDistance,
      int minAge,
      int maxAge,
      String interestedIn,
      String bio}) async {
    Map<String, dynamic> params = {};
    final uid = _firebaseAuth.currentUser.uid;
    if (photo != null) {
      StorageUploadTask storageUploadTask;
      storageUploadTask = FirebaseStorage.instance
          .ref()
          .child('user_photos')
          .child(uid)
          .child(uid)
          .putFile(photo);

      await storageUploadTask.onComplete.then((ref) async {
        await ref.ref.getDownloadURL().then((url) async {
          params['photoUrl'] = url;
        });
      });
    }
    if (maxDistance != null) {
      params['maxDistance'] = maxDistance;
    }
    if (minAge != null) {
      params['minAge'] = minAge;
    }
    if (maxAge != null) {
      params['maxAge'] = maxAge;
    }
    if (interestedIn != null) {
      params['interestedIn'] = interestedIn;
    }
    if (bio != null) {
      params['bio'] = bio;
    }
    return await _firebaseFirestore.collection('users').doc(uid).update(params);
  }
}
