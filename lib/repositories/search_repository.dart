import 'package:certain/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchRepository {
  final FirebaseFirestore _firebaseFirestore;

  SearchRepository({FirebaseFirestore firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  Future<User> chooseUser(currentUserId, selectedUserId, name, photoUrl) async {
    await _firebaseFirestore
        .collection('users')
        .doc(currentUserId)
        .collection('chosenList')
        .doc(selectedUserId)
        .set({});

    await _firebaseFirestore
        .collection('users')
        .doc(selectedUserId)
        .collection('selectedList')
        .doc(currentUserId)
        .set({'name': name, 'photoUrl': photoUrl});
    return getUser(currentUserId);
  }

  passUser(currentUserId, selectedUserId) async {
    await _firebaseFirestore
        .collection('users')
        .doc(selectedUserId)
        .collection('chosenList')
        .doc(currentUserId)
        .set({});

    await _firebaseFirestore
        .collection('users')
        .doc(currentUserId)
        .collection('chosenList')
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

  Future<List> getChosenList(userId) async {
    List<String> chosenList = [];
    await _firebaseFirestore
        .collection('users')
        .doc(userId)
        .collection('chosenList')
        .get()
        .then((docs) {
      for (var doc in docs.docs) {
        if (docs.docs != null) {
          chosenList.add(doc.id);
        }
      }
    });
    return chosenList;
  }

  Future<User> getUser(userId) async {
    User _user = User();
    List<String> chosenList = await getChosenList(userId);
    User currentUser = await getUserInterests(userId);
    var data;

    await _firebaseFirestore.collection('users').get().then((users) {
      for (var user in users.docs) {
        data = user.data();
        if ((!chosenList.contains(user.id)) &&
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
