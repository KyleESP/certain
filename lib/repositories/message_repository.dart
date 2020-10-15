import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:certain/models/message.dart';
import 'package:certain/models/my_user.dart';

class MessageRepository {
  final FirebaseFirestore _firebaseFirestore;

  MessageRepository({FirebaseFirestore firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

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

  Future<MyUser> getUserDetail({userId}) async {
    MyUser _user = MyUser();
    var data;

    await _firebaseFirestore.collection('users').doc(userId).get().then((user) {
      data = user.data();
      _user.uid = user.id;
      _user.name = data['name'];
      _user.photo = data['photoUrl'];
      _user.birthdate = data['birthdate'];
      _user.location = data['location'];
      _user.gender = data['gender'];
      _user.interestedIn = data['interestedIn'];
    });
    return _user;
  }

  Future<Message> getLastMessage({currentUserId, selectedUserId}) async {
    Message _message = Message();
    var data;

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
        data = message.data();
        _message.text = data['text'];
        _message.photoUrl = data['photoUrl'];
        _message.timestamp = data['timestamp'];
      });
    });

    return _message;
  }
}
