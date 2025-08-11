import 'package:ebbot_flutter_ui/v1/configuration/ebbot_configuration.dart';
import 'package:ebbot_flutter_ui/v1/src/controller/chat_input_controller.dart';
import 'package:ebbot_flutter_ui/v1/src/controller/chat_transcript_controller.dart';
import 'package:ebbot_flutter_ui/v1/src/controller/chat_ui_custom_message_controller.dart';
import 'package:ebbot_flutter_ui/v1/src/controller/ebbot_chat_stream_controller.dart';
import 'package:ebbot_flutter_ui/v1/src/controller/ebbot_message_stream_controller.dart';
import 'package:ebbot_flutter_ui/v1/src/widget/context_menu_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';

class EbbotControllerInitializer {
  //final EbbotFlutterUiState ebbotFlutterUiState;
  final EbbotConfiguration configuration;
  final AbstractControllerDelegate controllerDelegates;

  ChatInputController? chatInputController;
  ChatUiCustomMessageController? chatUiCustomMessageController;
  EbbotMessageStreamController? ebbotMessageStreamController;
  EbbotChatStreamController? ebbotChatStreamController;
  ChatTranscriptController? chatTranscriptController;

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
      controllerDelegates.handleAgentHandover,
      controllerDelegates.handleChatClosed,
    );

    chatTranscriptController = ChatTranscriptController();
  }

  // updateControllers is called when the controllers need to reset themselves
  // usually when the the api has been reset and the controllers need to be reset as a result
  void resetControllers() {
    chatTranscriptController?.reset();
    ebbotMessageStreamController?.startListening();
    ebbotChatStreamController?.startListening();
  }
}

abstract class AbstractControllerDelegate {
  void handleOnTextChanged(String text);
  void handleTypingUsers();
  void handleClearTypingUsers();
  void handleAddMessage(Message message);
  void handleInputMode(String? mode);
  void handleRestartConversation();
  void handleSendPressed(String text);
  void handleMessageTap(BuildContext _, Message message);
  void handleEndConversation();
  void handleDownloadTranscript();
  void handleOnPopupMenuSelected(ContextMenuOptions option);
  void handleOnAttachmentPressed();
  void handleAddMessageFromString(String message);
  void handleAgentHandover();
  void handleChatClosed();
}
