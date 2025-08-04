import 'dart:async';

import 'package:ebbot_flutter_ui/ebbot_flutter_ui.dart';
import 'package:ebbot_flutter_ui_example/app_data/demo_app_with_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';

Future<void> onLoadError(EbbotLoadError error) async {
  //print("CALLBACK: onLoadError: $error");
}

bool hasAlreadyRestarted = false;

Future<void> onLoad() async {
  //print("CALLBACK: onLoad");
}

Future<void> onRestartConversation() async {
  //print("CALLBACK: onRestartConversation");
}

Future<void> onEndConversation() async {
  //print("CALLBACK: onEndConversation");
}

Future<void> onMessage(String message) async {
  //print("CALLBACK: onMessage: $message");
}

Future<void> onBotMessage(String message) async {
  //print("CALLBACK: onBotMessage: $message");
}

Future<void> onUserMessage(String message) async {
  //print("CALLBACK: onUserMessage: $message");
}

Future<void> onStartConversation(String message) async {
  //print("CALLBACK: onStartConversation");
}

Future<void> onSessionData(String chatId) async {
  //print("CALLBACK: onSessionData, chatId: $chatId");
}

var apiController = EbbotApiController();

var botsAndEnvs = Map<Clients, Client>.from({
  Clients.husqvarna: const Client(
      "ebqqtpv3h1qzwflhfroyzc7jzdxqqx", Environment.googleEUProduction),
  Clients.forest: const Client(
      "ebypvbmu3ryfsei5gjzyfsrthz48fq", Environment.ovhEUProduction),
  Clients.ebbotTest: const Client(
      "eb28zly33rwflwrb3bcerqr3oe9gd0", Environment.ovhEUProduction),
});

class Client {
  final String botId;
  final Environment environment;
  const Client(this.botId, this.environment);
}

enum Clients { husqvarna, forest, ebbotTest }

Future main() async {
  //var botId = "ebypvbmu3ryfsei5gjzyfsrthz48fq";

  var client = botsAndEnvs[Clients.forest];
  if (client == null) {
    throw Exception("Client not found");
  }

  var (botId, environment) = (client.botId, client.environment);

  var userAttributes = {
    'name': 'John Doe',
    'email': 'john@doe.com',
    'age': 30,
    'height': 180.0,
    'isPremium': true,
    'lastLogin': DateTime.now().millisecondsSinceEpoch
  };

  var userConfiguration =
      EbbotUserConfigurationBuilder().userAttributes(userAttributes).build();

  var callback = EbbotCallbackBuilder()
      .onLoadError(onLoadError)
      .onLoad(onLoad)
      .onRestartConversation(onRestartConversation)
      .onEndConversation(onEndConversation)
      .onMessage(onMessage)
      .onBotMessage(onBotMessage)
      .onUserMessage(onUserMessage)
      .onStartConversation(onStartConversation)
      .onSessionData(onSessionData)
      .build();

  var ebbotBehaviourInput = EbbotBehaviourInputBuilder()
      .enterPressed(EbbotBehaviourInputEnterPressed.sendMessage)
      .build();
  var behaviour = EbbotBehaviourBuilder()
      .input(ebbotBehaviourInput)
      .showContextMenu(true)
      .build();

  var logConfiguration = EbbotLogConfigurationBuilder()
      .logLevel(EbbotLogLevel.debug)
      .enabled(true)
      .build();

  var session = EbbotSessionBuilder()
      .chatId("1749557756986-fa8037bd-78ac-4bbc-bb50-f093aa1f4969")
      .build();

  //var chat = EbbotChatBuilder().

  var configuration = EbbotConfigurationBuilder()
      .apiController(apiController)
      .environment(environment)
      //.userConfiguration(userConfiguration)
      .behaviour(behaviour)
      .callback(callback)
      .logConfiguration(logConfiguration)
      //.session(session)
      //.chat(chat)
      .build();

  runApp(EbbotDemoAppWithPages(botId: botId, configuration: configuration));
}

class ForestChatTheme extends DefaultChatTheme {
  const ForestChatTheme(
      {super.primaryColor = const Color(0xFF00A372),
      super.userAvatarImageBackgroundColor = const Color(0xFF00A372),
      super.userAvatarNameColors = const [Color(0xFF00A372)],
      super.typingIndicatorTheme = const TypingIndicatorTheme(
        animatedCirclesColor: neutral1,
        animatedCircleSize: 5.0,
        bubbleBorder: BorderRadius.all(Radius.circular(27.0)),
        bubbleColor: neutral7,
        countAvatarColor: Color(0xFF00A372),
        countTextColor: Color(0xFF00A372),
        multipleUserTextStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: neutral2,
        ),
      )});
}
