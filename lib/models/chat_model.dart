import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  String name, photoUrl, lastMessagePhoto, lastMessage;
  Timestamp timestamp;

  ChatModel(
      {this.name,
      this.photoUrl,
      this.lastMessagePhoto,
      this.lastMessage,
      this.timestamp});
}
