import 'dart:io';
import 'package:ebbot_dart_client/configuration/configuration.dart';
import 'package:ebbot_flutter_ui/v1/configuration/ebbot_behaviour.dart';
import 'package:ebbot_flutter_ui/v1/configuration/ebbot_configuration.dart';
import 'package:ebbot_flutter_ui/v1/src/controller/chat_input_controller.dart';
import 'package:ebbot_flutter_ui/v1/src/controller/ebbot_message_stream_controller.dart';
import 'package:ebbot_flutter_ui/v1/src/controller/ebbot_chat_stream_controller.dart';
import 'package:ebbot_flutter_ui/v1/src/controller/ebbot_notification_controller.dart';
import 'package:ebbot_flutter_ui/v1/src/parser/ebbot_message_parser.dart';
import 'package:ebbot_flutter_ui/v1/src/controller/chat_ui_custom_message_controller.dart';
import 'package:ebbot_flutter_ui/v1/src/service/ebbot_chat_listener_service.dart';
import 'package:ebbot_flutter_ui/v1/src/service/ebbot_notification_service.dart';
import 'package:ebbot_flutter_ui/v1/src/util/ebbot_gpt_user.dart';
import 'package:ebbot_flutter_ui/v1/src/util/string_util.dart';
import 'package:flutter/material.dart';
import 'package:ebbot_dart_client/ebbot_dart_client.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:get_it/get_it.dart';
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

  final _typingUsers = <types.User>[];
  late EbbotDartClient ebbotClient;
  bool hasReceivedGPTMessageBefore = false;
  late ChatInputController _chatInputController;
  late EbbotNotificationController _notificationController;
  late ChatUiCustomMessageController _chatUiCustomMessageController;
  late EbbotMessageStreamController _ebbotMessageStreamController;
  late EbbotChatStreamController _ebbotChatStreamController;

  late InputOptions _inputOptions;
  late Visibility _customBottomWidgetVisibility = Visibility(
    visible: false,
    child: Container(),
  ); // Slightly hacky way to make sure we have an initial widget
  late bool _customBottomWidgetVisibilityVisible = false;
  late Input _customBottomWidget;

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

    // Register the services in the service locator
    await registerServices();
    // Initialize the controllers
    initalizeControllers();

    // We are ready to start receiving messages
    // TODO: Should handle this more gracefully
    GetIt.I.get<EbbotChatListenerService>().client.startReceive();
    _handleInputMode("visible");

    isInitialized = true;
  }

  Future<void> registerServices() async {
    // Unregister any existing services, this happens if the widget is re-initialized
    try {
      await GetIt.I.unregister<EbbotNotificationService>();
      await GetIt.I.unregister<EbbotChatListenerService>();
    } catch (e) {
      logger.w("Failed to unregister services: $e");
    }

    GetIt.I.registerSingleton<EbbotNotificationService>(
        EbbotNotificationService(ebbotClient.notifications));
    GetIt.I.registerSingleton<EbbotChatListenerService>(
        EbbotChatListenerService(ebbotClient));
  }

  void initalizeControllers() {
    _chatInputController = ChatInputController(
      enabled: true,
      enterPressedBehaviour: widget._configuration.behaviour.input.enterPressed,
      onTextChanged: _handleOnTextChanged,
    );

    _notificationController = EbbotNotificationController(_handleNotification);

    _chatUiCustomMessageController = ChatUiCustomMessageController(
        client: ebbotClient,
        ebbotFlutterUiState: this,
        configuration: widget._configuration,
        handleRestartConversation: initialize);

    _ebbotMessageStreamController = EbbotMessageStreamController(
      _handleTypingUsers,
      _handleClearTypingUsers,
      _handleAddMessage,
      _handleInputMode,
    );

    // Not currently used
    _ebbotChatStreamController = EbbotChatStreamController(
      _handleTypingUsers,
      _handleClearTypingUsers,
      _handleAddMessage,
      _handleInputMode,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (!isInitialized) {
      return Scaffold(
        body: circularProgressIndicator(),
      );
    }

    _inputOptions = _chatInputController.inputOptions;

    var chat = Chat(
      inputOptions: _inputOptions,
      theme: widget._configuration.theme,
      messages: _messages,
      onSendPressed: _handleSendPressed,
      onMessageTap: _handleMessageTap,
      user: _user!,
      customBottomWidget: _customBottomWidgetVisibility,
      customMessageBuilder: _chatUiCustomMessageController.processMessage,
      typingIndicatorOptions: TypingIndicatorOptions(
          typingMode: TypingIndicatorMode.avatar, typingUsers: _typingUsers),
    );

    _customBottomWidget = Input(
        onSendPressed: chat.onSendPressed,
        onAttachmentPressed: chat.onAttachmentPressed,
        options: _inputOptions);

    _customBottomWidgetVisibility = Visibility(
        //maintainSize: _customBottomWidgetVisibilityVisible,
        //maintainAnimation: _customBottomWidgetVisibilityVisible,
        visible: true,
        child: _customBottomWidget);

    return Scaffold(
      body: chat,
    );
  }

  Widget circularProgressIndicator() {
    return Center(
        child: CircularProgressIndicator(
            color: widget._configuration.theme.primaryColor));
  }

  void _handleTypingUsers() {
    logger.i("handling typing message");
    setState(() {
      _typingUsers.clear();
      _typingUsers.add(ebbotGPTUser);
    });
  }

  void _handleClearTypingUsers() {
    logger.i("clearing typing users");
    setState(() {
      _typingUsers.clear();
    });
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

  void _handleInputMode(String? inputMode) {
    logger.i("_handleInputMode: $inputMode");
    setState(() {
      switch (inputMode) {
        case 'hidden':
          logger.i("setting input mode to hidden");
          _inputOptions = _chatInputController.setEnabled(false);
          _customBottomWidgetVisibilityVisible = false;
          break;
        case 'visible':
          logger.i("setting input mode to visible");
          _inputOptions = _chatInputController.setEnabled(true);
          _customBottomWidgetVisibilityVisible = true;
          break;
        case 'disabled':
          logger.i("setting input mode to disabled");
          _inputOptions = _chatInputController.setEnabled(false);
          _customBottomWidgetVisibilityVisible = true;
          break;
        default:
          logger.i("got unknown input mode: $inputMode");
          break;
      }
    });
  }

  void _setInputOptions(InputOptions options) {
    setState(() {
      _inputOptions = options;
    });
  }

  void _handleAddMessage(types.Message? message) {
    if (message == null) {
      logger.w("message is null, so skipping..");
      return;
    }

    setState(() {
      _messages.insert(0, message);
    });
  }

  void _handleOnTextChanged(String text) {
    _handleSendPressed(types.PartialText(text: text));
  }

  // TODO: refactor this to a controller
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

  // TODO: refactor this to a controller
  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user!,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: StringUtil.randomString(),
      text: message.text,
    );

    _handleAddMessage(textMessage);
    ebbotClient.sendTextMessage(textMessage.text);
    _chatInputController.textEditingController.clear();
  }
}
