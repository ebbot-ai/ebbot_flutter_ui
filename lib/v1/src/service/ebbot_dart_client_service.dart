import 'package:ebbot_dart_client/configuration/configuration.dart';
import 'package:ebbot_dart_client/ebbot_dart_client.dart';
import 'package:ebbot_flutter_ui/v1/configuration/ebbot_callback.dart';
import 'package:ebbot_flutter_ui/v1/src/initializer/service_locator.dart';
import 'package:ebbot_flutter_ui/v1/src/service/ebbot_callback_service.dart';

class EbbotDartClientService {
  final _serviceLocator = ServiceLocator();
  final String _botId;
  final Configuration _configuration;
  final Map<String, dynamic> _userAttributes;
  late EbbotDartClient _client;
  bool _isInitialized = false;

  EbbotDartClient get client {
    if (!_isInitialized) {
      throw Exception('EbbotClientService not initialized');
    }
    return _client;
  }

  EbbotDartClientService(
      this._botId, this._configuration, this._userAttributes) {
    _client = EbbotDartClient(_botId, _configuration);
  }

  void endSession() {
    _client.sendCloseChatMessage();
  }

  Future<void> restartAsync() async {
    await _client.closeAsync(closeSocket: true);
    //await _client.disposeAsync();

    // Remove the chatId from the configuration object as we want to start a new session
    // TODO: Implement immutability here..
    _configuration.sessionConfiguration.chatId = null;
    _client = EbbotDartClient(_botId, _configuration);
    await initialize();
  }

  Future<void> initialize() async {
    final callbackService = _serviceLocator.getService<EbbotCallbackService>();
    try {
      await _client.initialize();
    } catch (e, stackTrace) {
      callbackService.dispatchInitializationError(EbbotLoadError(
          EbbotInitializationErrorType.network,
          'Failed to initialize EbbotDartClientService',
          stackTrace));
      rethrow;
    }

    // Dispatch onSessionData callback on initialization
    final httpSession = _client.session;
    callbackService.dispatchOnSessionData(httpSession.data.session.chatId);

    // Send user attributes to the server on initialization
    if (_userAttributes.isNotEmpty) {
      _client.sendUpdateConversationInfoMessage(_userAttributes);
    }

    _isInitialized = true;
  }
}
