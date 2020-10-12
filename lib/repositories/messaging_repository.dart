import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

import 'package:certain/models/message.dart';

class MessagingRepository {
  final FirebaseFirestore _firebaseFirestore;
  final FirebaseStorage _firebaseStorage;
  String uuid = Uuid().v4();

  MessagingRepository(
      {FirebaseStorage firebaseStorage, FirebaseFirestore firebaseFirestore})
      : _firebaseStorage = firebaseStorage ?? FirebaseStorage.instance,
        _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  Future sendMessage({Message message}) async {
    StorageUploadTask storageUploadTask;
    DocumentReference messageRef =
        _firebaseFirestore.collection('messages').doc();
    CollectionReference senderRef = _firebaseFirestore
        .collection('users')
        .doc(message.senderId)
        .collection('chats')
        .doc(message.selectedUserId)
        .collection('messages');

    CollectionReference sendUserRef = _firebaseFirestore
        .collection('users')
        .doc(message.selectedUserId)
        .collection('chats')
        .doc(message.senderId)
        .collection('messages');

    if (message.photo != null) {
      StorageReference photoRef = _firebaseStorage
          .ref()
          .child('messages')
          .child(messageRef.id)
          .child(uuid);

      storageUploadTask = photoRef.putFile(message.photo);

      await storageUploadTask.onComplete.then((photo) async {
        await photo.ref.getDownloadURL().then((photoUrl) async {
          await messageRef.set({
            'senderName': message.senderName,
            'senderId': message.senderId,
            'text': null,
            'photoUrl': photoUrl,
            'timestamp': DateTime.now(),
          });
        });
      });

      senderRef.doc(messageRef.id).set({'timestamp': DateTime.now()});

      sendUserRef.doc(messageRef.id).set({'timestamp': DateTime.now()});

      await _firebaseFirestore
          .collection('users')
          .doc(message.senderId)
          .collection('chats')
          .doc(message.selectedUserId)
          .update({'timestamp': DateTime.now()});

      await _firebaseFirestore
          .collection('users')
          .doc(message.selectedUserId)
          .collection('chats')
          .doc(message.senderId)
          .update({'timestamp': DateTime.now()});
    }
    if (message.text != null) {
      await messageRef.set({
        'senderName': message.senderName,
        'senderId': message.senderId,
        'text': message.text,
        'photoUrl': null,
        'timestamp': DateTime.now(),
      });

      senderRef.doc(messageRef.id).set({'timestamp': DateTime.now()});

      sendUserRef.doc(messageRef.id).set({'timestamp': DateTime.now()});

      await _firebaseFirestore
          .collection('users')
          .doc(message.senderId)
          .collection('chats')
          .doc(message.selectedUserId)
          .update({'timestamp': DateTime.now()});

      await _firebaseFirestore
          .collection('users')
          .doc(message.selectedUserId)
          .collection('chats')
          .doc(message.senderId)
          .update({'timestamp': DateTime.now()});
    }
  }

  Stream<QuerySnapshot> getMessages({currentUserId, selectedUserId}) {
    return _firebaseFirestore
        .collection('users')
        .doc(currentUserId)
        .collection('chats')
        .doc(selectedUserId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  Future<Message> getMessageDetail({messageId}) async {
    Message _message = Message();
    var data;

    await _firebaseFirestore
        .collection('messages')
        .doc(messageId)
        .get()
        .then((message) {
      data = message.data;
      _message.senderId = data['senderId'];
      _message.senderName = data['senderName'];
      _message.timestamp = data['timestamp'];
      _message.text = data['text'];
      _message.photoUrl = data['photoUrl'];
    });

    return _message;
  }
}
