import 'dart:async';

import 'package:ebbot_flutter_ui/ebbot_flutter_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'app_data/demo_app_with_pages.dart';

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

/// Get bot ID from environment variables
String getBotId() {
  final botId = dotenv.env['BOT_ID'];
  if (botId == null || botId.isEmpty || botId.contains('your_')) {
    print('BOT_ID not found or not configured properly.');
    print(
        'Please ensure .env file exists and contains: BOT_ID=your_actual_bot_id');
    throw Exception(
        'BOT_ID not configured. Please check your .env file.\nCopy .env.example to .env and set your bot ID.');
  }
  return botId;
}

/// Get environment from environment variables
Environment getEnvironment() {
  final envName = dotenv.env['EBBOT_ENVIRONMENT'] ?? 'ovhEUProduction';

  switch (envName.toLowerCase()) {
    case 'googleeuproduction':
      return Environment.googleEUProduction;
    case 'ovheuproduction':
      return Environment.ovhEUProduction;
    case 'staging':
      return Environment.staging;
    default:
      throw Exception(
          'Unknown environment: $envName. Supported: googleEUProduction, ovhEUProduction, staging');
  }
}

Future main() async {
  // Load environment variables
  try {
    await dotenv.load(); // Try default .env file first
  } catch (e) {
    try {
      await dotenv.load(fileName: ".env"); // Try explicit .env
    } catch (e2) {
      print('Could not load .env file. Error: $e2');
      print('Make sure .env file exists in the project root.');
      print('Copy .env.example to .env and configure your bot settings.');

      // For development, let's provide fallback values
      print('Using fallback configuration...');
      // We'll handle this in getBotId() function
    }
  }

  // Get configuration from environment
  final botId = getBotId();
  final environment = getEnvironment();

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

  var session = EbbotSessionBuilder().chatId("some-chat-id").build();

  //var chat = EbbotChatBuilder().

  var configuration = EbbotConfigurationBuilder()
      .apiController(apiController)
      .environment(environment)
      .userConfiguration(userConfiguration)
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
