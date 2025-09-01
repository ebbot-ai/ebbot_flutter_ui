import 'package:ebbot_flutter_ui/v1/configuration/ebbot_callback.dart';

class EbbotCallbackService {
  final EbbotCallback _callback;
  EbbotCallbackService(this._callback);

  void dispatchInitializationError(EbbotLoadError error) {
    _callback.dispatchLoadError(error);
  }

  void dispatchOnLoad() {
    _callback.dispatchOnLoad();
  }

  void dispatchOnRestartConversation() {
    _callback.dispatchOnRestartConversation();
  }

  void dispatchOnEndConversation() {
    _callback.dispatchOnEndConversation();
  }

  void dispatchOnChatClosed() {
    _callback.dispatchOnChatClosed();
  }

  void dispatchOnMessage(String message) {
    _callback.dispatchOnMessage(message);
  }

  void dispatchOnBotMessage(String message) {
    _callback.dispatchOnBotMessage(message);
  }

  void dispatchOnUserMessage(String message) {
    _callback.dispatchOnUserMessage(message);
  }

  void dispatchOnStartConversation(String message) {
    _callback.dispatchOnStartConversation(message);
  }

  void dispatchOnSessionData(String chatId) {
    _callback.dispatchOnSessionData(chatId);
  }

  void dispatchOnInputVisibilityChanged(bool isVisible) {
    _callback.dispatchOnInputVisibilityChanged(isVisible);
  }

  void dispatchOnTypingChanged(bool isTyping, String? typingEntity) {
    _callback.dispatchOnTypingChanged(isTyping, typingEntity);
  }

  void dispatchOnAgentHandover() {
    _callback.dispatchOnAgentHandover();
  }

  void dispatchOnConversationRestart() {
    _callback.dispatchOnConversationRestart();
  }
}
