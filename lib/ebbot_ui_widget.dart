import 'dart:io';

import 'package:ebbot_dart_client/valueobjects/message_type.dart';
import 'package:ebbot_flutter_ui/configuration/ebbot_configuration.dart';
import 'package:ebbot_flutter_ui/handler/ebbot_message_handler.dart';
import 'package:flutter/material.dart';
import 'package:ebbot_dart_client/ebbot_chat_client.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:http/http.dart' as http;

import 'package:logger/logger.dart';
import 'dart:math';
import 'dart:convert';

import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

class EbbotUiWidget extends StatefulWidget {
  final String botId;
  final EbbotConfiguration config;

  EbbotUiWidget({
    Key? key,
    required this.botId,
    EbbotConfiguration? config,
  })  : config = config ?? EbbotConfigurationBuilder().build(),
        super(key: key);

  @override
  State<EbbotUiWidget> createState() => _EbbotUiWidgetState();
}

String _randomString() {
  final random = Random.secure();
  final values = List<int>.generate(16, (i) => random.nextInt(255));
  return base64UrlEncode(values);
}

class _EbbotUiWidgetState extends State<EbbotUiWidget>
    with AutomaticKeepAliveClientMixin {
  final List<types.Message> _messages = [];
  types.User? _user;

  final _ebbotGPTUser =
      const types.User(id: 'ebbot-gpt', firstName: 'Ebbot Chat');
  final _agentUser = const types.User(id: 'agent', firstName: 'Agent');
  final _typingUsers = <types.User>[];
  late EbbotDartClient ebbotDartClient;
  final ebbotMessageHandler = EbbotMessageHandler();

  final logger = Logger(
    printer: PrettyPrinter(),
  );

  @override
  void initState() {
    super.initState();
    ebbotDartClient = EbbotDartClient(widget.botId);
    _user = types.User(id: ebbotDartClient.chatId);
    initEbbotDartClient();
  }

  @override
  void dispose() {
    ebbotDartClient.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  void initEbbotDartClient() async {
    // Initialize the chat client
    await ebbotDartClient.initialize();

    ebbotDartClient.listener.chatStream.listen((chat) {
      logger.i('listener got chat: $chat');
    });

    ebbotDartClient.listener.messageStream.listen((message) {
      var messageType = message.data.message.type;
      logger.i('listener got message of type: $messageType');

      // Special case for typing, as we use Flyers typing indicator logic
      if (messageType == 'typing') {
        logger.i("handling typing message");
        setState(() {
          _typingUsers.add(_ebbotGPTUser); // TODO: Check which user to add
        });
        return;
      }

      setState(() {
        _typingUsers.remove(_ebbotGPTUser);
      });

      _addMessage(
          ebbotMessageHandler.handle(message, _ebbotGPTUser, _randomString()));
    });

    // We are ready to start receiving messages
    ebbotDartClient.startReceive();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Chat(
          theme: widget.config.theme,
          messages: _messages,
          onSendPressed: _handleSendPressed,
          onMessageTap: _handleMessageTap,
          user: _user!,
          typingIndicatorOptions: TypingIndicatorOptions(
              typingMode: TypingIndicatorMode.both, typingUsers: _typingUsers),
        ),
      );

  void _addMessage(types.Message? message) {
    if (message == null) {
      logger.w("message is null, so skipping..");
      return;
    }

    setState(() {
      _messages.insert(0, message);
    });
  }

  void _handleMessageTap(BuildContext _, types.Message message) async {
    if (message is types.FileMessage) {
      var localPath = message.uri;

      if (message.uri.startsWith('http')) {
        try {
          // Update tapped file message to show loading spinner
          final index =
              _messages.indexWhere((element) => element.id == message.id);
          final updatedMessage =
              (_messages[index] as types.FileMessage).copyWith(
            isLoading: true,
          );

          setState(() {
            _messages[index] = updatedMessage;
          });

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
          // In case of error or success, reset loading spinner
          final index =
              _messages.indexWhere((element) => element.id == message.id);
          final updatedMessage =
              (_messages[index] as types.FileMessage).copyWith(
            isLoading: null,
          );

          setState(() {
            _messages[index] = updatedMessage;
          });
        }
      }

      await OpenFilex.open(localPath);
    }
  }

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user!,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: _randomString(),
      text: message.text,
    );

    _addMessage(textMessage);
    ebbotDartClient.sendMessage(textMessage.text);
  }
}
