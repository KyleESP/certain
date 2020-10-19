import 'package:certain/helpers/functions.dart';
import 'package:certain/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SearchRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firebaseFirestore;

  SearchRepository(
      {FirebaseAuth firebaseAuth, FirebaseFirestore firebaseFirestore})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  Future<bool> likeUser(currentUserId, selectedUserId, currentUserName,
      currentUserPhotoUrl, selectedUserName, selectedUserPhotoUrl) async {
    var usersCollection = _firebaseFirestore.collection('users');
    var user = usersCollection.doc(currentUserId);
    var selectedUser = usersCollection.doc(selectedUserId);

    var selectedUserLiked = false;
    var userFromSelectedUserLikedList =
        selectedUser.collection('likeList').doc(currentUserId);
    await userFromSelectedUserLikedList.get().then((user) {
      selectedUserLiked = user.exists;
    });

    if (selectedUserLiked) {
      await user.collection('matchList').doc(selectedUserId).set({
        'name': selectedUserName,
        'photoUrl': selectedUserPhotoUrl,
      });
      await selectedUser.collection('matchList').doc(currentUserId).set({
        'name': currentUserName,
        'photoUrl': currentUserPhotoUrl,
      });
      await userFromSelectedUserLikedList.delete();
    } else {
      await user.collection('likeList').doc(selectedUserId).set({});
    }

    await user.collection('notToShowList').doc(selectedUserId).set({});

    return selectedUserLiked;
  }

  dislikeUser(currentUserId, selectedUserId) async {
    var usersCollection = _firebaseFirestore.collection('users');
    var user = usersCollection.doc(currentUserId);
    var selectedUser = usersCollection.doc(selectedUserId);

    await user.collection('dislikeList').doc(selectedUserId).set({});
    await user.collection('notToShowList').doc(selectedUserId).set({});

    await selectedUser.collection('dislikedByList').doc(currentUserId).set({});
    await selectedUser.collection('notToShowList').doc(currentUserId).set({});
  }

  Future getUserInterests(userId) async {
    UserModel currentUser;

    await _firebaseFirestore.collection('users').doc(userId).get().then((user) {
      currentUser = new UserModel();
      var data = user.data();
      currentUser.name = data['name'];
      currentUser.photo = data['photoUrl'];
      currentUser.gender = data['gender'];
      currentUser.interestedIn = data['interestedIn'];
      currentUser.minAge = data['minAge'];
      currentUser.maxAge = data['maxAge'];
      currentUser.maxDistance = data['maxDistance'];
    });

    return currentUser;
  }

  Future<List<UserModel>> getUsersToShow() async {
    List<UserModel> usersToShow = [];
    final uid = _firebaseAuth.currentUser.uid;
    List<String> usersNotToShowList = await _getUsersNotToShowList(uid);
    UserModel currentUser = await getUserInterests(uid);
    var data;
    int userAge;
    int distance;

    await _firebaseFirestore.collection('users').get().then((users) async {
      for (var user in users.docs) {
        data = user.data();
        userAge = (DateTime.now().year - data['birthdate'].toDate().year);
        if (user.id != uid &&
            ["b", currentUser.interestedIn].contains(data["gender"]) &&
            ["b", currentUser.gender].contains(data["interestedIn"]) &&
            !usersNotToShowList.contains(user.id) &&
            userAge >= currentUser.minAge &&
            userAge <= currentUser.maxAge) {
          distance = await getDistance(data['location']);
          if (distance <= currentUser.maxDistance) {
            usersToShow.add(new UserModel(
                uid: user.id,
                name: data['name'],
                photo: data['photoUrl'],
                birthdate: data['birthdate'],
                location: data['location'],
                gender: data['gender'],
                interestedIn: data['interestedIn'],
                distance: distance));
          }
        }
      }
    });

    return usersToShow;
  }

  Future<List> _getUsersNotToShowList(userId) async {
    List<String> usersNotToShowList = [];

    await _firebaseFirestore
        .collection('users')
        .doc(userId)
        .collection('notToShowList')
        .get()
        .then((docs) {
      for (var doc in docs.docs) {
        usersNotToShowList.add(doc.id);
      }
    });

    return usersNotToShowList;
  }
}
