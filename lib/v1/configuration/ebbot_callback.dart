class EbbotCallback extends AbstractEbbotCallback {
  final void Function(EbbotLoadError error) onLoadError;

  final void Function() onLoad;
  final void Function() onRestartConversation;
  final void Function() onEndConversation;
  final void Function() onChatClosed;
  final void Function(String message) onMessage;
  final void Function(String message) onBotMessage;
  final void Function(String message) onUserMessage;
  final void Function(String message) onStartConversation;
  final void Function(String chatId) onSessionData;
  final void Function(bool isVisible) onInputVisibilityChanged;
  final void Function(bool isTyping, String? typingEntity) onTypingChanged;
  final void Function() onAgentHandover;
  final void Function() onConversationRestart;

  EbbotCallback({
    required this.onLoadError,
    required this.onLoad,
    required this.onRestartConversation,
    required this.onEndConversation,
    required this.onChatClosed,
    required this.onMessage,
    required this.onBotMessage,
    required this.onUserMessage,
    required this.onStartConversation,
    required this.onSessionData,
    required this.onInputVisibilityChanged,
    required this.onTypingChanged,
    required this.onAgentHandover,
    required this.onConversationRestart,
  });

  @override
  void dispatchLoadError(EbbotLoadError error) async {
    onLoadError(error);
  }

  @override
  void dispatchOnLoad() async {
    onLoad();
  }

  @override
  void dispatchOnRestartConversation() async {
    onRestartConversation();
  }

  @override
  void dispatchOnEndConversation() async {
    onEndConversation();
  }

  @override
  void dispatchOnChatClosed() async {
    onChatClosed();
  }

  @override
  void dispatchOnMessage(String message) async {
    onMessage(message);
  }

  @override
  void dispatchOnBotMessage(String message) async {
    onBotMessage(message);
  }

  @override
  void dispatchOnUserMessage(String message) async {
    onUserMessage(message);
  }

  @override
  void dispatchOnStartConversation(String message) async {
    onStartConversation(message);
  }

  @override
  void dispatchOnSessionData(String chatId) async {
    onSessionData(chatId);
  }

  @override
  void dispatchOnInputVisibilityChanged(bool isVisible) async {
    onInputVisibilityChanged(isVisible);
  }

  @override
  void dispatchOnTypingChanged(bool isTyping, String? typingEntity) async {
    onTypingChanged(isTyping, typingEntity);
  }

  @override
  void dispatchOnAgentHandover() async {
    onAgentHandover();
  }

  @override
  void dispatchOnConversationRestart() async {
    onConversationRestart();
  }
}

abstract class AbstractEbbotCallback {
  void dispatchLoadError(EbbotLoadError error);
  void dispatchOnLoad();
  void dispatchOnRestartConversation();
  void dispatchOnEndConversation();
  void dispatchOnChatClosed();
  void dispatchOnMessage(String message);
  void dispatchOnBotMessage(String message);
  void dispatchOnUserMessage(String message);
  void dispatchOnStartConversation(String message);
  void dispatchOnSessionData(String chatId);
  void dispatchOnInputVisibilityChanged(bool isVisible);
  void dispatchOnTypingChanged(bool isTyping, String? typingEntity);
  void dispatchOnAgentHandover();
  void dispatchOnConversationRestart();
}

class EbbotCallbackBuilder {
  void Function(EbbotLoadError error) _onLoadError = (error) {};
  void Function() _onLoad = () {};
  void Function() _onRestartConversation = () {};
  void Function() _onEndConversation = () {};
  void Function() _onChatClosed = () {};
  void Function(String message) _onMessage = (message) {};
  void Function(String message) _onBotMessage = (message) {};
  void Function(String message) _onUserMessage = (message) {};
  void Function(String message) _onStartConversation = (message) {};
  void Function(String chatId) _onSessionData = (chatId) {};
  void Function(bool isVisible) _onInputVisibilityChanged = (isVisible) {};
  void Function(bool isTyping, String? typingEntity) _onTypingChanged = (isTyping, typingEntity) {};
  void Function() _onAgentHandover = () {};
  void Function() _onConversationRestart = () {};

  EbbotCallbackBuilder onLoadError(
      void Function(EbbotLoadError error) onLoadError) {
    _onLoadError = onLoadError;
    return this;
  }

  EbbotCallbackBuilder onLoad(void Function() onLoad) {
    _onLoad = onLoad;
    return this;
  }

  EbbotCallbackBuilder onRestartConversation(
      void Function() onRestartConversation) {
    _onRestartConversation = onRestartConversation;
    return this;
  }

  EbbotCallbackBuilder onEndConversation(void Function() onEndConversation) {
    _onEndConversation = onEndConversation;
    return this;
  }

  EbbotCallbackBuilder onChatClosed(void Function() onChatClosed) {
    _onChatClosed = onChatClosed;
    return this;
  }

  EbbotCallbackBuilder onMessage(void Function(String message) onMessage) {
    _onMessage = onMessage;
    return this;
  }

  EbbotCallbackBuilder onBotMessage(
      void Function(String message) onBotMessage) {
    _onBotMessage = onBotMessage;
    return this;
  }

  EbbotCallbackBuilder onUserMessage(
      void Function(String message) onUserMessage) {
    _onUserMessage = onUserMessage;
    return this;
  }

  EbbotCallbackBuilder onStartConversation(
      void Function(String message) onStartConversation) {
    _onStartConversation = onStartConversation;
    return this;
  }

  EbbotCallbackBuilder onSessionData(
      void Function(String chatId) onSessionData) {
    _onSessionData = onSessionData;
    return this;
  }

  EbbotCallbackBuilder onInputVisibilityChanged(
      void Function(bool isVisible) onInputVisibilityChanged) {
    _onInputVisibilityChanged = onInputVisibilityChanged;
    return this;
  }

  EbbotCallbackBuilder onTypingChanged(
      void Function(bool isTyping, String? typingEntity) onTypingChanged) {
    _onTypingChanged = onTypingChanged;
    return this;
  }

  EbbotCallbackBuilder onAgentHandover(void Function() onAgentHandover) {
    _onAgentHandover = onAgentHandover;
    return this;
  }

  EbbotCallbackBuilder onConversationRestart(
      void Function() onConversationRestart) {
    _onConversationRestart = onConversationRestart;
    return this;
  }

  EbbotCallback build() {
    return EbbotCallback(
      onLoadError: _onLoadError,
      onLoad: _onLoad,
      onRestartConversation: _onRestartConversation,
      onEndConversation: _onEndConversation,
      onChatClosed: _onChatClosed,
      onMessage: _onMessage,
      onBotMessage: _onBotMessage,
      onUserMessage: _onUserMessage,
      onStartConversation: _onStartConversation,
      onSessionData: _onSessionData,
      onInputVisibilityChanged: _onInputVisibilityChanged,
      onTypingChanged: _onTypingChanged,
      onAgentHandover: _onAgentHandover,
      onConversationRestart: _onConversationRestart,
    );
  }
}

// Error types
enum EbbotInitializationErrorType {
  network,
  initialization,
}

class EbbotLoadError {
  final EbbotInitializationErrorType type;
  final dynamic cause;
  final StackTrace? stackTrace;
  EbbotLoadError(this.type, this.cause, this.stackTrace);
}
