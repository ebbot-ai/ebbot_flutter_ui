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
  final Function() _handleAgentHandover;
  bool hasReceivedGPTMessageBefore = false;
  bool hasHadAgentHandover = false;

  final _ebbotChatParser = EbbotChatParser();

  StreamSubscription<Chat>? _chatStreamSubscription;

  get _logger => _serviceLocator.getService<LogService>().logger;

  EbbotChatStreamController(
    this._handleTypingMessage,
    this._handleClearTypingUsers,
    this._handleAddMessage,
    this._handleCanType,
    this._handleAgentHandover,
  ) {
    startListening();
  }

  void handle(Chat chat) {
    var chatMessages = chat.data?.chat?.chat_messages ?? [];
    final ebbotSupportService =
        _serviceLocator.getService<EbbotSupportService>();

    _logger?.d("we have ${chatMessages.length} chat messages to process");

    // Check if there is an agent handover happening
    if (chat.data?.chat?.handled_by == 'agent' && !hasHadAgentHandover) {
      final ebbotSupportService =
          _serviceLocator.getService<EbbotSupportService>();
      final agentImage = chat.data?.chat?.user_profile_picture;
      _logger?.d("Agent handover detected");
      _handleAgentHandover();
      ebbotSupportService.setEbbotAgentUser(agentImage);
    }

    for (var message in chatMessages) {
      _handleClearTypingUsers();
      _logger?.d("Message sender: ${message.sender}");
      final author = message.sender == 'user'
          ? chatUser
          : ebbotSupportService.getEbbotUser();
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
    hasHadAgentHandover = false;
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
