import 'package:certain/models/message.dart';
import 'package:certain/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageRepository {
  final FirebaseFirestore _firestore;

  MessageRepository({FirebaseFirestore firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Stream<QuerySnapshot> getChats({userId}) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('chats')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future deleteChat({currentUserId, selectedUserId}) async {
    await _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('chats')
        .doc(selectedUserId)
        .delete();
  }

  Future<User> getUserDetail({userId}) async {
    User _user = User();

    await _firestore.collection('users').doc(userId).get().then((user) {
      _user.uid = user.documentID;
      _user.name = user.data()['name'];
      _user.age = user.data()['age'];
      _user.gender = user.data()['gender'];
      _user.interestedIn = user.data()['interestedIn'];
      _user.profilePic = user.data()['profilePicUrl'];
      _user.location = user.data()['location'];
    });
    return _user;
  }

  Future<Message> getLastMessage({currentUserId, selectedUserId}) async {
    Message _message = Message();

    await _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('chats')
        .doc(selectedUserId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .first
        .then((doc) async {
      await _firestore
          .collection('messages')
          .doc(doc.documents.first.documentID)
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
