import 'package:flutter/material.dart';
import 'package:ebbot_chat/ebbot_chat_client.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'dart:math';
import 'dart:convert';

void main() async {
  print("main");
  runApp(const MyApp());
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => MyHomePageState();
}

String randomString() {
  final random = Random.secure();
  final values = List<int>.generate(16, (i) => random.nextInt(255));
  return base64UrlEncode(values);
}

class MyHomePageState extends State<MyHomePage> {
  final List<types.Message> _messages = [];
  final _user = const types.User(id: '82091008-a484-4a89-ae75-a22bf8d6f3ac');
  final _ebbotGPTUser = const types.User(id: 'ebbot-gpt');
  late EbbotChatClient ebbotChatClient;

  @override
  void initState() {
    super.initState();
    print("init state");
    ebbotChatClient = EbbotChatClient('ebqqtpv3h1qzwflhfroyzc7jzdxqqx');

    initEbbotChatClient();
  }

  void initEbbotChatClient() async {
    await ebbotChatClient.initialize();
    ebbotChatClient.listener.chatStream.listen((chat) {
      print('listener got chat: $chat');
    });

    ebbotChatClient.listener.messageStream.listen((message) {
      print('listener got message type: ${message.data.message.type}');
      switch (message.data.message.type) {
        case 'gpt':
          var text = message.data.message.value is String
              ? message.data.message.value
              : message.data.message.value['text'];

          print("message is correct type, so adding it: $text");
          final textMessage = types.TextMessage(
            author: _ebbotGPTUser,
            createdAt: DateTime.now().millisecondsSinceEpoch,
            id: randomString(),
            text: text,
          );

          _addMessage(textMessage);
        default:
          print("dont care about this type: ${message.data.message.type}");
      }
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Chat(
          messages: _messages,
          onSendPressed: _handleSendPressed,
          user: _user,
        ),
      );

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: randomString(),
      text: message.text,
    );

    _addMessage(textMessage);
    ebbotChatClient.sendMessage(textMessage.text);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Play around a bit with ebbot chat

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ebbot Chat Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Ebbot Chat Demo'),
    );
  }
}
