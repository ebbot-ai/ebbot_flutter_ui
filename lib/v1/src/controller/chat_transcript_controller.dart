import 'dart:async';

import 'package:ebbot_dart_client/entity/message/message.dart';
import 'package:ebbot_flutter_ui/v1/src/controller/resettable_controller.dart';
import 'package:ebbot_flutter_ui/v1/src/service/chat_transcript_service.dart';
import 'package:ebbot_flutter_ui/v1/src/service/ebbot_chat_listener_service.dart';
import 'package:get_it/get_it.dart';

class ChatTranscriptController extends ResettableController {
  final EbbotChatListenerService _chatListenerService =
      GetIt.I.get<EbbotChatListenerService>();
  final ChatTranscriptService _chatTranscriptService =
      GetIt.I.get<ChatTranscriptService>();

  StreamSubscription<Message>? _messageStreamSubscription;

  ChatTranscriptController() {
    startListening();
  }

  void _handle(Message message) {
    _chatTranscriptService.save(message);
  }

  void startListening() {
    if (_messageStreamSubscription != null) {
      _messageStreamSubscription?.cancel();
    }

    _messageStreamSubscription =
        _chatListenerService.messageStream.listen((message) {
      _handle(message);
    });
  }

  @override
  void reset() {
    _chatTranscriptService.reset();
    startListening();
  }
}
