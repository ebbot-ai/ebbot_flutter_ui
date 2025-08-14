import 'package:flutter/material.dart';

class ChatInputFieldController extends ChangeNotifier {
  final TextEditingController _controller = TextEditingController();
  bool isDisposed = false;

  TextEditingController get controller => _controller;

  void clear() {
    _controller.clear();
  }

  @override
  void dispose() {
    _controller.dispose();
    isDisposed = true;
    super.dispose();
  }
}
