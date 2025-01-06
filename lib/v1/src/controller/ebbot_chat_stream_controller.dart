// ignore_for_file: unused_field

import 'dart:async';

import 'package:ebbot_dart_client/entity/chat/chat.dart';
import 'package:ebbot_flutter_ui/v1/src/controller/resettable_controller.dart';
import 'package:ebbot_flutter_ui/v1/src/service/ebbot_chat_listener_service.dart';
import 'package:ebbot_flutter_ui/v1/src/service/log_service.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:get_it/get_it.dart';

class EbbotChatStreamController extends ResettableController {
  final Function _handleTypingMessage;
  final Function _handleClearTypingUsers;
  final Function(types.Message?) _handleAddMessage;
  final Function(String) _handleCanType;
  bool hasReceivedGPTMessageBefore = false;

  StreamSubscription<Chat>? _chatStreamSubscription;

  EbbotChatListenerService get _chatListenerService =>
      GetIt.I.get<EbbotChatListenerService>();

  EbbotChatStreamController(
    this._handleTypingMessage,
    this._handleClearTypingUsers,
    this._handleAddMessage,
    this._handleCanType,
  ) {
    startListening();
  }

  final logger = GetIt.I.get<LogService>().logger;

  void handle(Chat message) {
    //logger?.i("handling chat");
  }

  @override
  void reset() {
    startListening();
  }

  void startListening() {
    if (_chatStreamSubscription != null) {
      _chatStreamSubscription?.cancel();
    }
    _chatStreamSubscription = _chatListenerService.chatStream.listen((chat) {
      handle(chat);
    });
    _handleCanType("visible");
  }
}
