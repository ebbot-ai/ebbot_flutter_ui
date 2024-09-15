import 'package:ebbot_dart_client/configuration/configuration.dart';
import 'package:ebbot_dart_client/ebbot_dart_client.dart';
import 'package:ebbot_flutter_ui/v1/configuration/ebbot_callback.dart';
import 'package:ebbot_flutter_ui/v1/src/service/ebbot_callback_service.dart';
import 'package:get_it/get_it.dart';

class EbbotDartClientService {
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

    _client = EbbotDartClient(_botId, _configuration);
    await initialize();
  }

  Future<void> initialize() async {
    final callbackService = GetIt.I.get<EbbotCallbackService>();
    try {
      await _client.initialize();
    } catch (e, stackTrace) {
      callbackService.dispatchInitializationError(EbbotLoadError(
          EbbotInitializationErrorType.network,
          'Failed to initialize EbbotDartClientService',
          stackTrace));
      rethrow;
    }

    // Send user attributes to the server on initialization
    if (_userAttributes.isNotEmpty) {
      _client.sendUpdateConversationInfoMessage(_userAttributes);
    }

    _isInitialized = true;
  }
}
