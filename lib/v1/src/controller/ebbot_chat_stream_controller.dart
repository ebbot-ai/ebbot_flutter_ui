import 'package:ebbot_dart_client/entity/chat/chat.dart';
import 'package:ebbot_flutter_ui/v1/src/controller/ebbot_message_stream_controller.dart';
import 'package:ebbot_flutter_ui/v1/src/initializer/ebbot_controller_initializer.dart';
import 'package:ebbot_flutter_ui/v1/src/parser/ebbot_message_parser.dart';
import 'package:ebbot_flutter_ui/v1/src/service/ebbot_chat_listener_service.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class EbbotChatStreamController extends AbstractResettableController {
  final Function _handleTypingMessage;
  final Function _handleClearTypingUsers;
  final Function(types.Message?) _handleAddMessage;
  final Function(String) _handleCanType;
  bool hasReceivedGPTMessageBefore = false;

  final _ebbotMessageParser = EbbotMessageParser();

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

  final logger = Logger(
    printer: PrettyPrinter(),
  );

  void handle(Chat message) {
    logger.i("handling chat");
  }

  @override
  void reset() {
    startListening();
  }

  void startListening() {
    _chatListenerService.chatStream.listen((chat) {
      handle(chat);
    });
    _handleCanType("visible");
  }
}
