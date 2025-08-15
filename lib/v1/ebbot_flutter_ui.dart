import 'dart:async';
import 'dart:collection';
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
import 'package:ebbot_flutter_ui/v1/src/widget/context_menu_widget.dart';
import 'package:ebbot_flutter_ui/v1/src/widget/markdown_text_widget.dart';
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

/// The main Ebbot Flutter UI widget.
///
/// This widget provides a complete chat interface that connects to Ebbot's
/// backend services. It includes features like:
/// - Real-time messaging with WebSocket support
/// - Image upload capabilities
/// - Session management and recovery
/// - Customizable themes and behaviors
/// - Agent handover support
/// - Conversation transcripts
/// - Context menu with actions
///
/// ## Basic Usage
///
/// ```dart
/// EbbotFlutterUi(
///   botId: 'your-bot-id',
///   configuration: EbbotConfigurationBuilder()
///     .environment(Environment.production)
///     .build(),
/// )
/// ```
///
/// ## Advanced Usage
///
/// ```dart
/// EbbotFlutterUi(
///   botId: 'your-bot-id',
///   configuration: EbbotConfigurationBuilder()
///     .environment(Environment.production)
///     .userConfiguration(
///       EbbotUserConfigurationBuilder()
///         .userAttributes({'userId': '123', 'name': 'John'})
///         .build()
///     )
///     .behaviour(
///       EbbotBehaviourBuilder()
///         .showContextMenu(true)
///         .build()
///     )
///     .callback(
///       EbbotCallbackBuilder()
///         .onMessage((message) => print('Message: $message'))
///         .onLoad(() => print('Chat loaded'))
///         .build()
///     )
///     .build(),
/// )
/// ```
class EbbotFlutterUi extends StatefulWidget {
  final String _botId;
  final EbbotConfiguration _configuration;

  /// Creates an Ebbot Flutter UI widget.
  ///
  /// Parameters:
  /// - [botId]: The unique identifier for your Ebbot bot (required)
  /// - [configuration]: Optional configuration for customizing the chat behavior.
  ///   If not provided, default configuration will be used.
  /// - [key]: Optional key for the widget
  ///
  /// Example:
  /// ```dart
  /// EbbotFlutterUi(
  ///   botId: 'your-bot-id',
  ///   configuration: EbbotConfigurationBuilder()
  ///     .environment(Environment.production)
  ///     .build(),
  /// )
  /// ```
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

  // Message throttling
  final Queue<types.Message> _messageQueue = Queue<types.Message>();
  Timer? _messageTimer;
  bool hasReceivedGPTMessageBefore = false;

  late EbbotServiceInitializer _ebbotServiceInitializer;
  late EbbotControllerInitializer _ebbotControllerInitializer;

  // Start page states
  bool _isChatStarted =
      false; // This is toggled when the user sends their first chat message
  bool _startPageDismissed = false;
  bool _infoDialogInChatShown = false;
  bool _isChatRestarted = false;
  bool _inputBoxVisible = true;
  bool _hasAgentHandover = false;

  bool get _shouldUsePassedChatId =>
      widget._configuration.session.chatId != null &&
      !_isChatRestarted; // If chatId is passed and we are not restarting

  Logger? _logger;

  @override
  void initState() {
    super.initState();

    _initialize();
  }

  @override
  void dispose() {
    super.dispose();
    _logger?.i("Disposing EbbotFlutterUiState");
    _messageTimer?.cancel();
    _serviceLocator.getService<EbbotDartClientService>().client.closeAsync();
    _serviceLocator.reset();
  }

  @override
  bool get wantKeepAlive => true;

  // Initialization methods

