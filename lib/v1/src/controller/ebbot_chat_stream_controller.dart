import 'package:ebbot_dart_client/entities/chat/chat.dart';
import 'package:ebbot_dart_client/entities/message/message.dart';
import 'package:ebbot_flutter_ui/v1/src/controller/ebbot_message_controller.dart';
import 'package:ebbot_flutter_ui/v1/src/service/ebbot_chat_listener_service.dart';
import 'package:ebbot_flutter_ui/v1/src/util/ebbot_gpt_user.dart';
import 'package:ebbot_flutter_ui/v1/src/util/string_util.dart';
import 'package:logger/logger.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class EbbotChatStreamController {
  final EbbotChatListenerService _chatListenerService;
  final Function _handleTypingMessage;
  final Function _handleClearTypingUsers;
  final Function(types.Message?) _handleAddMessage;
  final Function(bool) _handleCanType;
  bool hasReceivedGPTMessageBefore = false;

  final EbbotMessageController _ebbotMessageController;

  EbbotChatStreamController(
    this._chatListenerService,
    this._handleTypingMessage,
    this._handleClearTypingUsers,
    this._handleAddMessage,
    this._handleCanType,
    this._ebbotMessageController,
  ) {
    startListening();
  }

  final logger = Logger(
    printer: PrettyPrinter(),
  );

  void startListening() {
    _chatListenerService.chatStream.listen((chat) {
      handle(chat);
    });
    _handleCanType(true);
  }

  void handle(Chat message) {
    logger.i("handling chat");
  }
}
