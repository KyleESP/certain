import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  String senderName, senderId, selectedUserId, text, photoUrl;
  File photo;
  Timestamp timestamp;

  MessageModel(
      {this.senderName,
      this.senderId,
      this.selectedUserId,
      this.text,
      this.photoUrl,
      this.photo,
      this.timestamp});
}
