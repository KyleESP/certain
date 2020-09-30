import 'dart:async';
import 'bloc.dart';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:certain/repositories/message_repository.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  MessageRepository _messageRepository;

  MessageBloc(this._messageRepository) : super(MessageInitialState());

  @override
  Stream<MessageState> mapEventToState(
    MessageEvent event,
  ) async* {
    if (event is ChatStreamEvent) {
      yield* _mapStreamToState(currentUserId: event.currentUserId);
    }
  }

  Stream<MessageState> _mapStreamToState({String currentUserId}) async* {
    yield ChatLoadingState();

    Stream<QuerySnapshot> chatStream =
        _messageRepository.getChats(userId: currentUserId);
    yield ChatLoadedState(chatStream: chatStream);
  }
}
