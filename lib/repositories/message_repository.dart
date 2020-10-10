import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:certain/models/message.dart';
import 'package:certain/models/user.dart';

class MessageRepository {
  final FirebaseFirestore _firebaseFirestore;

  MessageRepository({FirebaseFirestore firestore})
      : _firebaseFirestore = firestore ?? FirebaseFirestore.instance;

  Stream<QuerySnapshot> getChats({userId}) {
    return _firebaseFirestore
        .collection('users')
        .doc(userId)
        .collection('chats')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future deleteChat({currentUserId, selectedUserId}) async {
    await _firebaseFirestore
        .collection('users')
        .doc(currentUserId)
        .collection('chats')
        .doc(selectedUserId)
        .delete();
  }

  Future<User> getUserDetail({userId}) async {
    User _user = User();

    await _firebaseFirestore.collection('users').doc(userId).get().then((user) {
      _user.uid = user.id;
      _user.name = user.data()['name'];
      _user.photo = user.data()['photoUrl'];
      _user.birthdate = user.data()['birthdate'];
      _user.location = user.data()['location'];
      _user.gender = user.data()['gender'];
      _user.interestedIn = user.data()['interestedIn'];
    });
    return _user;
  }

  Future<Message> getLastMessage({currentUserId, selectedUserId}) async {
    Message _message = Message();

    await _firebaseFirestore
        .collection('users')
        .doc(currentUserId)
        .collection('chats')
        .doc(selectedUserId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .first
        .then((doc) async {
      await _firebaseFirestore
          .collection('messages')
          .doc(doc.docs.first.id)
          .get()
          .then((message) {
        _message.text = message.data()['text'];
        _message.photoUrl = message.data()['photoUrl'];
        _message.timestamp = message.data()['timestamp'];
      });
    });

    return _message;
  }
}
