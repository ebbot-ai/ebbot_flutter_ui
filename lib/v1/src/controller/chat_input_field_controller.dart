import 'package:ebbot_flutter_ui/v1/src/service/log_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:get_it/get_it.dart';

class ChatInputFieldController extends InputTextFieldController {
  final TextEditingController _controller = TextEditingController();
  bool isDisposed = false;
  final logger = GetIt.I.get<LogService>().logger;

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
