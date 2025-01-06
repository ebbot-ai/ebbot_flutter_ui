import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';

class ChatInputFieldController extends InputTextFieldController {
  final TextEditingController _controller = TextEditingController();
  bool isDisposed = false;

  TextEditingController get controller => _controller;

  @override
  void clear() {
    super.clear();
    _controller.clear();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    isDisposed = true;
  }
}
