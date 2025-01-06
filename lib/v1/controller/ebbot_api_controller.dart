import 'package:ebbot_dart_client/ebbot_dart_client.dart';
import 'package:ebbot_flutter_ui/v1/ebbot_flutter_ui.dart';
import 'package:ebbot_flutter_ui/v1/src/initializer/service_locator.dart';
import 'package:ebbot_flutter_ui/v1/src/service/ebbot_dart_client_service.dart';
import 'package:get_it/get_it.dart';

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

  @override
  bool isInitialized() {
    _throwIfNotAttached();
    return _ebbotFlutterUiState?.isInitialized ?? false;
  }

  @override
  void restartConversation() {
    _throwIfNotAttached();
    _ebbotFlutterUiState?.handleRestartConversation();
  }

  @override
  void endConversation() {
    _throwIfNotAttached();
    _ebbotFlutterUiState?.handleEndConversation();
  }

  @override
  void sendMessage(String message) {
    _throwIfNotAttached();
    _ebbotFlutterUiState?.handleAddMessageFromString(message);
  }

  @override
  void setUserAttributes(Map<String, dynamic> attributes) {
    _throwIfNotAttached();
    _client.sendUpdateConversationInfoMessage(attributes);
  }

  @override
  void triggerScenario(String scenarioId) {
    _throwIfNotAttached();
    _client.sendScenarioMessage(scenarioId);
  }

  void _throwIfNotAttached() {
    throwIf(
        _ebbotFlutterUiState == null, _ebbotClientServiceNotInitializedMessage);
  }
}

abstract class AbstractEbbotApiController {
  bool isInitialized();
  void restartConversation();
  void sendMessage(String message);
  void setUserAttributes(Map<String, dynamic> attributes);
  void triggerScenario(String scenarioId);
  void endConversation();
}
