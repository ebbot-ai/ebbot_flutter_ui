import 'package:ebbot_flutter_ui/v1/configuration/ebbot_behaviour.dart';
import 'package:ebbot_flutter_ui/v1/src/controller/chat_input_field_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:logger/logger.dart';

class ChatInputController {
  bool enabled;
  EbbotBehaviourInputEnterPressed enterPressedBehaviour;
  late InputOptions _inputOptions;
  InputOptions get inputOptions => _inputOptions;
  Function(String) onTextChanged;
  ChatInputFieldController textEditingController = ChatInputFieldController();

  InputOptions setEnabled(bool isEnabled) {
    enabled = isEnabled;
    _inputOptions = InputOptions(
        enabled: enabled,
        onTextChanged: _inputOptions.onTextChanged,
        textEditingController: _inputOptions.textEditingController);

    return _inputOptions;
  }

  final logger = Logger(
    printer: PrettyPrinter(),
  );

  ChatInputController({
    required this.enabled,
    required this.enterPressedBehaviour,
    required this.onTextChanged,
  }) {
    _inputOptions = InputOptions(
        enabled: enabled,
        onTextChanged: _handleOnTextChanged,
        textEditingController: textEditingController);

    textEditingController.addListener(() {
      _handleOnTextChanged(textEditingController.controller.text);
    });
  }

  void _handleOnTextChanged(String text) {
    if (text.isEmpty) {
      logger.i("text is empty, so skipping..");
      return;
    }

    if (enterPressedBehaviour != EbbotBehaviourInputEnterPressed.sendMessage) {
      logger
          .i("enterPressedBehaviour is $enterPressedBehaviour, so skipping..");
      return;
    }

    if (!text.endsWith('\n')) {
      logger.i("text does not end with newline, so skipping..");
      return;
    }

    logger.i("text does end with newline, so sending..");
    text = text.substring(0, text.length - 1);

    onTextChanged(text);

    textEditingController.clear();
  }
}
