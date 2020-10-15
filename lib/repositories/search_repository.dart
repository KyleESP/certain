import 'package:certain/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchRepository {
  final FirebaseFirestore _firebaseFirestore;

  SearchRepository({FirebaseFirestore firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  Future<User> likeUser(currentUserId, selectedUserId) async {
    var usersCollection = _firebaseFirestore.collection('users');
    var user = usersCollection.doc(currentUserId);
    var selectedUser = usersCollection.doc(selectedUserId);

    await user.collection('likeList').doc(selectedUserId).set({});

    var selectedUserLiked = false;
    await selectedUser
        .collection('likeList')
        .doc(currentUserId)
        .get()
        .then((value) {
      selectedUserLiked = value.exists;
    });

    if (selectedUserLiked) {
      await user.collection('matchList').doc(selectedUserId).set({});

      await _firebaseFirestore
          .collection('users')
          .doc(selectedUserId)
          .collection('matchList')
          .doc(currentUserId)
          .set({});
    }

    return getUser(currentUserId);
  }

  passUser(currentUserId, selectedUserId) async {
    await _firebaseFirestore
        .collection('users')
        .doc(selectedUserId)
        .collection('likeList')
        .doc(currentUserId)
        .set({});

    await _firebaseFirestore
        .collection('users')
        .doc(currentUserId)
        .collection('likeList')
        .doc(selectedUserId)
        .set({});
    return getUser(currentUserId);
  }

  Future getUserInterests(userId) async {
    User currentUser = User();
    var data;

    await _firebaseFirestore.collection('users').doc(userId).get().then((user) {
      data = user.data();
      currentUser.name = data['name'];
      currentUser.photo = data['photoUrl'];
      currentUser.gender = data['gender'];
      currentUser.interestedIn = data['interestedIn'];
    });

    return currentUser;
  }

  Future<List> getLikeList(userId) async {
    List<String> likeList = [];
    await _firebaseFirestore
        .collection('users')
        .doc(userId)
        .collection('likeList')
        .get()
        .then((docs) {
      for (var doc in docs.docs) {
        if (docs.docs != null) {
          likeList.add(doc.id);
        }
      }
    });
    return likeList;
  }

  Future<User> getUser(userId) async {
    User _user = User();
    List<String> likeList = await getLikeList(userId);
    User currentUser = await getUserInterests(userId);
    var data;

    await _firebaseFirestore.collection('users').get().then((users) {
      for (var user in users.docs) {
        data = user.data();
        if ((!likeList.contains(user.id)) &&
            (user.id != userId) &&
            (currentUser.interestedIn == data['gender']) &&
            (data['interestedIn'] == currentUser.gender)) {
          _user.uid = user.id;
          _user.name = data['name'];
          _user.photo = data['photoUrl'];
          _user.birthdate = data['birthdate'];
          _user.location = data['location'];
          _user.gender = data['gender'];
          _user.interestedIn = data['interestedIn'];
          break;
        }
      }
    });

    return _user;
  }
}