  void _initialize() async {
    final sessionConfiguration = SessionConfigurationBuilder();

    if (_shouldUsePassedChatId) {
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
    _logger?.d("bottom widget visibility: $_inputBoxVisible");
    _logger?.d("Chat started: $_isChatStarted");

    final startPageEnabled = config?.start_page_enabled ?? false;
    final shouldShowStartPage =
        !_startPageDismissed && startPageEnabled && !_shouldUsePassedChatId;

    final passedConfig = widget._configuration;

    final shouldRenderContextMenu = passedConfig.behaviour.showContextMenu;

    return Scaffold(
      body: Stack(
        children: [
          _buildChat(chatTheme: chatTheme),
          if (shouldRenderContextMenu) _buildContextMenu(),
          if (shouldShowStartPage) _buildStartPageWidget()
        ],
      ),
    );
  }

  @override
  void handleAgentHandover() {
    // Make sure we always show the input box from now on
    setState(() {
      _inputBoxVisible = true;
      _hasAgentHandover = true;
    });
  }

  @override
  void handleChatClosed() {
    _logger?.d("Chat is closed, hiding input box");
    setState(() {
      _inputBoxVisible = false;
      _hasAgentHandover = false;
    });
  }

  @override
  void handleTypingUsers() {
    final ebbotSupportService =
        _serviceLocator.getService<EbbotSupportService>();
    setState(() {
      _typingUsers.clear();

      _typingUsers.add(ebbotSupportService.getEbbotUser());
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
    final visibility = switch (inputMode) {
      'hidden' => false,
      'visible' => true,
      'disabled' => false,
      _ => null, // Default case, do nothing
    };

    _logger?.i(
        "handling input mode: $inputMode, setting input mode to $visibility");

    if (visibility != null) {
      setState(() {
        _inputBoxVisible = visibility;
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

      if (message.author == ebbotSupportService.getEbbotUser()) {
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

    // Check if message throttling is enabled and this is not a user message
    final throttlingConfig = widget._configuration.behaviour.messageThrottling;
    final isUserMessage = message.author == chatUser;

    if (throttlingConfig.enabled && !isUserMessage) {
      // Add to queue for throttled delivery
      _messageQueue.add(message);
      _startMessageTimer();
    } else {
      // Add immediately for user messages or when throttling is disabled
      _addMessageToList(message);
    }
  }

  @override
  void handleOnTextChanged(String text) {
    handleSendPressed(types.PartialText(text: text));
  }

  void _addMessageToList(types.Message message) {
    setState(() {
      _logger?.d(
          "adding message of type ${message.type} from user ${message.author.id}");
      _messages.insert(0, message);
    });
  }

  void _startMessageTimer() {
    if (_messageTimer?.isActive == true) {
      return; // Timer already running
    }

    final throttlingConfig = widget._configuration.behaviour.messageThrottling;
    _messageTimer = Timer.periodic(throttlingConfig.delayBetweenMessages, (_) {
      _processNextMessage();
    });

    // Process first message immediately
    _processNextMessage();
  }

  void _processNextMessage() {
    if (_messageQueue.isEmpty) {
      _messageTimer?.cancel();
      _messageTimer = null;
      return;
    }

    final message = _messageQueue.removeFirst();
    _addMessageToList(message);
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
      _hasAgentHandover = false;
      _messages.clear();
      _messageQueue.clear();
    });

    _messageTimer?.cancel();
    _messageTimer = null;

    _logger
        ?.i("Restarting conversation, clearing messages and resetting state");

    final ebbotSupportService =
        _serviceLocator.getService<EbbotSupportService>();

    ebbotSupportService
        .resetEbbotUser(); // This makes sure we reset the user to GPT if there has been an agent handover

    final ebbotClientService =
        _serviceLocator.getService<EbbotDartClientService>();
    await ebbotClientService.restartAsync();

    _ebbotControllerInitializer.resetControllers();

    await _postInitSetup();

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
  void handleOnPopupMenuSelected(ContextMenuOptions option) {
    switch (option) {
      case ContextMenuOptions.restartChat:
        handleRestartConversation();
        break;
      case ContextMenuOptions.downloadTranscript:
        handleDownloadTranscript();
        break;
      case ContextMenuOptions.endConversation:
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
      showUserAvatars: true,
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
      textMessageBuilder: _buildTextMessage,
      typingIndicatorOptions: TypingIndicatorOptions(
        typingMode: TypingIndicatorMode.avatar,
        typingUsers: _typingUsers,
      ),
    );
  }

  /// Custom text message builder that handles markdown formatting
  Widget _buildTextMessage(types.TextMessage message,
      {required int messageWidth, required bool showName}) {
    final isReceived = message.author.id != chatUser.id;

    // Wrap in Container with padding to match default text message styling
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 8.0,
      ),
      child: MarkdownTextWidget(
        text: message.text,
        isReceived: isReceived,
      ),
    );
  }

  Widget _buildContextMenu() {
    return Positioned(
      top: 0,
      right: 10,
      child: AnimatedOpacity(
        opacity: _isChatStarted ? 1.0 : 0,
        duration: const Duration(milliseconds: 300),
        child: ContextMenuWidget(onSelected: handleOnPopupMenuSelected),
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
