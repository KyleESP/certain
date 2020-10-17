import 'package:certain/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchRepository {
  final FirebaseFirestore _firebaseFirestore;

  SearchRepository({FirebaseFirestore firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

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

    return selectedUserLiked;
  }

  dislikeUser(currentUserId, selectedUserId) async {
    var usersCollection = _firebaseFirestore.collection('users');

    await usersCollection
        .doc(currentUserId)
        .collection('dislikeList')
        .doc(selectedUserId)
        .set({});

    await usersCollection
        .doc(selectedUserId)
        .collection('dislikedByList')
        .doc(currentUserId)
        .set({});

    return getCurrentUser(currentUserId);
  }

  Future getUserInterests(userId) async {
    UserModel currentUser = UserModel();
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

  Future<UserModel> getCurrentUser(userId) async {
    UserModel _user;
    List<String> usersNotToShowList = await _getUsersNotToShowList(userId);
    UserModel currentUser = await getUserInterests(userId);
    var data;

    await _firebaseFirestore.collection('users').get().then((users) {
      for (var user in users.docs) {
        data = user.data();
        if ((!usersNotToShowList.contains(user.id)) &&
            (user.id != userId) &&
            (currentUser.interestedIn == data['gender']) &&
            (data['interestedIn'] == currentUser.gender)) {
          _user = new UserModel();
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

  Future<List> _getUsersNotToShowList(userId) async {
    var usersCollection = _firebaseFirestore.collection('users').doc(userId);
    List<String> usersNotToShowList = [];

    await usersCollection.collection('likeList').get().then((docs) {
      for (var doc in docs.docs) {
        usersNotToShowList.add(doc.id);
      }
    });

    await usersCollection.collection('matchList').get().then((docs) {
      for (var doc in docs.docs) {
        usersNotToShowList.add(doc.id);
      }
    });

    await usersCollection.collection('dislikeList').get().then((docs) {
      for (var doc in docs.docs) {
        usersNotToShowList.add(doc.id);
      }
    });

    await usersCollection.collection('dislikedByList').get().then((docs) {
      for (var doc in docs.docs) {
        usersNotToShowList.add(doc.id);
      }
    });

    return usersNotToShowList;
  }

}
