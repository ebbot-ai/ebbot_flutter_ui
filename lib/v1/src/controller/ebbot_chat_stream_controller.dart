import 'package:ebbot_dart_client/entities/chat/chat.dart';
import 'package:ebbot_dart_client/entities/message/message.dart';
import 'package:ebbot_flutter_ui/v1/src/parser/ebbot_message_parser.dart';
import 'package:ebbot_flutter_ui/v1/src/service/ebbot_chat_listener_service.dart';
import 'package:ebbot_flutter_ui/v1/src/util/ebbot_gpt_user.dart';
import 'package:ebbot_flutter_ui/v1/src/util/string_util.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class EbbotChatStreamController {
  late EbbotChatListenerService _chatListenerService;
  final Function _handleTypingMessage;
  final Function _handleClearTypingUsers;
  final Function(types.Message?) _handleAddMessage;
  final Function(bool) _handleCanType;
  bool hasReceivedGPTMessageBefore = false;

  final _ebbotMessageController = EbbotMessageParser();

  EbbotChatStreamController(
    this._handleTypingMessage,
    this._handleClearTypingUsers,
    this._handleAddMessage,
    this._handleCanType,
  ) {
    _chatListenerService = GetIt.I.get<EbbotChatListenerService>();
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
