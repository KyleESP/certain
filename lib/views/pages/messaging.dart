import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:certain/blocs/messaging/bloc.dart';
import 'package:certain/blocs/messaging/messaging_bloc.dart';
import 'package:certain/models/message.dart';
import 'package:certain/models/my_user.dart';
import 'package:certain/repositories/messaging_repository.dart';
import 'package:certain/helpers/constants.dart';
import 'package:certain/views/widgets/message_widget.dart';
import 'package:certain/views/widgets/photo_widget.dart';

class Messaging extends StatefulWidget {
  final MyUser currentUser, selectedUser;

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
        message: Message(
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
