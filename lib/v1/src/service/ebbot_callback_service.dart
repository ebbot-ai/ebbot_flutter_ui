import 'package:ebbot_flutter_ui/v1/configuration/ebbot_callback.dart';

class EbbotCallbackService {
  final EbbotCallback _callback;
  EbbotCallbackService(this._callback);

  void dispatchInitializationError(EbbotInitializationError error) {
    _callback.dispatchInitializationError(error);
  }

  void dispatchOnLoad() {
    _callback.dispatchOnLoad();
  }

  void dispatchOnReset() {
    _callback.dispatchOnReset();
  }

  void dispatchOnMessage(String message) {
    // TODO: Implement
    _callback.dispatchOnMessage(message);
  }

  void dispatchOnBotMessage(String message) {
    _callback.dispatchOnBotMessage(message);
  }

  void dispatchOnUserMessage(String message) {
    _callback.dispatchOnUserMessage(message);
  }

  void dispatchOnStartConversation(String message) {
    // TODO: Implement
    _callback.dispatchOnStartConversation(message);
  }
}
