import 'dart:io';

import 'package:ebbot_dart_client/configuration/configuration.dart';
import 'package:ebbot_dart_client/configuration/log_configuration.dart';
import 'package:ebbot_dart_client/configuration/session_configuration.dart';
import 'package:ebbot_dart_client/ebbot_dart_client.dart';
import 'package:ebbot_flutter_ui/v1/configuration/ebbot_configuration.dart';
import 'package:ebbot_flutter_ui/v1/configuration/ebbot_log_configuration.dart';
import 'package:ebbot_flutter_ui/v1/src/initializer/ebbot_controller_initializer.dart';
import 'package:ebbot_flutter_ui/v1/src/initializer/ebbot_service_initializer.dart';
import 'package:ebbot_flutter_ui/v1/src/initializer/service_locator.dart';
import 'package:ebbot_flutter_ui/v1/src/service/chat_transcript_service.dart';
import 'package:ebbot_flutter_ui/v1/src/service/ebbot_callback_service.dart';
import 'package:ebbot_flutter_ui/v1/src/service/ebbot_dart_client_service.dart';
import 'package:ebbot_flutter_ui/v1/src/service/log_service.dart';
import 'package:ebbot_flutter_ui/v1/src/util/ebbot_gpt_user.dart';
import 'package:ebbot_flutter_ui/v1/src/util/string_util.dart';
import 'package:ebbot_flutter_ui/v1/src/widget/popup_menu_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

