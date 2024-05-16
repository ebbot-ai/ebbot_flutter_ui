import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:logger/logger.dart';

class ChatInputFieldController extends InputTextFieldController {
  final TextEditingController _controller = TextEditingController();
  final logger = Logger(
    printer: PrettyPrinter(),
  );

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
  }
}
