import 'dart:async';

import 'package:ebbot_dart_client/entity/message/message.dart';
import 'package:ebbot_flutter_ui/v1/src/controller/resettable_controller.dart';
import 'package:ebbot_flutter_ui/v1/src/initializer/service_locator.dart';
import 'package:ebbot_flutter_ui/v1/src/parser/ebbot_message_parser.dart';
import 'package:ebbot_flutter_ui/v1/src/service/ebbot_chat_listener_service.dart';
import 'package:ebbot_flutter_ui/v1/src/service/ebbot_support_service.dart';
import 'package:ebbot_flutter_ui/v1/src/service/log_service.dart';
import 'package:ebbot_flutter_ui/v1/src/util/ebbot_gpt_user.dart';
import 'package:ebbot_flutter_ui/v1/src/util/string_util.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class EbbotMessageStreamController extends ResettableController {
  final _serviceLocator = ServiceLocator();
  get _logger => _serviceLocator.getService<LogService>().logger;
  final Function _handleTypingUsers;
  final Function _handleClearTypingUsers;
  final Function(types.Message) _handleAddMessage;
  final Function(String?) _handleInputMode;
  bool hasReceivedGPTMessageBefore = false;

  final _ebbotMessageParser = EbbotMessageParser();

  EbbotMessageStreamController(
    this._handleTypingUsers,
    this._handleClearTypingUsers,
    this._handleAddMessage,
    this._handleInputMode,
  ) {
    startListening();
  }

  StreamSubscription<Message>? _messageStreamSubscription;

  String getMessageId(MessageContent content) {
    if (content.id != null) {
      _logger.d(
          "Using existing message id: ${content.id} for type: ${content.type}");
      return content.id!;
    }
    _logger.d("Generating new message id for type: ${content.type}");
    return StringUtil.randomString();
  }

  void _handle(Message message) {
    final ebbotSupportService =
        _serviceLocator.getService<EbbotSupportService>();
    final ebbotGPTUser = ebbotSupportService.getEbbotGPTUser();
    // Handle the message
    var messageType = message.data.message.type;

    _handleInputMode(message.data.message.input_field);

    final author =
        message.data.message.sender == 'user' ? chatUser : ebbotGPTUser;

    if (messageType == 'typing') {
      _handleTypingUsers();
      return;
    }

    _handleClearTypingUsers();

    // If this is the first time we get a GPT message, lets add a "AI generated message" system message
    if (hasReceivedGPTMessageBefore == false && messageType == 'gpt') {
      hasReceivedGPTMessageBefore = true;

      var systemMessage = types.SystemMessage(
          id: StringUtil.randomString(),
          author: ebbotGPTUser,
          text: "AI generated message");
      _handleAddMessage(systemMessage);
    }

    var messageId = StringUtil.randomString();

    if (message.data.message.id != null) {
      messageId = message.data.message.id!;
    }

    var chatMessage = _ebbotMessageParser.parse(message, author, messageId);
    if (chatMessage == null) {
      _logger?.d("message is null");
      return;
    }
    _handleAddMessage(chatMessage);
  }

  @override
  void reset() {
    startListening();
  }

  void startListening() {
    if (_messageStreamSubscription != null) {
      _messageStreamSubscription?.cancel();
    }
    final chatListenerService =
        _serviceLocator.getService<EbbotChatListenerService>();
    _messageStreamSubscription =
        chatListenerService.messageStream.listen((message) {
      _handle(message);
    });
    _handleInputMode("visible");
  }
}