class EbbotFlutterUi extends StatefulWidget {
  final String _botId;
  final EbbotConfiguration _configuration;

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

class EbbotFlutterUiState extends State<EbbotFlutterUi>
    with AutomaticKeepAliveClientMixin
    implements AbstractControllerDelegate {
  final ServiceLocator _serviceLocator = ServiceLocator();
  final List<types.Message> _messages = [];

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;
  bool _isChatStarted =
      false; // This is toggled when the user sends their first chat message

  final _typingUsers = <types.User>[];
  bool hasReceivedGPTMessageBefore = false;

  late EbbotServiceInitializer _ebbotServiceInitializer;
  late EbbotControllerInitializer _ebbotControllerInitializer;

  late bool _customBottomWidgetVisibilityVisible = false;

  Logger? _logger;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  @override
  void dispose() {
    super.dispose();
    _serviceLocator.getService<EbbotDartClientService>().client.closeAsync();
    _serviceLocator.reset();
  }

  @override
  bool get wantKeepAlive => true;

  void _initialize() async {
    final sessionConfiguration = SessionConfigurationBuilder();

    if (widget._configuration.session.chatId != null) {
      sessionConfiguration.chatId(widget._configuration.session.chatId!);
    }

    var configuration = ConfigurationBuilder()
        .environment(widget._configuration.environment)
        .sessionConfiguration(sessionConfiguration.build())
        .logConfiguration(LogConfigurationBuilder()
            .enabled(widget._configuration.logConfiguration.enabled)
            .logLevel(widget._configuration.logConfiguration.logLevel.level)
            .build())
        .build();

    _ebbotServiceInitializer = EbbotServiceInitializer(
        widget._botId, widget._configuration, configuration);

    _ebbotControllerInitializer =
        EbbotControllerInitializer(this, widget._configuration);

    await _ebbotServiceInitializer.registerServices();
    _ebbotControllerInitializer.intializeControllers();

    widget._configuration.apiController.attach(this);

    _logger = _serviceLocator.getService<LogService>().logger;

    _setup();
  }

  void _setup() {
    final ebbotClientService =
        _serviceLocator.getService<EbbotDartClientService>();
    //_user = types.User(id: ebbotClientService.client.chatId);

    ebbotClientService.client.startReceive();
    handleInputMode("visible");

    final ebbotCallbackService =
        _serviceLocator.getService<EbbotCallbackService>();

    ebbotCallbackService.dispatchOnLoad();
    setState(() {
      _isInitialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final inputOptions =
        _ebbotControllerInitializer.chatInputController?.inputOptions ??
            const InputOptions();

    _logger
        ?.d("bottom widget visibility: $_customBottomWidgetVisibilityVisible");

    return Scaffold(
      body: Stack(
        children: [
          Chat(
            inputOptions: inputOptions,
            theme: widget._configuration.theme,
            messages: _messages,
            onSendPressed: handleSendPressed,
            onMessageTap: handleMessageTap,
            onAttachmentPressed: handleOnAttachmentPressed,
            emptyState: Container(alignment: Alignment.center),
            user: chatUser,
            customBottomWidget: Visibility(
              visible: _customBottomWidgetVisibilityVisible,
              child: Input(
                onSendPressed: handleSendPressed,
                onAttachmentPressed: handleOnAttachmentPressed,
                options: inputOptions,
              ),
            ),
            customMessageBuilder: _ebbotControllerInitializer
                .chatUiCustomMessageController?.processMessage,
            typingIndicatorOptions: TypingIndicatorOptions(
              typingMode: TypingIndicatorMode.avatar,
              typingUsers: _typingUsers,
            ),
          ),
          if (!isInitialized)
            Container(
              color: const Color.fromARGB(85, 255, 255, 255),
              child: circularProgressIndicator(),
            ),
          if (isInitialized)
            Positioned(
              top: 10,
              right: 10,
              child: AnimatedOpacity(
                opacity: _isChatStarted ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: PopupMenuWidget(onSelected: handleOnPopupMenuSelected),
              ),
            ),
        ],
      ),
    );
  }

  Widget circularProgressIndicator() {
    return Center(
        child: CircularProgressIndicator(
            color: widget._configuration.theme.primaryColor));
  }

  @override
  void handleTypingUsers() {
    setState(() {
      _typingUsers.clear();
      _typingUsers.add(ebbotGPTUser);
    });
  }

  @override
  void handleClearTypingUsers() {
    setState(() {
      _typingUsers.clear();
    });
  }

  @override
  void handleNotification(String title, String text) async {
    _logger?.d("handling notification: $title, $text");
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

  @override
  void handleInputMode(String? inputMode) {
    late bool newCustomBottomWidgetVisibilityVisible;

    switch (inputMode) {
      case 'hidden':
        _logger?.i(
            "handling input mode: $inputMode, setting input mode to hidden");

        newCustomBottomWidgetVisibilityVisible = false;
        break;
      case 'visible':
        _logger?.i(
            "handling input mode: $inputMode, setting input mode to visible");

        newCustomBottomWidgetVisibilityVisible = true;
        break;
      case 'disabled':
        _logger?.i(
            "handling input mode: $inputMode, setting input mode to disabled");

        newCustomBottomWidgetVisibilityVisible = false;
        break;
      default:
        _logger?.i(
            "handling unknown input mode: $inputMode, setting input mode to visible");
        // TODO: When replaying messages, they are sometimes not providing a input_field boolean
        // TODO: So we need to set the input mode to visible as a fallback
        // TOOD: This might be a bug in the backend, so we should fix this eventually
        newCustomBottomWidgetVisibilityVisible = true;
    }

    setState(() {
      _customBottomWidgetVisibilityVisible =
          newCustomBottomWidgetVisibilityVisible;
    });
  }

  void handleAddMessageFromString(String message) {
    final textMessage = types.TextMessage(
      author: chatUser,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: StringUtil.randomString(),
      text: message,
    );
    handleAddMessage(textMessage);
    EbbotDartClient ebbotClient =
        _serviceLocator.getService<EbbotDartClientService>().client;
    ebbotClient.sendTextMessage(textMessage.text);
  }

  @override
  void handleAddMessage(types.Message message) {
    final ebbotCallbackService =
        _serviceLocator.getService<EbbotCallbackService>();

    if (message is types.TextMessage) {
      if (_messages.isEmpty) {
        ebbotCallbackService.dispatchOnStartConversation(message.text);
      }

      ebbotCallbackService.dispatchOnMessage(message.text);

      if (message.author == ebbotGPTUser) {
        ebbotCallbackService.dispatchOnBotMessage(message.text);
      }

      if (message.author == chatUser) {
        ebbotCallbackService.dispatchOnUserMessage(message.text);
      }

      // We want to show the chat after the user sends their first message
      // If the sender is configuration, this means that we still have not
      // an active chat going
      if (message.metadata?['sender'] != 'configuration') {
        setState(() {
          _isChatStarted = true;
        });
      }
    }

    // If we have a image uploaded, we need to remove it first, to avoid duplicate messages.
    bool hasPreUploadedImage =
        _messages.any((message) => message.id == 'pre-uploaded-image');
    bool isFromChatUser =
        message.type == MessageType.image && message.author == chatUser;
    if (hasPreUploadedImage && isFromChatUser) {
      _logger?.d(
          "This image has already been added to the message list as it is a uploaded image, skipping");
      return;
    }

    // Go through messages, if the message already exists, dont add it again
    bool hasMessage = _messages.any((element) => element.id == message.id);
    if (hasMessage) {
      _logger?.w(
          "The message of id ${message.id} has already been added to the message list, skipping");
      return;
    }

    setState(() {
      _logger?.d(
          "adding message of type ${message.type} from user ${message.author.id}");

      _messages.insert(0, message);
    });
  }

  @override
  void handleOnTextChanged(String text) {
    handleSendPressed(types.PartialText(text: text));
  }

  @override
  void handleMessageTap(BuildContext _, types.Message message) async {
    if (message is types.FileMessage) {
      var localPath = message.uri;

      if (message.uri.startsWith('http')) {
        try {
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

  @override
  void handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: chatUser,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: StringUtil.randomString(),
      text: message.text,
    );

    handleAddMessage(textMessage);
    EbbotDartClient ebbotClient =
        _serviceLocator.getService<EbbotDartClientService>().client;
    ebbotClient.sendTextMessage(textMessage.text);
    _ebbotControllerInitializer.chatInputController?.chatInputFieldController
        .clear();
  }

  @override
  void handleRestartConversation() async {
    setState(() {
      _customBottomWidgetVisibilityVisible = false;
      _isInitialized = false;
      _messages.clear();
      _isChatStarted = false;
    });

    final ebbotClientService =
        _serviceLocator.getService<EbbotDartClientService>();
    await ebbotClientService.restartAsync();

    _ebbotControllerInitializer.resetControllers();

    _setup();

    setState(() {
      _isInitialized = true;
    });

    final ebbotCallbackService =
        _serviceLocator.getService<EbbotCallbackService>();
    ebbotCallbackService.dispatchOnRestartConversation();
  }

  @override
  void handleEndConversation() {
    final ebbotClientService =
        _serviceLocator.getService<EbbotDartClientService>();
    ebbotClientService.endSession();

    final ebbotCallbackService =
        _serviceLocator.getService<EbbotCallbackService>();
    ebbotCallbackService.dispatchOnEndConversation();
  }

  @override
  void handleDownloadTranscript() async {
    final documentsDir = (await getApplicationDocumentsDirectory()).path;
    final fileName = 'transcript-${DateTime.now().toIso8601String()}.txt';
    final filePath = '$documentsDir/$fileName';

    final file = File(filePath);

    final chatTranscriptService =
        _serviceLocator.getService<ChatTranscriptService>();
    final transcripts = chatTranscriptService.getChatTranscripts();

    await file.writeAsString(transcripts);
    await OpenFilex.open(filePath);
  }

  @override
  void handleOnPopupMenuSelected(PopupMenuOptions option) {
    switch (option) {
      case PopupMenuOptions.restartChat:
        handleRestartConversation();
        break;
      case PopupMenuOptions.downloadTranscript:
        handleDownloadTranscript();
        break;
      case PopupMenuOptions.endConversation:
        handleEndConversation();
        break;
    }
  }

  @override
  void handleOnAttachmentPressed() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      final bytes = await result.readAsBytes();

      EbbotDartClient client =
          _serviceLocator.getService<EbbotDartClientService>().client;

      types.ImageMessage localImageMessage = types.ImageMessage(
        id: "pre-uploaded-image",
        author: chatUser,
        uri: result.path, // Local file path
        name: 'Local Image',
        size: bytes.length, // Size in bytes, if known
      );

      setState(() {
        _messages.insert(0, localImageMessage);
      });

      await client.uploadImage(bytes, result.path);
    }
  }
}
