class EbbotCallback extends AbstractEbbotCallback {
  final void Function(EbbotInitializationError error) onInitializationError;

  final void Function() onLoad;
  final void Function() onReset;
  final void Function(String message) onMessage;
  final void Function(String message) onBotMessage;
  final void Function(String message) onUserMessage;
  final void Function(String message) onStartConversation;

  EbbotCallback({
    required this.onInitializationError,
    required this.onLoad,
    required this.onReset,
    required this.onMessage,
    required this.onBotMessage,
    required this.onUserMessage,
    required this.onStartConversation,
  });

  @override
  void dispatchInitializationError(EbbotInitializationError error) async {
    onInitializationError(error);
  }

  @override
  void dispatchOnLoad() async {
    onLoad();
  }

  @override
  void dispatchOnReset() async {
    onReset();
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
  void dispatchInitializationError(EbbotInitializationError error);
  void dispatchOnLoad();
  void dispatchOnReset();
  void dispatchOnMessage(String message);
  void dispatchOnBotMessage(String message);
  void dispatchOnUserMessage(String message);
  void dispatchOnStartConversation(String message);
}

class EbbotCallbackBuilder {
  void Function(EbbotInitializationError error) _onInitializationError =
      (error) {};
  void Function() _onLoad = () {};
  void Function() _onReset = () {};
  void Function(String message) _onMessage = (message) {};
  void Function(String message) _onBotMessage = (message) {};
  void Function(String message) _onUserMessage = (message) {};
  void Function(String message) _onStartConversation = (message) {};

  EbbotCallbackBuilder onInitializationError(
      void Function(EbbotInitializationError error) onInitializationError) {
    _onInitializationError = onInitializationError;
    return this;
  }

  EbbotCallbackBuilder onLoad(void Function() onLoad) {
    _onLoad = onLoad;
    return this;
  }

  EbbotCallbackBuilder onReset(void Function() onReset) {
    _onReset = onReset;
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
      onInitializationError: _onInitializationError,
      onLoad: _onLoad,
      onReset: _onReset,
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

class EbbotInitializationError {
  final EbbotInitializationErrorType type;
  final dynamic cause;
  final StackTrace? stackTrace;
  EbbotInitializationError(this.type, this.cause, this.stackTrace);
}
