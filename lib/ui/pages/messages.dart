import 'package:certain/ui/widgets/loader_widget.dart';
import 'package:certain/helpers/constants.dart';
import 'package:certain/helpers/functions.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:certain/blocs/message/bloc.dart';
import 'package:certain/blocs/messaging/bloc.dart';
import 'package:certain/blocs/messaging/messaging_bloc.dart';

import 'package:certain/models/chat_model.dart';
import 'package:certain/models/message_model.dart';
import 'package:certain/models/user_model.dart';
import 'package:certain/repositories/message_repository.dart';
import 'package:certain/repositories/messaging_repository.dart';

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
    Size size = MediaQuery.of(context).size;
    return BlocBuilder<MessageBloc, MessageState>(
      cubit: _messageBloc,
      builder: (BuildContext context, MessageState state) {
        if (state is MessageInitialState) {
          _messageBloc.add(ChatStreamEvent(currentUserId: widget.userId));
        }
        if (state is ChatLoadingState) {
          return loaderWidget();
        }
        if (state is ChatLoadedState) {
          Stream<QuerySnapshot> chatStream = state.chatStream;

          return StreamBuilder<QuerySnapshot>(
            stream: chatStream,
            builder: (context, snapshot) {
              return Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Positioned(
                    top: 0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.elliptical(200.0, 80.0),
                          bottomRight: Radius.elliptical(200.0, 80.0)),
                      child: Container(
                        height: size.height * 0.2,
                        width: size.width,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          gradient: gradient,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: size.height * 0.1,
                    child: Text(
                      "Messages",
                      style: TextStyle(
                          color: Colors.white, fontSize: size.width * 0.06),
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(top: size.height * 0.2),
                      child: (() {
                        if (snapshot.hasData && snapshot.data.docs.isNotEmpty) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return loaderWidget();
                          } else {
                            return ListView.separated(
                              scrollDirection: Axis.vertical,
                              itemCount: snapshot.data.docs.length,
                              itemBuilder: (BuildContext context, int index) {
                                return ChatWidget(
                                  creationTime: snapshot.data.docs[index]
                                      .data()['timestamp'],
                                  userId: widget.userId,
                                  selectedUserId: snapshot.data.docs[index].id,
                                );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) =>
                                      const Divider(),
                            );
                          }
                        }
                      }())),
                  if (!snapshot.hasData || snapshot.data.docs.isEmpty)
                    Text(
                      "Vous n'avez aucune conversation.",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: size.height * 0.023,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                ],
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

    return ChatModel(
      name: user.name,
      photoUrl: user.photo,
      lastMessage: message?.text,
      lastMessagePhoto: message?.photoUrl,
      timestamp: message?.timestamp,
    );
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
                              "Voulez-vous supprimer ce chat ?",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Cette action est irreversible.",
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
                              "Non",
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
                              "Oui",
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
                    Expanded(
                      child: Stack(
                        children: <Widget>[
                          ClipOval(
                            child: Container(
                              height: size.width * 0.13,
                              width: size.width * 0.13,
                              child: PhotoWidget(
                                photoLink: user.photo,
                              ),
                            ),
                          ),
                          Positioned(
                            left: size.width * 0.15,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  user.name,
                                  style: TextStyle(
                                      fontSize: size.height * 0.03,
                                      color: Colors.black54),
                                ),
                                chat.lastMessage != null
                                    ? Text(
                                        chat.lastMessage,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: Colors.grey),
                                      )
                                    : chat.lastMessagePhoto == null
                                        ? Text(
                                            "Commencez la discussion",
                                            overflow: TextOverflow.ellipsis,
                                            style:
                                                TextStyle(color: Colors.grey),
                                          )
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
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.03,
                    ),
                    Text(
                      readTimestamp(
                          chat.timestamp != null
                              ? chat.timestamp.toDate()
                              : widget.creationTime.toDate(),
                          false),
                      style: TextStyle(
                          fontSize: size.height * 0.018, color: Colors.black54),
                    )
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

class Messaging extends StatefulWidget {
  final UserModel currentUser, selectedUser;

  const Messaging({this.currentUser, this.selectedUser});

  @override
  _MessagingState createState() => _MessagingState();
}

class _MessagingState extends State<Messaging> {
  TextEditingController _messageTextController = TextEditingController();
  MessagingRepository _messagingRepository = MessagingRepository();
  MessagingBloc _messagingBloc;
  bool isValid = false;

  @override
  void initState() {
    super.initState();
    _messagingBloc = MessagingBloc(_messagingRepository);

    _messageTextController.text = '';
    _messageTextController.addListener(() {
      setState(() {
        isValid = _messageTextController.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _messageTextController.dispose();
    super.dispose();
  }

  void _onFormSubmitted() {
    _messagingBloc.add(
      SendMessageEvent(
        message: MessageModel(
          text: _messageTextController.text,
          senderId: widget.currentUser.uid,
          senderName: widget.currentUser.name,
          selectedUserId: widget.selectedUser.uid,
          photo: null,
        ),
      ),
    );
    _messageTextController.clear();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        //backgroundColor: Colors.pinkAccent,
        flexibleSpace:
            Container(decoration: BoxDecoration(gradient: gradientReverse)),
        elevation: size.height * 0.02,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            ClipOval(
              child: Container(
                height: size.height * 0.06,
                width: size.height * 0.06,
                child: PhotoWidget(
                  photoLink: widget.selectedUser.photo,
                ),
              ),
            ),
            SizedBox(
              width: size.width * 0.03,
            ),
            Expanded(
              child: Text(widget.selectedUser.name),
            ),
          ],
        ),
      ),
      body: BlocBuilder<MessagingBloc, MessagingState>(
        cubit: _messagingBloc,
        builder: (BuildContext context, MessagingState state) {
          if (state is MessagingInitialState) {
            _messagingBloc.add(
              MessageStreamEvent(
                  currentUserId: widget.currentUser.uid,
                  selectedUserId: widget.selectedUser.uid),
            );
          }
          if (state is MessagingLoadingState) {
            return loaderWidget();
          }
          if (state is MessagingLoadedState) {
            Stream<QuerySnapshot> messageStream = state.messageStream;

            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                StreamBuilder<QuerySnapshot>(
                  stream: messageStream,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
                      return Container(
                          margin: EdgeInsets.only(top: size.height * 0.05),
                          child: Text(
                            "Commencez la conversation ?",
                            style: TextStyle(
                              fontSize: size.height * 0.02,
                              color: Colors.grey[600],
                            ),
                          ));
                    } else {
                      return Expanded(
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemBuilder: (BuildContext context, int index) {
                                  return MessageWidget(
                                    currentUserId: widget.currentUser.uid,
                                    messageId: snapshot.data.docs[index].id,
                                  );
                                },
                                itemCount: snapshot.data.docs.length,
                              ),
                            )
                          ],
                        ),
                      );
                    }
                  },
                ),
                Container(
                  width: size.width,
                  height: size.height * 0.08,
                  color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          height: size.height * 0.05,
                          margin: EdgeInsets.only(left: size.width * 0.1),
                          padding: EdgeInsets.all(size.height * 0.01),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Center(
                            child: TextField(
                              controller: _messageTextController,
                              textInputAction: TextInputAction.send,
                              maxLines: null,
                              decoration: InputDecoration(
                                //filled: true,
                                fillColor: Colors.white,
                                hintText: 'Écrivez votre message...',
                                contentPadding: const EdgeInsets.only(
                                    left: 14.0,
                                    bottom: 0.0,
                                    top: 0.0,
                                    right: 0.0),
                                isDense: true,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(20.0),
                                ),

                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                              textAlignVertical: TextAlignVertical.center,
                              cursorColor: backgroundColorRed,
                              textCapitalization: TextCapitalization.sentences,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: isValid ? _onFormSubmitted : null,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: size.height * 0.02),
                          child: Icon(
                            Icons.send,
                            size: size.height * 0.04,
                            color: isValid
                                ? backgroundColorRed
                                : backgroundColorRed.withOpacity(0.5),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            );
          }
          return Container();
        },
      ),
    );
  }
}

class MessageWidget extends StatefulWidget {
  final String messageId, currentUserId;

  const MessageWidget({this.messageId, this.currentUserId});

  @override
  _MessageWidgetState createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget> {
  MessagingRepository _messagingRepository = MessagingRepository();

  MessageModel _message;

  Future _getDetails() async {
    _message = await _messagingRepository.getMessageDetail(
        messageId: widget.messageId);

    return _message;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return FutureBuilder(
      future: _getDetails(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        } else {
          _message = snapshot.data;
          bool isSender = _message.senderId == widget.currentUserId;
          return Column(
            crossAxisAlignment:
                isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: <Widget>[
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.start,
                direction: Axis.horizontal,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                        top: size.height * 0.01,
                        bottom: size.height * 0.01,
                        right:
                            isSender ? size.height * 0.02 : size.height * 0.01,
                        left:
                            isSender ? size.height * 0.01 : size.height * 0.02),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: size.width * 0.7),
                      child: Container(
                        decoration: BoxDecoration(
                          color:
                              isSender ? backgroundColorRed : Colors.grey[300],
                          borderRadius: isSender
                              ? BorderRadius.only(
                                  topLeft: Radius.circular(size.height * 0.02),
                                  topRight: Radius.circular(size.height * 0.02),
                                  bottomLeft:
                                      Radius.circular(size.height * 0.02),
                                )
                              : BorderRadius.only(
                                  topLeft: Radius.circular(size.height * 0.02),
                                  topRight: Radius.circular(size.height * 0.02),
                                  bottomRight:
                                      Radius.circular(size.height * 0.02),
                                ),
                        ),
                        padding: EdgeInsets.all(size.height * 0.01),
                        child: Text(
                          _message.text,
                          style: TextStyle(
                            color: isSender ? Colors.white : Colors.black,
                            fontSize: size.height * 0.018,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(
                    bottom: size.height * 0.003,
                    right: isSender ? size.height * 0.02 : size.height * 0.01,
                    left: isSender ? size.height * 0.01 : size.height * 0.02),
                child: Text(
                  readTimestamp(_message.timestamp.toDate(), true),
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: size.height * 0.014,
                    color: Colors.grey[500],
                  ),
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
