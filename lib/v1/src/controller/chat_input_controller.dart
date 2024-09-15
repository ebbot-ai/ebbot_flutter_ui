import 'package:ebbot_flutter_ui/v1/configuration/ebbot_behaviour.dart';
import 'package:ebbot_flutter_ui/v1/src/controller/chat_input_field_controller.dart';
import 'package:ebbot_flutter_ui/v1/src/service/log_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:get_it/get_it.dart';

class ChatInputController {
  bool enabled;
  EbbotBehaviourInputEnterPressed enterPressedBehaviour;
  Function(String) onTextChanged;
  late ChatInputFieldController chatInputFieldController;

  final logger = GetIt.I.get<LogService>().logger;

  ChatInputController({
    required this.enabled,
    required this.enterPressedBehaviour,
    required this.onTextChanged,
  }) {
    logger?.i("ChatInputController initialized with enabled: $enabled, "
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
      logger?.i("text is empty, so skipping..");
      return;
    }

    if (enterPressedBehaviour != EbbotBehaviourInputEnterPressed.sendMessage) {
      logger
          ?.i("enterPressedBehaviour is $enterPressedBehaviour, so skipping..");
      return;
    }

    if (!text.endsWith('\n')) {
      logger?.i("text does not end with newline, so skipping..");
      return;
    }

    logger?.i("text does end with newline, so sending..");
    text = text.substring(0, text.length - 1);

    onTextChanged(text);

    chatInputFieldController.clear();
  }
}
