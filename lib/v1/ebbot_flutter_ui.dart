import 'dart:io';
import 'package:ebbot_dart_client/configuration/configuration.dart';
import 'package:ebbot_flutter_ui/v1/configuration/ebbot_behaviour.dart';
import 'package:ebbot_flutter_ui/v1/configuration/ebbot_configuration.dart';
import 'package:ebbot_flutter_ui/v1/src/controller/chat_input_controller.dart';
import 'package:ebbot_flutter_ui/v1/src/controller/notification_controller.dart';
import 'package:ebbot_flutter_ui/v1/src/controller/ebbot_message_controller.dart';
import 'package:ebbot_flutter_ui/v1/src/controller/chat_ui_custom_message_controller.dart';
import 'package:ebbot_flutter_ui/v1/src/service/notification_service.dart';
import 'package:ebbot_flutter_ui/v1/src/util/string_util.dart';
import 'package:flutter/material.dart';
import 'package:ebbot_dart_client/ebbot_dart_client.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

/// A Flutter widget for integrating Ebbot chat bot functionality into the UI.
///
/// This widget facilitates communication between the user interface and
/// the Ebbot chat system. It manages sending and receiving messages, handling
/// typing indicators, and displaying messages within the UI.
class EbbotFlutterUi extends StatefulWidget {
  /// The ID of the Ebbot Chat Bot to connect to.
  final String _botId;

  /// Configuration settings for the Ebbot chat.
  final EbbotConfiguration _configuration;

  /// Constructs an instance of [EbbotFlutterUi].
  ///
  /// The [botId] parameter is required and represents the ID of the bot
  /// that this user interface will interact with. The [configuration] parameter
  /// allows specifying custom configuration settings for the Ebbot chat.
  /// If not provided, default configuration settings will be used.
  EbbotFlutterUi({
    Key? key,
    required String botId,
    EbbotConfiguration? configuration,
  })  : _botId = botId,
        _configuration = configuration ?? EbbotConfigurationBuilder().build(),
        super(key: key);

  @override
  State<EbbotFlutterUi> createState() => EbbotFlutterUiState();
}

/// The state class for the [EbbotFlutterUi].
///
/// Manages the internal state of the user interface, including message handling,
/// user interactions, and communication with the Ebbot chat bot.
class EbbotFlutterUiState extends State<EbbotFlutterUi>
    with AutomaticKeepAliveClientMixin {
  final List<types.Message> _messages = [];
  types.User? _user;
  bool isInitialized = false;

  final _ebbotGPTUser =
      const types.User(id: 'ebbot-gpt', firstName: 'Ebbot Chat');
  final _typingUsers = <types.User>[];
  late EbbotDartClient ebbotClient;
  final ebbotMessageHandler = EbbotMessageController();
  bool hasReceivedGPTMessageBefore = false;
  late ChatInputController _chatInputController;
  late NotificationController _notificationController;
  late NotificationService _notificationService;
  late ChatUiCustomMessageController _chatUiCustomMessageController;

  final logger = Logger(
    printer: PrettyPrinter(),
  );

  @override
  void initState() {
    super.initState();

    initialize();
  }

  @override
  void dispose() {
    ebbotClient.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  void initialize() async {
    isInitialized = false;
    _messages.clear();

    var configuration = ConfigurationBuilder()
        .environment(widget._configuration.environment)
        .userAttributes(widget._configuration.userConfiguration.userAttributes)
        .build();

    ebbotClient = EbbotDartClient(widget._botId, configuration);
    _user = types.User(id: ebbotClient.chatId);

    // Initialize the chat client
    await ebbotClient.initialize();

    // Initialize the services
    initalizeServices();
    // Initialize the controllers
    initalizeControllers();

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
          _typingUsers.clear();
          _typingUsers.add(_ebbotGPTUser);
        });
        return;
      }

      setState(() {
        //_typingUsers.remove((u) => _ebbotGPTUser.id == u.id);
        _typingUsers
            .clear(); // Maybe not the cleanest way to remove all typing users
      });

      // If this is the first time we get a GPT message, lets add a "AI generated message" system message
      if (hasReceivedGPTMessageBefore == false && messageType == 'gpt') {
        hasReceivedGPTMessageBefore = true;

        var systemMessage = types.SystemMessage(
            id: StringUtil.randomString(),
            author: _ebbotGPTUser,
            text: "AI generated message");
        _addMessage(systemMessage);
      }

      // If the type is rating, the conversation has ended
      // and we should disable the input field
      if (messageType == 'rating') {
        canType(false);
      }

      var message = ebbotMessageHandler.handle(
          messageBody, _ebbotGPTUser, StringUtil.randomString());
      _addMessage(message);
    });

    // We are ready to start receiving messages
    ebbotClient.startReceive();
    canType(true);
    isInitialized = true;
  }

  void initalizeServices() {
    _notificationService = NotificationService(ebbotClient.notifications);
  }

  void initalizeControllers() {
    _chatInputController = ChatInputController(
      enabled: true,
      enterPressedBehaviour: widget._configuration.behaviour.input.enterPressed,
      onTextChanged: handleOnTextChanged,
    );

    _notificationController =
        NotificationController(_notificationService, _handleNotification);

    _chatUiCustomMessageController = ChatUiCustomMessageController(
        client: ebbotClient,
        ebbotFlutterUiState: this,
        configuration: widget._configuration,
        canType: canType);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      body: !isInitialized
          ? Center(
              child: CircularProgressIndicator(
                  color: widget._configuration.theme.primaryColor))
          : Chat(
              inputOptions: _chatInputController.inputOptions,
              theme: widget._configuration.theme,
              messages: _messages,
              onSendPressed: _handleSendPressed,
              onMessageTap: _handleMessageTap,
              user: _user!,
              customMessageBuilder:
                  _chatUiCustomMessageController.processMessage,
              typingIndicatorOptions: TypingIndicatorOptions(
                  typingMode: TypingIndicatorMode.avatar,
                  typingUsers: _typingUsers),
            ),
    );
  }

  void _handleNotification(String title, String text) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(text),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void canType(bool canType) {
    setState(() {
      _chatInputController.enabled = canType;
    });
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

  void handleOnTextChanged(String text) {
    if (text.isEmpty) {
      logger.i("text is empty, so skipping..");
      return;
    }

    if (_chatInputController.enterPressedBehaviour !=
        EbbotBehaviourInputEnterPressed.sendMessage) {
      logger.i(
          "enterPressedBehaviour is ${_chatInputController.enterPressedBehaviour}, so skipping..");
      return;
    }

    if (!text.endsWith('\n')) {
      logger.i("text does not end with newline, so skipping..");
      return;
    }

    logger.i("text does end with newline, so sending..");
    text = text.substring(0, text.length - 1);
    _handleSendPressed(types.PartialText(text: text));

    // clear the text field
    _chatInputController.textEditingController.clear();

    /*if (_inputOptionsState.enterPressedBehaviour ==
        EbbotBehaviourInputEnterPressed.send) {
      _handleSendPressed(types.PartialText(text));
    }*/
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
      id: StringUtil.randomString(),
      text: message.text,
    );

    _addMessage(textMessage);
    ebbotClient.sendTextMessage(textMessage.text);
    _chatInputController.textEditingController.clear();
  }
}
