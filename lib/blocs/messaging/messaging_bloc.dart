import 'dart:async';
import 'package:bloc/bloc.dart';

import 'package:certain/models/message_model.dart';
import 'package:certain/repositories/messaging_repository.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'bloc.dart';

class MessagingBloc extends Bloc<MessagingEvent, MessagingState> {
  MessagingRepository _messagingRepository;

  MessagingBloc(this._messagingRepository) : super(MessagingInitialState());

  @override
  Stream<MessagingState> mapEventToState(
    MessagingEvent event,
  ) async* {
    if (event is MessageStreamEvent) {
      yield* _mapStreamToState(
          currentUserId: event.currentUserId,
          selectedUserId: event.selectedUserId);
    }
    if (event is SendMessageEvent) {
      yield* _mapSendMessageToState(message: event.message);
    }
  }

  Stream<MessagingState> _mapStreamToState(
      {String currentUserId, String selectedUserId}) async* {
    yield MessagingLoadingState();
    Stream<QuerySnapshot> messageStream = _messagingRepository.getMessages(
        currentUserId: currentUserId, selectedUserId: selectedUserId);
    yield MessagingLoadedState(messageStream: messageStream);
  }

  Stream<MessagingState> _mapSendMessageToState({MessageModel message}) async* {
    await _messagingRepository.sendMessage(message: message);
  }
}
