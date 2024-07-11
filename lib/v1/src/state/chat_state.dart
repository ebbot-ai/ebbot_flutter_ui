import 'package:ebbot_flutter_ui/v1/configuration/ebbot_configuration.dart';
import 'package:ebbot_flutter_ui/v1/src/service/ebbot_callback_service.dart';
import 'package:ebbot_flutter_ui/v1/src/service/ebbot_chat_listener_service.dart';
import 'package:ebbot_flutter_ui/v1/src/service/ebbot_dart_client_service.dart';
import 'package:ebbot_flutter_ui/v1/src/util/string_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class EbbotChatState extends ChangeNotifier {
  final List<types.Message> _messages = [];
  List<types.Message> get messages => _messages;

  final List<types.User> _typingUsers = [];
  List<types.User> get typingUsers => _typingUsers;

  late types.User _user;
  types.User get user => _user;

  bool isInitialized = false;

  final logger = Logger(printer: PrettyPrinter());

  void initialize(String botId, EbbotConfiguration configuration) async {
    try {
      isInitialized = false;
      _messages.clear();

      // Initialize configuration and services...
      // _ebbotServiceInitializer, _ebbotControllerInitializer

      final ebbotClientService = GetIt.I.get<EbbotDartClientService>();
      _user = types.User(id: ebbotClientService.client.chatId);

      // Register other services, initialize controllers, and start receiving messages...

      isInitialized = true;
      GetIt.I.get<EbbotCallbackService>().dispatchOnLoad();

      notifyListeners();
    } catch (error) {
      logger.e("Initialization failed: $error");
    }
  }

  void handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: StringUtil.randomString(),
      text: message.text,
    );

    _messages.insert(0, textMessage);
    GetIt.I
        .get<EbbotDartClientService>()
        .client
        .sendTextMessage(textMessage.text);
    notifyListeners();
  }

  Future<void> handleMessageTap(
      BuildContext context, types.Message message) async {
    if (message is types.FileMessage) {
      var localPath = message.uri;

      if (message.uri.startsWith('http')) {
        try {
          final index =
              _messages.indexWhere((element) => element.id == message.id);
          final updatedMessage =
              (_messages[index] as types.FileMessage).copyWith(isLoading: true);
          _messages[index] = updatedMessage;
          notifyListeners();

          final client = http.Client();
          final request = await client.get(Uri.parse(message.uri));
          final bytes = request.bodyBytes;
          final documentsDir = (await getApplicationDocumentsDirectory()).path;
          localPath = '$documentsDir/${message.name}';

          if (!File(localPath).existsSync()) {
            final file = File(localPath);
            await file.writeAsBytes(bytes);
          }
        } finally {
          final index =
              _messages.indexWhere((element) => element.id == message.id);
          final updatedMessage =
              (_messages[index] as types.FileMessage).copyWith(isLoading: null);
          _messages[index] = updatedMessage;
          notifyListeners();
        }
      }

      await OpenFilex.open(localPath);
    }
  }
}
