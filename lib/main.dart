import 'package:ebbot_demo/ebbot_ui_widget_fullscreen.dart';
import 'package:flutter/material.dart';
import 'package:ebbot_dart_client/ebbot_chat_client.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:logger/logger.dart';
import 'dart:math';
import 'dart:convert';

import 'package:uuid/uuid.dart';

void main() async {
  runApp(const EbbotDemoApp());
}



class EbbotDemoApp extends StatelessWidget {
  const EbbotDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ebbot Chat Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: HomeWidget(),
    );
  }
}

class HomeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat demo'),
      ),
      body: Center(
        child: OpenDialogButton(),
      ),
    );
  }
}


class OpenDialogButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            final randomChatId = "${DateTime.now().millisecondsSinceEpoch}-${Uuid().v4()}";
            return EbbotUiWidgetFullscreen(botId: 'ebqqtpv3h1qzwflhfroyzc7jzdxqqx');
          },
          barrierDismissible: true,
          barrierColor: Colors.black.withOpacity(0.5),
          barrierLabel: 'Close',
        );
      },
      child: Text('Open chat in fullscreen'),
    );
  }
}
  