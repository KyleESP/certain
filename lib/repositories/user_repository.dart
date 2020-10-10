import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

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

  Future<bool> userExists(String userId) async {
    bool userExists;
    await _firebaseFirestore.collection('users').doc(userId).get().then((user) {
      userExists = user.exists;
    });

    return userExists;
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

  Future<String> getUser() async {
    return _firebaseAuth.currentUser.uid;
  }

  Future<void> createProfile(
      File photo,
      String userId,
      String name,
      String gender,
      String interestedIn,
      DateTime birthdate,
      GeoPoint location) async {
    StorageUploadTask storageUploadTask;
    storageUploadTask = FirebaseStorage.instance
        .ref()
        .child('userPhotos')
        .child(userId)
        .child(userId)
        .putFile(photo);

    final age = DateTime.now().year - birthdate.year;

    return await storageUploadTask.onComplete.then((ref) async {
      await ref.ref.getDownloadURL().then((url) async {
        await _firebaseFirestore.collection('users').doc(userId).set({
          'uid': userId,
          'photoUrl': url,
          'name': name,
          'location': location,
          'gender': gender,
          'interestedIn': interestedIn,
          'birthdate': birthdate,
          'maxDistance': 30,
          'minAge': age,
          'maxAge': age + 1
        });
      });
    });
  }

  Future update(
      {File photo,
      int maxDistance,
      int minAge,
      int maxAge,
      String interestedIn}) async {
    var params = {};
    final uid = _firebaseAuth.currentUser.uid;
    if (photo != null) {
      StorageUploadTask storageUploadTask;
      storageUploadTask = FirebaseStorage.instance
          .ref()
          .child('userPhotos')
          .child(uid)
          .child(uid)
          .putFile(photo);

      await storageUploadTask.onComplete.then((ref) async {
        await ref.ref.getDownloadURL().then((url) async {
          params = {'photoUrl': url};
        });
      });
    } else if (maxDistance != null) {
      params = {'maxDistance': maxDistance};
    } else if (minAge != null) {
      params = {'minAge': minAge};
    } else if (maxAge != null) {
      params = {'maxAge': maxAge};
    } else if (interestedIn != null) {
      params = {'interestedIn': interestedIn};
    }
    return await _firebaseFirestore.collection('users').doc(uid).update(params);
  }
}
