import 'dart:async';

import 'package:ebbot_dart_client/entity/chat/chat.dart';
import 'package:ebbot_flutter_ui/v1/src/controller/resettable_controller.dart';
import 'package:ebbot_flutter_ui/v1/src/initializer/service_locator.dart';
import 'package:ebbot_flutter_ui/v1/src/parser/ebbot_chat_parser.dart';
import 'package:ebbot_flutter_ui/v1/src/service/ebbot_chat_listener_service.dart';
import 'package:ebbot_flutter_ui/v1/src/service/ebbot_support_service.dart';
import 'package:ebbot_flutter_ui/v1/src/service/log_service.dart';
import 'package:ebbot_flutter_ui/v1/src/util/ebbot_gpt_user.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class EbbotChatStreamController extends ResettableController {
  final _serviceLocator = ServiceLocator();
  final Function _handleTypingMessage;
  final Function _handleClearTypingUsers;
  final Function(types.Message) _handleAddMessage;
  final Function(String) _handleCanType;
  bool hasReceivedGPTMessageBefore = false;

  final _ebbotChatParser = EbbotChatParser();

  StreamSubscription<Chat>? _chatStreamSubscription;

  get _logger => _serviceLocator.getService<LogService>().logger;

  EbbotChatStreamController(
    this._handleTypingMessage,
    this._handleClearTypingUsers,
    this._handleAddMessage,
    this._handleCanType,
  ) {
    startListening();
  }

  void handle(Chat chat) {
    var chatMessages = chat.data?.chat?.chatMessages ?? [];
    final ebbotSupportService =
        _serviceLocator.getService<EbbotSupportService>();

    _logger?.d("we have ${chatMessages.length} chat messages to process");

    for (var message in chatMessages) {
      _handleClearTypingUsers();
      _logger?.d("Message sender: ${message.sender}");
      final author = message.sender == 'user' ? chatUser : ebbotSupportService.getEbbotGPTUser();
      final messageId = message.id!;

      var chatMessage = _ebbotChatParser.parse(message, author, messageId);
      if (chatMessage == null) {
        _logger?.d("message is null");
        continue;
      }
      _handleAddMessage(chatMessage);
    }
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
  }
}
