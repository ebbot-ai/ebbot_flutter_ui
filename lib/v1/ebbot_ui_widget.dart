import 'dart:io';
import 'package:ebbot_dart_client/configuration/configuration.dart';
import 'package:ebbot_flutter_ui/v1/configuration/ebbot_configuration.dart';
import 'package:ebbot_flutter_ui/v1/src/handler/ebbot_message_processor.dart';
import 'package:ebbot_flutter_ui/v1/src/widget/custom_message.dart';
import 'package:flutter/material.dart';
import 'package:ebbot_dart_client/ebbot_dart_client.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'dart:math';
import 'dart:convert';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

/// A Flutter widget for integrating Ebbot chat bot functionality into the UI.
///
/// This widget facilitates communication between the user interface and
/// the Ebbot chat system. It manages sending and receiving messages, handling
/// typing indicators, and displaying messages within the UI.
class EbbotUiWidget extends StatefulWidget {
  /// The ID of the Ebbot Chat Bot to connect to.
  final String _botId;

  /// Configuration settings for the Ebbot chat.
  final EbbotConfiguration _configuration;

  /// Constructs an instance of [EbbotUiWidget].
  ///
  /// The [botId] parameter is required and represents the ID of the bot
  /// that this user interface will interact with. The [configuration] parameter
  /// allows specifying custom configuration settings for the Ebbot chat.
  /// If not provided, default configuration settings will be used.
  EbbotUiWidget({
    Key? key,
    required String botId,
    EbbotConfiguration? configuration,
  })  : _botId = botId,
        _configuration = configuration ?? EbbotConfigurationBuilder().build(),
        super(key: key);

  @override
  State<EbbotUiWidget> createState() => _EbbotUiWidgetState();
}

String _randomString() {
  final random = Random.secure();
  final values = List<int>.generate(16, (i) => random.nextInt(255));
  return base64UrlEncode(values);
}

/// The state class for the [EbbotUiWidget].
///
/// Manages the internal state of the user interface, including message handling,
/// user interactions, and communication with the Ebbot chat bot.
class _EbbotUiWidgetState extends State<EbbotUiWidget>
    with AutomaticKeepAliveClientMixin {
  final List<types.Message> _messages = [];
  types.User? _user;

  final _ebbotGPTUser =
      const types.User(id: 'ebbot-gpt', firstName: 'Ebbot Chat');
  //final _agentUser = const types.User(id: 'agent', firstName: 'Agent');
  final _typingUsers = <types.User>[];
  late EbbotDartClient ebbotClient;
  final ebbotMessageHandler = EbbotMessageProcessor();
  bool hasReceivedGPTMessageBefore = false;

  final logger = Logger(
    printer: PrettyPrinter(),
  );

  @override
  void initState() {
    super.initState();

    var configuration = ConfigurationBuilder()
        .environment(widget._configuration.environment)
        .build();
    ebbotClient = EbbotDartClient(widget._botId, configuration);
    _user = types.User(id: ebbotClient.chatId);
    initEbbotDartClient();
  }

  @override
  void dispose() {
    ebbotClient.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  void initEbbotDartClient() async {
    // Initialize the chat client
    await ebbotClient.initialize();

    ebbotClient.listener.chatStream.listen((chat) {
      logger.i('listener got chat: $chat');
    });

    ebbotClient.listener.messageStream.listen((messageBody) {
      var messageType = messageBody.data.message.type;
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

      // If this is the first time we get a GPT message, lets add a "AI generated message" system message
      if (hasReceivedGPTMessageBefore == false && messageType == 'gpt') {
        hasReceivedGPTMessageBefore = true;

        var systemMessage = types.SystemMessage(
            id: _randomString(),
            author: _ebbotGPTUser,
            text: "AI generated message");
        _addMessage(systemMessage);
      }

      var message = ebbotMessageHandler.process(
          messageBody, _ebbotGPTUser, _randomString());
      _addMessage(message);
    });

    // We are ready to start receiving messages
    ebbotClient.startReceive();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var customMessage = CustomMessage(client: ebbotClient);

    return Scaffold(
      body: Chat(
        theme: widget._configuration.theme,
        messages: _messages,
        onSendPressed: _handleSendPressed,
        onMessageTap: _handleMessageTap,
        user: _user!,
        customMessageBuilder: customMessage.handle,
        typingIndicatorOptions: TypingIndicatorOptions(
            typingMode: TypingIndicatorMode.avatar, typingUsers: _typingUsers),
      ),
    );
  }

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
    ebbotClient.sendTextMessage(textMessage.text);
  }
}