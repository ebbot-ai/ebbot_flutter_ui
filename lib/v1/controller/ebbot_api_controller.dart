import 'package:ebbot_dart_client/ebbot_dart_client.dart';
import 'package:ebbot_flutter_ui/v1/ebbot_flutter_ui.dart';
import 'package:ebbot_flutter_ui/v1/src/initializer/service_locator.dart';
import 'package:ebbot_flutter_ui/v1/src/service/ebbot_dart_client_service.dart';

/// API controller for programmatic control of the Ebbot chat widget.
///
/// This controller allows you to interact with the chat widget programmatically,
/// such as sending messages, restarting conversations, or checking the initialization state.
///
/// ## Usage
///
/// 1. Create an instance of the controller:
/// ```dart
/// final controller = EbbotApiController();
/// ```
///
/// 2. Pass it to the configuration:
/// ```dart
/// final config = EbbotConfigurationBuilder()
///   .apiController(controller)
///   .build();
/// ```
///
/// 3. Use the controller to interact with the chat:
/// ```dart
/// // Send a message programmatically
/// controller.sendMessage('Hello from code!');
///
/// // Check if the chat is initialized
/// if (controller.isInitialized()) {
///   controller.restartConversation();
/// }
///
/// // Set user attributes
/// controller.setUserAttributes({'userId': '123', 'name': 'John'});
/// ```
class EbbotApiController extends AbstractEbbotApiController {
  EbbotFlutterUiState? _ebbotFlutterUiState;
  final ServiceLocator _serviceLocator = ServiceLocator();

  final String _ebbotClientServiceNotInitializedMessage =
      "EbbotClientService is not initialized";

  EbbotDartClient get _client =>
      _serviceLocator.getService<EbbotDartClientService>().client;

  void attach(EbbotFlutterUiState ebbotFlutterUiState) {
    _ebbotFlutterUiState = ebbotFlutterUiState;
  }

  /// Returns true if the chat widget is fully initialized and ready to use.
  ///
  /// You should check this before calling other methods to ensure the chat
  /// is ready to handle your requests.
  @override
  bool isInitialized() {
    _throwIfNotAttached();
    return _ebbotFlutterUiState?.isInitialized ?? false;
  }

  /// Restarts the current conversation.
  ///
  /// This will clear the chat history and start a fresh conversation.
  /// The chat will be reset to its initial state.
  @override
  void restartConversation() {
    _throwIfNotAttached();
    _ebbotFlutterUiState?.handleRestartConversation();
  }

  /// Ends the current conversation.
  ///
  /// This will close the chat session and notify the backend that the
  /// conversation has ended.
  @override
  void endConversation() {
    _throwIfNotAttached();
    _ebbotFlutterUiState?.handleEndConversation();
  }

  /// Sends a message to the chat programmatically.
  ///
  /// The message will appear as if the user typed it and sent it.
  /// This is useful for triggering chat flows or sending predefined messages.
  ///
  /// Parameters:
  /// - [message]: The text message to send
  @override
  void sendMessage(String message) {
    _throwIfNotAttached();
    _ebbotFlutterUiState?.handleAddMessageFromString(message);
  }

  /// Updates user attributes for the current conversation.
  ///
  /// This allows you to pass additional information about the user
  /// to the chat system, which can be used for personalization.
  ///
  /// Parameters:
  /// - [attributes]: A map of key-value pairs representing user attributes
  ///
  /// Example:
  /// ```dart
  /// controller.setUserAttributes({
  ///   'userId': '123',
  ///   'name': 'John Doe',
  ///   'email': 'john@example.com',
  ///   'membershipLevel': 'premium'
  /// });
  /// ```
  @override
  void setUserAttributes(Map<String, dynamic> attributes) {
    _throwIfNotAttached();
    _client.sendUpdateConversationInfoMessage(attributes);
  }

  /// Triggers a predefined scenario in the chat.
  ///
  /// Scenarios are predefined conversation flows that can be triggered
  /// programmatically. They are configured in the Ebbot backend.
  ///
  /// Parameters:
  /// - [scenarioId]: The ID of the scenario to trigger
  @override
  void triggerScenario(String scenarioId) {
    _throwIfNotAttached();
    _client.sendScenarioMessage(scenarioId);
  }

  /// Shows/downloads the conversation transcript.
  ///
  /// This will generate a transcript of the current conversation
  /// and either display it or download it to the device.
  @override
  void showTranscript() {
    _throwIfNotAttached();
    _ebbotFlutterUiState?.handleDownloadTranscript();
  }

  void _throwIfNotAttached() {
    if (_ebbotFlutterUiState == null) {
      throw StateError(_ebbotClientServiceNotInitializedMessage);
    }
  }
}

/// Abstract base class for Ebbot API controllers.
///
/// This defines the interface for controlling the Ebbot chat widget programmatically.
/// The [EbbotApiController] class implements this interface.
abstract class AbstractEbbotApiController {
  /// Returns true if the chat widget is initialized and ready to use.
  bool isInitialized();
  
  /// Restarts the current conversation, clearing chat history.
  void restartConversation();
  
  /// Shows/downloads the conversation transcript.
  void showTranscript();
  
  /// Sends a message to the chat programmatically.
  void sendMessage(String message);
  
  /// Updates user attributes for the current conversation.
  void setUserAttributes(Map<String, dynamic> attributes);
  
  /// Triggers a predefined scenario in the chat.
  void triggerScenario(String scenarioId);
  
  /// Ends the current conversation.
  void endConversation();
}
