import 'dart:async';

import 'package:ebbot_dart_client/entity/message/message.dart';
import 'package:ebbot_flutter_ui/v1/src/controller/resettable_controller.dart';
import 'package:ebbot_flutter_ui/v1/src/initializer/service_locator.dart';
import 'package:ebbot_flutter_ui/v1/src/service/chat_transcript_service.dart';
import 'package:ebbot_flutter_ui/v1/src/service/ebbot_chat_listener_service.dart';

class ChatTranscriptController extends ResettableController {
  final _serviceLocator = ServiceLocator();

  StreamSubscription<Message>? _messageStreamSubscription;

  ChatTranscriptController() {
    startListening();
  }

  void _handle(Message message) {
    _serviceLocator.getService<ChatTranscriptService>().save(message);
  }

  void startListening() {
    if (_messageStreamSubscription != null) {
      _messageStreamSubscription?.cancel();
    }

    final messageStream =
        _serviceLocator.getService<EbbotChatListenerService>().messageStream;

    _messageStreamSubscription = messageStream.listen((message) {
      _handle(message);
    });
  }

  @override
  void reset() {
    _serviceLocator.getService<ChatTranscriptService>().reset();
    startListening();
  }
}
