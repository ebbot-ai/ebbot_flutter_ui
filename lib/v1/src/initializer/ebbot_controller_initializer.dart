import 'package:ebbot_flutter_ui/v1/configuration/ebbot_configuration.dart';
import 'package:ebbot_flutter_ui/v1/ebbot_flutter_ui.dart';
import 'package:ebbot_flutter_ui/v1/src/controller/chat_input_controller.dart';
import 'package:ebbot_flutter_ui/v1/src/controller/chat_ui_custom_message_controller.dart';
import 'package:ebbot_flutter_ui/v1/src/controller/ebbot_chat_stream_controller.dart';
import 'package:ebbot_flutter_ui/v1/src/controller/ebbot_message_stream_controller.dart';
import 'package:ebbot_flutter_ui/v1/src/controller/ebbot_notification_controller.dart';
import 'package:ebbot_flutter_ui/v1/src/service/ebbot_client_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class EbbotControllerInitializer {
  //final EbbotFlutterUiState ebbotFlutterUiState;
  final EbbotConfiguration configuration;
  final AbstractControllerDelegates controllerDelegates;

  late ChatInputController chatInputController;
  late EbbotNotificationController notificationController;
  late ChatUiCustomMessageController chatUiCustomMessageController;
  late EbbotMessageStreamController ebbotMessageStreamController;
  late EbbotChatStreamController ebbotChatStreamController;

  EbbotControllerInitializer(
    this.controllerDelegates,
    this.configuration,
  );

  void intializeControllers() {
    final ebbotClientService = GetIt.I.get<EbbotClientService>();
    chatInputController = ChatInputController(
      enabled: true,
      enterPressedBehaviour: configuration.behaviour.input.enterPressed,
      onTextChanged: controllerDelegates.handleOnTextChanged,
    );

    notificationController =
        EbbotNotificationController(controllerDelegates.handleNotification);

    chatUiCustomMessageController = ChatUiCustomMessageController(
        client: ebbotClientService.client,
        configuration: configuration,
        handleRestartConversation: controllerDelegates.restartConversation);

    ebbotMessageStreamController = EbbotMessageStreamController(
      controllerDelegates.handleTypingUsers,
      controllerDelegates.handleClearTypingUsers,
      controllerDelegates.handleAddMessage,
      controllerDelegates.handleInputMode,
    );

    ebbotChatStreamController = EbbotChatStreamController(
      controllerDelegates.handleTypingUsers,
      controllerDelegates.handleClearTypingUsers,
      controllerDelegates.handleAddMessage,
      controllerDelegates.handleInputMode,
    );
  }
}

abstract class AbstractControllerDelegates {
  void handleOnTextChanged(String text);
  void handleNotification(String title, String text);
  void handleTypingUsers();
  void handleClearTypingUsers();
  void handleAddMessage(types.Message? message);
  void handleInputMode(String? mode);
  void restartConversation();
  void handleSendPressed(types.PartialText message);
  void handleMessageTap(BuildContext _, types.Message message);
}
