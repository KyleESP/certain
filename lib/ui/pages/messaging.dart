import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:certain/blocs/messaging/bloc.dart';
import 'package:certain/blocs/messaging/messaging_bloc.dart';

import 'package:certain/models/message_model.dart';
import 'package:certain/models/user_model.dart';
import 'package:certain/repositories/messaging_repository.dart';

import 'package:certain/ui/widgets/photo_widget.dart';

import 'package:certain/helpers/constants.dart';

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
        backgroundColor: backgroundColor,
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
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is MessagingLoadedState) {
            Stream<QuerySnapshot> messageStream = state.messageStream;
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                StreamBuilder<QuerySnapshot>(
                  stream: messageStream,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Text(
                        "Commencer la conversation ?",
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      );
                    }
                    if (snapshot.data.docs.isNotEmpty) {
                      return Expanded(
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              child: ListView.builder(
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
                    } else {
                      return Center(
                        child: Text(
                          "Commencer la conversation ?",
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),
                      );
                    }
                  },
                ),
                Container(
                  width: size.width,
                  height: size.height * 0.06,
                  color: backgroundColor,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          height: size.height * 0.05,
                          padding: EdgeInsets.all(size.height * 0.01),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.circular(size.height * 0.04),
                          ),
                          child: Center(
                            child: TextField(
                              controller: _messageTextController,
                              textInputAction: TextInputAction.send,
                              maxLines: null,
                              decoration: null,
                              textAlignVertical: TextAlignVertical.center,
                              cursorColor: backgroundColor,
                              textCapitalization: TextCapitalization.sentences,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: isValid ? _onFormSubmitted : null,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: size.height * 0.01),
                          child: Icon(
                            Icons.send,
                            size: size.height * 0.04,
                            color: isValid ? Colors.white : Colors.grey,
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

  Future getDetails() async {
    _message = await _messagingRepository.getMessageDetail(
        messageId: widget.messageId);

    return _message;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return FutureBuilder(
      future: getDetails(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        } else {
          _message = snapshot.data;
          return Column(
            crossAxisAlignment: _message.senderId == widget.currentUserId
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: <Widget>[
              _message.text != null
                  ? Wrap(
                crossAxisAlignment: WrapCrossAlignment.start,
                direction: Axis.horizontal,
                children: <Widget>[
                  _message.senderId == widget.currentUserId
                      ? Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: size.height * 0.01),
                    child: Text(
                      timeago.format(
                        _message.timestamp.toDate(),
                      ),
                    ),
                  )
                      : Container(),
                  Padding(
                    padding: EdgeInsets.all(size.height * 0.01),
                    child: ConstrainedBox(
                      constraints:
                      BoxConstraints(maxWidth: size.width * 0.7),
                      child: Container(
                        decoration: BoxDecoration(
                          color: _message.senderId == widget.currentUserId
                              ? backgroundColor
                              : Colors.grey[400],
                          borderRadius: _message.senderId ==
                              widget.currentUserId
                              ? BorderRadius.only(
                            topLeft:
                            Radius.circular(size.height * 0.02),
                            topRight:
                            Radius.circular(size.height * 0.02),
                            bottomLeft:
                            Radius.circular(size.height * 0.02),
                          )
                              : BorderRadius.only(
                            topLeft:
                            Radius.circular(size.height * 0.02),
                            topRight:
                            Radius.circular(size.height * 0.02),
                            bottomRight:
                            Radius.circular(size.height * 0.02),
                          ),
                        ),
                        padding: EdgeInsets.all(size.height * 0.01),
                        child: Text(
                          _message.text,
                          style: TextStyle(
                              color: _message.senderId ==
                                  widget.currentUserId
                                  ? Colors.white
                                  : Colors.black),
                        ),
                      ),
                    ),
                  ),
                  _message.senderId == widget.currentUserId
                      ? SizedBox()
                      : Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: size.height * 0.01),
                    child: Text(timeago
                        .format(_message.timestamp.toDate())),
                  )
                ],
              )
                  : Wrap(
                crossAxisAlignment: WrapCrossAlignment.start,
                direction: Axis.horizontal,
                children: <Widget>[
                  _message.senderId == widget.currentUserId
                      ? Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: size.height * 0.01),
                    child: Text(timeago
                        .format(_message.timestamp.toDate())),
                  )
                      : Container(),
                  Padding(
                    padding: EdgeInsets.all(size.height * 0.01),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                          maxWidth: size.width * 0.7,
                          maxHeight: size.width * 0.8),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: backgroundColor),
                          borderRadius:
                          BorderRadius.circular(size.height * 0.02),
                        ),
                        child: ClipRRect(
                          borderRadius:
                          BorderRadius.circular(size.height * 0.02),
                          child: PhotoWidget(
                            photoLink: _message.photoUrl,
                          ),
                        ),
                      ),
                    ),
                  ),
                  _message.senderId == widget.currentUserId
                      ? SizedBox()
                      : Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: size.height * 0.01),
                    child: Text(timeago
                        .format(_message.timestamp.toDate())),
                  )
                ],
              )
            ],
          );
        }
      },
    );
  }
}
