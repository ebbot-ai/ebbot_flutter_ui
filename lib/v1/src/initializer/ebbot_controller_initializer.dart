import 'package:ebbot_flutter_ui/v1/configuration/ebbot_configuration.dart';
import 'package:ebbot_flutter_ui/v1/ebbot_flutter_ui.dart';
import 'package:ebbot_flutter_ui/v1/src/controller/chat_input_controller.dart';
import 'package:ebbot_flutter_ui/v1/src/controller/chat_ui_custom_message_controller.dart';
import 'package:ebbot_flutter_ui/v1/src/controller/ebbot_chat_stream_controller.dart';
import 'package:ebbot_flutter_ui/v1/src/controller/ebbot_message_stream_controller.dart';
import 'package:ebbot_flutter_ui/v1/src/controller/ebbot_notification_controller.dart';
import 'package:ebbot_flutter_ui/v1/src/service/ebbot_dart_client_service.dart';
import 'package:ebbot_flutter_ui/v1/src/widget/popup_menu_widget.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class EbbotControllerInitializer {
  //final EbbotFlutterUiState ebbotFlutterUiState;
  final EbbotConfiguration configuration;
  final AbstractControllerDelegate controllerDelegates;

  ChatInputController? chatInputController;
  EbbotNotificationController? notificationController;
  ChatUiCustomMessageController? chatUiCustomMessageController;
  EbbotMessageStreamController? ebbotMessageStreamController;
  EbbotChatStreamController? ebbotChatStreamController;

  EbbotControllerInitializer(
    this.controllerDelegates,
    this.configuration,
  );

  void intializeControllers() {
    chatInputController = ChatInputController(
      enabled: true,
      enterPressedBehaviour: configuration.behaviour.input.enterPressed,
      onTextChanged: controllerDelegates.handleOnTextChanged,
    );

    notificationController =
        EbbotNotificationController(controllerDelegates.handleNotification);

    chatUiCustomMessageController = ChatUiCustomMessageController(
        configuration: configuration,
        handleRestartConversation:
            controllerDelegates.handleRestartConversation);

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

  // updateControllers is called when the controllers need to reset themselves
  // usually when the the api has been reset and the controllers need to be reset as a result
  void resetControllers() {
    ebbotMessageStreamController?.startListening();
    ebbotChatStreamController?.startListening();
  }
}

abstract class AbstractControllerDelegate {
  void handleOnTextChanged(String text);
  void handleNotification(String title, String text);
  void handleTypingUsers();
  void handleClearTypingUsers();
  void handleAddMessage(types.Message? message);
  void handleInputMode(String? mode);
  void handleRestartConversation();
  void handleSendPressed(types.PartialText message);
  void handleMessageTap(BuildContext _, types.Message message);
  void handleEndConversation();
  void handleDownloadTranscript();
  void handleOnPopupMenuSelected(PopupMenuOptions option);
}

abstract class AbstractResettableController {
  void reset();
}
