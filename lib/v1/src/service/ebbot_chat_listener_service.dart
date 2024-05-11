import 'package:ebbot_dart_client/ebbot_dart_client.dart';
import 'package:ebbot_dart_client/entity/chat/chat.dart';
import 'package:ebbot_dart_client/entity/message/message.dart';

class EbbotChatListenerService {
  final EbbotDartClient _client;
  EbbotDartClient get client => _client;

  EbbotChatListenerService(this._client);

  Stream<Chat> get chatStream => _client.chatStream;
  Stream<Message> get messageStream => _client.messageStream;
}
