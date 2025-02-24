import 'package:ebbot_flutter_ui/v1/configuration/ebbot_behaviour.dart';
import 'package:ebbot_flutter_ui/v1/src/controller/chat_input_field_controller.dart';
import 'package:ebbot_flutter_ui/v1/src/initializer/service_locator.dart';
import 'package:ebbot_flutter_ui/v1/src/service/log_service.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';

class ChatInputController {
  bool enabled;
  EbbotBehaviourInputEnterPressed enterPressedBehaviour;
  Function(String) onTextChanged;
  late ChatInputFieldController chatInputFieldController;
  final _serviceLocator = ServiceLocator();
  get _logger => _serviceLocator.getService<LogService>().logger;

  ChatInputController({
    required this.enabled,
    required this.enterPressedBehaviour,
    required this.onTextChanged,
  }) {
    _logger?.i("Initialized with enabled: $enabled, "
        "enterPressedBehaviour: $enterPressedBehaviour");

    _initializeController();
  }

  void _initializeController() {
    chatInputFieldController = ChatInputFieldController();
    chatInputFieldController.addListener(() {
      _handleOnTextChanged(chatInputFieldController.controller.text);
    });
  }

  InputOptions get inputOptions {
    if (chatInputFieldController.isDisposed) {
      _initializeController();
    }

    return InputOptions(
        enabled: enabled,
        onTextChanged: _handleOnTextChanged,
        textEditingController: chatInputFieldController);
  }

  void _handleOnTextChanged(String text) {
    if (text.isEmpty) {
      return;
    }

    if (enterPressedBehaviour != EbbotBehaviourInputEnterPressed.sendMessage) {
      return;
    }

    if (!text.endsWith('\n')) {
      return;
    }

    text = text.substring(0, text.length - 1);

    onTextChanged(text);

    chatInputFieldController.clear();
  }
}
