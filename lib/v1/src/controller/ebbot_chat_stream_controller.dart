import 'dart:async';

import 'package:ebbot_dart_client/entity/chat/chat.dart';
import 'package:ebbot_flutter_ui/v1/src/controller/resettable_controller.dart';
import 'package:ebbot_flutter_ui/v1/src/initializer/service_locator.dart';
import 'package:ebbot_flutter_ui/v1/src/service/ebbot_chat_listener_service.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class EbbotChatStreamController extends ResettableController {
  final _serviceLocator = ServiceLocator();
  final Function _handleTypingMessage;
  final Function _handleClearTypingUsers;
  final Function(types.Message?) _handleAddMessage;
  final Function(String) _handleCanType;
  bool hasReceivedGPTMessageBefore = false;

  StreamSubscription<Chat>? _chatStreamSubscription;

  EbbotChatStreamController(
    this._handleTypingMessage,
    this._handleClearTypingUsers,
    this._handleAddMessage,
    this._handleCanType,
  ) {
    startListening();
  }

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

    final chatListenerService =
        _serviceLocator.getService<EbbotChatListenerService>();

    _chatStreamSubscription = chatListenerService.chatStream.listen((chat) {
      handle(chat);
    });
    _handleCanType("visible");
  }
}
