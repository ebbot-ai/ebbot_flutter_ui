class EbbotCallback extends AbstractEbbotCallback {
  final void Function(EbbotLoadError error) onLoadError;

  final void Function() onLoad;
  final void Function() onRestartConversation;
  final void Function() onEndConversation;
  final void Function(String message) onMessage;
  final void Function(String message) onBotMessage;
  final void Function(String message) onUserMessage;
  final void Function(String message) onStartConversation;

  EbbotCallback({
    required this.onLoadError,
    required this.onLoad,
    required this.onRestartConversation,
    required this.onEndConversation,
    required this.onMessage,
    required this.onBotMessage,
    required this.onUserMessage,
    required this.onStartConversation,
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
}

abstract class AbstractEbbotCallback {
  void dispatchLoadError(EbbotLoadError error);
  void dispatchOnLoad();
  void dispatchOnRestartConversation();
  void dispatchOnEndConversation();
  void dispatchOnMessage(String message);
  void dispatchOnBotMessage(String message);
  void dispatchOnUserMessage(String message);
  void dispatchOnStartConversation(String message);
}

class EbbotCallbackBuilder {
  void Function(EbbotLoadError error) _onLoadError = (error) {};
  void Function() _onLoad = () {};
  void Function() _onRestartConversation = () {};
  void Function() _onEndConversation = () {};
  void Function(String message) _onMessage = (message) {};
  void Function(String message) _onBotMessage = (message) {};
  void Function(String message) _onUserMessage = (message) {};
  void Function(String message) _onStartConversation = (message) {};

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

  EbbotCallback build() {
    return EbbotCallback(
      onLoadError: _onLoadError,
      onLoad: _onLoad,
      onRestartConversation: _onRestartConversation,
      onEndConversation: _onEndConversation,
      onMessage: _onMessage,
      onBotMessage: _onBotMessage,
      onUserMessage: _onUserMessage,
      onStartConversation: _onStartConversation,
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
