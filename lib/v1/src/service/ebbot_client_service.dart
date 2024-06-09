import 'package:ebbot_dart_client/configuration/configuration.dart';
import 'package:ebbot_dart_client/ebbot_dart_client.dart';
import 'package:ebbot_flutter_ui/v1/configuration/ebbot_callback.dart';
import 'package:ebbot_flutter_ui/v1/src/service/ebbot_callback_service.dart';
import 'package:get_it/get_it.dart';

class EbbotClientService {
  final String _botId;
  final Configuration _configuration;
  late EbbotDartClient _client;
  bool _isInitialized = false;

  EbbotDartClient get client {
    if (!_isInitialized) {
      throw Exception('EbbotClientService not initialized');
    }
    return _client;
  }

  EbbotClientService(this._botId, this._configuration) {
    _client = EbbotDartClient(_botId, _configuration);
  }

  Future<void> initialize() async {
    final callbackService = GetIt.I.get<EbbotCallbackService>();
    try {
      await _client.initialize();
    } catch (e, stackTrace) {
      callbackService.dispatchInitializationError(EbbotInitializationError(
          EbbotInitializationErrorType.network,
          'Failed to initialize EbbotClientService',
          stackTrace));
      rethrow;
    }
    _isInitialized = true;
  }
}
