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

  ChatInputController({
    required this.enabled,
    required this.enterPressedBehaviour,
    required this.onTextChanged,
  }) {
    _inputOptions = InputOptions(
        enabled: enabled,
        onTextChanged: onTextChanged,
        textEditingController: textEditingController);

    textEditingController.addListener(() {
      onTextChanged(textEditingController.controller.text);
    });
  }
}
