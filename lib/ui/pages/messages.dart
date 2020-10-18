import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:certain/blocs/message/bloc.dart';

import 'package:certain/models/chat_model.dart';
import 'package:certain/models/message_model.dart';
import 'package:certain/models/user_model.dart';
import 'package:certain/repositories/message_repository.dart';

import 'package:certain/ui/pages/messaging.dart';
import 'package:certain/ui/widgets/photo_widget.dart';

class Messages extends StatefulWidget {
  final String userId;

  Messages({this.userId});

  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  MessageRepository _messagesRepository = MessageRepository();
  MessageBloc _messageBloc;

  @override
  void initState() {
    _messageBloc = MessageBloc(_messagesRepository);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MessageBloc, MessageState>(
      cubit: _messageBloc,
      builder: (BuildContext context, MessageState state) {
        if (state is MessageInitialState) {
          _messageBloc.add(ChatStreamEvent(currentUserId: widget.userId));
        }
        if (state is ChatLoadingState) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is ChatLoadedState) {
          Stream<QuerySnapshot> chatStream = state.chatStream;

          return StreamBuilder<QuerySnapshot>(
            stream: chatStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Text("No data");
              }

              if (snapshot.data.docs.isNotEmpty) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ChatWidget(
                        creationTime:
                            snapshot.data.docs[index].data()['timestamp'],
                        userId: widget.userId,
                        selectedUserId: snapshot.data.docs[index].id,
                      );
                    },
                  );
                }
              } else
                return Text(
                  "Tu n'a aucune conversation.",
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                );
            },
          );
        }
        return Container();
      },
    );
  }
}

class ChatWidget extends StatefulWidget {
  final String userId, selectedUserId;
  final Timestamp creationTime;

  const ChatWidget({this.userId, this.selectedUserId, this.creationTime});

  @override
  _ChatWidgetState createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  MessageRepository messageRepository = MessageRepository();
  ChatModel chat;
  UserModel user;

  getUserDetail() async {
    user = await messageRepository.getUserDetail(userId: widget.selectedUserId);
    MessageModel message = await messageRepository
        .getLastMessage(
            currentUserId: widget.userId, selectedUserId: widget.selectedUserId)
        .catchError((error) {
      print(error);
    });

    if (message == null) {
      return ChatModel(
        name: user.name,
        photoUrl: user.photo,
        lastMessage: null,
        lastMessagePhoto: null,
        timestamp: null,
      );
    } else {
      return ChatModel(
        name: user.name,
        photoUrl: user.photo,
        lastMessage: message.text,
        lastMessagePhoto: message.photoUrl,
        timestamp: message.timestamp,
      );
    }
  }

  openChat() async {
    UserModel currentUser =
        await messageRepository.getUserDetail(userId: widget.userId);
    UserModel selectedUser =
        await messageRepository.getUserDetail(userId: widget.selectedUserId);

    try {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return Messaging(
                currentUser: currentUser, selectedUser: selectedUser);
          },
        ),
      );
    } catch (e) {
      print(e.toString());
    }
  }

  deleteChat() async {
    await messageRepository.deleteChat(
        currentUserId: widget.userId, selectedUserId: widget.selectedUserId);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return FutureBuilder(
      future: getUserDetail(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        } else {
          ChatModel chat = snapshot.data;
          return GestureDetector(
            onTap: () async {
              await openChat();
            },
            onLongPress: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                        content: Wrap(
                          children: <Widget>[
                            Text(
                              "Do you want to delete this chat",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "This action is irreversible.",
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        actions: <Widget>[
                          FlatButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              "No",
                              style: TextStyle(
                                color: Colors.blue,
                              ),
                            ),
                          ),
                          FlatButton(
                            onPressed: () async {
                              await deleteChat();
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              "Yes",
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ],
                      ));
            },
            child: Padding(
              padding: EdgeInsets.all(size.height * 0.02),
              child: Container(
                width: size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(size.height * 0.02),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        ClipOval(
                          child: Container(
                            height: size.height * 0.06,
                            width: size.height * 0.06,
                            child: PhotoWidget(
                              photoLink: user.photo,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: size.width * 0.02,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              user.name,
                              style: TextStyle(fontSize: size.height * 0.03),
                            ),
                            chat.lastMessage != null
                                ? Text(
                                    chat.lastMessage,
                                    overflow: TextOverflow.fade,
                                    style: TextStyle(color: Colors.grey),
                                  )
                                : chat.lastMessagePhoto == null
                                    ? Text("Chat Room Open")
                                    : Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.photo,
                                            color: Colors.grey,
                                            size: size.height * 0.02,
                                          ),
                                          Text(
                                            "Photo",
                                            style: TextStyle(
                                              fontSize: size.height * 0.015,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                          ],
                        ),
                      ],
                    ),
                    Text(timeago.format(chat.timestamp != null
                        ? chat.timestamp.toDate()
                        : widget.creationTime.toDate()))
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
