import 'package:ebbot_dart_client/entity/message/message.dart';
import 'package:ebbot_flutter_ui/v1/src/parser/ebbot_message_parser.dart';
import 'package:ebbot_flutter_ui/v1/src/service/ebbot_chat_listener_service.dart';
import 'package:ebbot_flutter_ui/v1/src/util/ebbot_gpt_user.dart';
import 'package:ebbot_flutter_ui/v1/src/util/string_util.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class EbbotMessageStreamController {
  late EbbotChatListenerService _chatListenerService;
  final Function _handleTypingUsers;
  final Function _handleClearTypingUsers;
  final Function(types.Message?) _handleAddMessage;
  final Function(bool) _handleCanType;
  bool hasReceivedGPTMessageBefore = false;

  final _ebbotMessageParser = EbbotMessageParser();

  EbbotMessageStreamController(
    this._handleTypingUsers,
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
    _chatListenerService.messageStream.listen((message) {
      _handle(message);
    });
    _handleCanType(true);
  }

  void _handle(Message message) {
    logger.i("handling message");
    // Handle the message
    var messageType = message.data.message.type;

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

    var chatMessage = _ebbotMessageParser.parse(
        message, ebbotGPTUser, StringUtil.randomString());
    _handleAddMessage(chatMessage);
  }
}
