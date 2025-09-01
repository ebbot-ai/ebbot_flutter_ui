import 'package:ebbot_flutter_ui/v1/configuration/ebbot_callback.dart';
import 'package:ebbot_flutter_ui/v1/src/initializer/service_locator.dart';
import 'package:ebbot_flutter_ui/v1/src/service/log_service.dart';
import 'package:logger/logger.dart';

class EbbotCallbackService {
  final EbbotCallback _callback;
  final ServiceLocator _serviceLocator = ServiceLocator();
  Logger? _logger;
  
  EbbotCallbackService(this._callback) {
    _logger = _serviceLocator.getService<LogService>().logger;
  }

  void dispatchInitializationError(EbbotLoadError error) {
    _logger?.d('Invoking callback: onLoadError (${error.type} - ${error.cause})');
    _callback.dispatchLoadError(error);
  }

  void dispatchOnLoad() {
    _logger?.d('Invoking callback: onLoad');
    _callback.dispatchOnLoad();
  }

  void dispatchOnRestartConversation() {
    _logger?.d('Invoking callback: onRestartConversation');
    _callback.dispatchOnRestartConversation();
  }

  void dispatchOnEndConversation() {
    _logger?.d('Invoking callback: onEndConversation');
    _callback.dispatchOnEndConversation();
  }

  void dispatchOnChatClosed() {
    _logger?.d('Invoking callback: onChatClosed');
    _callback.dispatchOnChatClosed();
  }

  void dispatchOnMessage(String message) {
    _logger?.d('Invoking callback: onMessage: ${message.length > 50 ? '${message.substring(0, 50)}...' : message}');
    _callback.dispatchOnMessage(message);
  }

  void dispatchOnBotMessage(String message) {
    _logger?.d('Invoking callback: onBotMessage: ${message.length > 50 ? '${message.substring(0, 50)}...' : message}');
    _callback.dispatchOnBotMessage(message);
  }

  void dispatchOnUserMessage(String message) {
    _logger?.d('Invoking callback: onUserMessage: ${message.length > 50 ? '${message.substring(0, 50)}...' : message}');
    _callback.dispatchOnUserMessage(message);
  }

  void dispatchOnStartConversation(String message) {
    _logger?.d('Invoking callback: onStartConversation: ${message.length > 50 ? '${message.substring(0, 50)}...' : message}');
    _callback.dispatchOnStartConversation(message);
  }

  void dispatchOnSessionData(String chatId) {
    _logger?.d('Invoking callback: onSessionData: $chatId');
    _callback.dispatchOnSessionData(chatId);
  }

  void dispatchOnInputVisibilityChanged(bool isVisible) {
    _logger?.d('Invoking callback: onInputVisibilityChanged: $isVisible');
    _callback.dispatchOnInputVisibilityChanged(isVisible);
  }

  void dispatchOnTypingChanged(bool isTyping, String? typingEntity) {
    _logger?.d('Invoking callback: onTypingChanged: $isTyping, entity: $typingEntity');
    _callback.dispatchOnTypingChanged(isTyping, typingEntity);
  }

  void dispatchOnAgentHandover() {
    _logger?.d('Invoking callback: onAgentHandover');
    _callback.dispatchOnAgentHandover();
  }

  void dispatchOnConversationRestart() {
    _logger?.d('Invoking callback: onConversationRestart');
    _callback.dispatchOnConversationRestart();
  }
}
