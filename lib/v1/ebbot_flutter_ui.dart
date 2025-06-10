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
import 'package:ebbot_flutter_ui/v1/src/service/ebbot_support_service.dart';
import 'package:ebbot_flutter_ui/v1/src/service/log_service.dart';
import 'package:ebbot_flutter_ui/v1/src/util/ebbot_gpt_user.dart';
import 'package:ebbot_flutter_ui/v1/src/util/extension.dart';
import 'package:ebbot_flutter_ui/v1/src/util/string_util.dart';
import 'package:ebbot_flutter_ui/v1/src/widget/popup_menu_widget.dart';
import 'package:ebbot_flutter_ui/v1/src/widget/start_page_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

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

  final _typingUsers = <types.User>[];
  bool hasReceivedGPTMessageBefore = false;

  late EbbotServiceInitializer _ebbotServiceInitializer;
  late EbbotControllerInitializer _ebbotControllerInitializer;

  // Start page states
  bool _isChatStarted =
      false; // This is toggled when the user sends their first chat message
  bool _startPageDismissed = false;
  bool _infoDialogInChatShown = false;
  bool _shouldUsePassedChatId = true;
  bool _isChatRestarted = false;
  bool _inputBoxVisible = true;

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

  // Initialization methods

  void _initialize() async {
    final sessionConfiguration = SessionConfigurationBuilder();

    if (widget._configuration.session.chatId != null &&
        _shouldUsePassedChatId) {
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
    final ebbotClientService =
        _serviceLocator.getService<EbbotDartClientService>();
    await ebbotClientService.client.initializeWebsocketConnection();
    _ebbotControllerInitializer.intializeControllers();

    widget._configuration.apiController.attach(this);

    _logger = _serviceLocator.getService<LogService>().logger;

    await _postInitSetup();
  }

  Future<void> _postInitSetup() async {
    final ebbotClientService =
        _serviceLocator.getService<EbbotDartClientService>();
    final ebbotCallbackService =
        _serviceLocator.getService<EbbotCallbackService>();
    final userAttributes =
        widget._configuration.userConfiguration.userAttributes;

    ebbotClientService.client.startReceive();
    handleInputMode("visible");

    if (userAttributes.isNotEmpty) {
      ebbotClientService.client
          .sendUpdateConversationInfoMessage(userAttributes);
    }

    ebbotCallbackService.dispatchOnLoad();

    setState(() {
      _isInitialized = true;
      if (widget._configuration.session.chatId != null && !_isChatRestarted) {
        _shouldUsePassedChatId = true;
        _logger?.i(
            "Initialized with chatId: ${widget._configuration.session.chatId}");
      }
    });
  }

  // Overrides

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (!_isInitialized) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: Colors.grey,
          ),
        ),
      );
    }

    final ebbotClientService =
        _serviceLocator.getService<EbbotDartClientService>();

    final ebbotSupportService =
        _serviceLocator.getService<EbbotSupportService>();
    final chatTheme = ebbotSupportService.chatTheme();

    final config = ebbotClientService.client.chatStyleConfig;
    _logger
        ?.d("bottom widget visibility: $_inputBoxVisible");
    _logger?.d("Chat started: $_isChatStarted");

    final startPageEnabled = config?.start_page_enabled ?? false;
    final shouldShowStartPage =
        !_startPageDismissed && startPageEnabled && !_shouldUsePassedChatId;

    return Scaffold(
      body: Stack(
        children: [
          _buildChat(chatTheme: chatTheme),
          _buildPopupMenu(),
          if (shouldShowStartPage) _buildStartPageWidget()
        ],
      ),
    );
  }

  @override
  void handleTypingUsers() {
    final ebbotSupportService =
        _serviceLocator.getService<EbbotSupportService>();
    setState(() {
      _typingUsers.clear();

      _typingUsers.add(ebbotSupportService.getEbbotGPTUser());
    });
  }

  @override
  void handleClearTypingUsers() {
    setState(() {
      _typingUsers.clear();
    });
  }

  @override
  void handleInputMode(String? inputMode) {
    bool? newCustomBottomWidgetVisibilityVisible;

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
        _logger?.i("handling input mode: $inputMode, skip setting input mode");
      // TODO: When replaying messages, they are sometimes not providing a input_field boolean
      // TODO: So we need to set the input mode to visible as a fallback
      // TOOD: This might be a bug in the backend, so we should fix this eventually
      //newCustomBottomWidgetVisibilityVisible = true;
    }

    if (newCustomBottomWidgetVisibilityVisible != null) {
      setState(() {
        _inputBoxVisible =
            newCustomBottomWidgetVisibilityVisible!;
      });
    }
  }

  @override
  void handleAddMessage(types.Message message) {
    _logger?.d("Handling add message: ${message.id} of type ${message.type}");
    final ebbotCallbackService =
        _serviceLocator.getService<EbbotCallbackService>();

    final ebbotSupportService =
        _serviceLocator.getService<EbbotSupportService>();

    if (message is types.TextMessage) {
      _logger?.d("Handling text message: ${message.text}");
      if (_messages.isEmpty) {
        ebbotCallbackService.dispatchOnStartConversation(message.text);
      }

      _logger?.d("Adding message with ID: ${message.id}");

      ebbotCallbackService.dispatchOnMessage(message.text);

      if (message.author == ebbotSupportService.getEbbotGPTUser()) {
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
      _startPageDismissed = false;
      _inputBoxVisible = false;
      _isInitialized = false;
      _isChatStarted = false;
      _isChatRestarted = true;
      _infoDialogInChatShown = false;
      _shouldUsePassedChatId =
          false; // After restart, we don't use the passed chatId
      _messages.clear();
    });

    final ebbotClientService =
        _serviceLocator.getService<EbbotDartClientService>();
    await ebbotClientService.restartAsync();

    _ebbotControllerInitializer.resetControllers();

    _postInitSetup();

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

  @override
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

  // Widgets and UI methods

  void _maybeShowInfoTextDialogInChat() async {
    if (_infoDialogInChatShown) return;

    final ebbotClientService =
        _serviceLocator.getService<EbbotDartClientService>();

    final config = ebbotClientService.client.chatStyleConfig;
    if (config == null) {
      _logger
          ?.w("Chat style configuration is null, cannot show info text dialog");
      return;
    }

    if (!_startPageDismissed) {
      _logger?.w("Info text dialog not shown, start page showing");
      return;
    }

    if (!config.alert_time_window.shouldShow) {
      _logger?.w(
          "Info text dialog not shown, outside of time window: ${config.alert_time_window}");
      return;
    }

    if (!_startPageDismissed) {
      _logger?.w("Info text dialog not shown, start page not dismissed");
      return;
    }

    if (!config.info_section_in_conversation) {
      _logger?.w(
          "Info text dialog not shown, info section not enabled in conversation");
      return;
    }

    final text = config.info_section_text;
    final title = config.info_section_title;

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

    setState(() {
      _infoDialogInChatShown = true;
    });
  }

  Widget _buildChat({required ChatTheme chatTheme}) {
    final inputOptions =
        _ebbotControllerInitializer.chatInputController?.inputOptions ??
            const InputOptions();
    return Chat(
      inputOptions: inputOptions,
      theme: chatTheme,
      messages: _messages,
      onSendPressed: handleSendPressed,
      onMessageTap: handleMessageTap,
      onAttachmentPressed: handleOnAttachmentPressed,
      emptyState: Container(alignment: Alignment.center),
      user: chatUser,
      customBottomWidget: Visibility(
        visible: _inputBoxVisible,
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
    );
  }

  Widget _buildPopupMenu() {
    return Positioned(
      top: 0,
      right: 10,
      child: AnimatedOpacity(
        opacity: _isChatStarted ? 1.0 : 0,
        duration: const Duration(milliseconds: 300),
        child: PopupMenuWidget(onSelected: handleOnPopupMenuSelected),
      ),
    );
  }

  Widget _buildStartPageWidget() {
    return StartPageWidget(
      onCardButtonPressed: ({scenario, url}) async {
        final client = _serviceLocator.getService<EbbotDartClientService>();
        if (scenario != null) {
          client.client.sendScenarioMessage(scenario);

          setState(() {
            _startPageDismissed = true;
          });

          WidgetsBinding.instance.addPostFrameCallback((_) {
            _maybeShowInfoTextDialogInChat();
          });
        }
        if (url != null) {
          // Open the URL in the browser
          _logger?.d("Opening URL: $url");
          final uri = Uri.parse(url);
          if (await canLaunchUrl(uri)) {
            launchUrl(uri);
          } else {
            _logger?.e("Could not launch URL: $url");
          }
        }
      },
      onStartConversation: () {
        _logger?.d("Start page dismissed, starting conversation");
        setState(() {
          _startPageDismissed = true;
          _isChatStarted = true;
        });
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _maybeShowInfoTextDialogInChat();
        });
      },
    );
  }
}
