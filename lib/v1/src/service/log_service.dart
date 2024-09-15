import 'package:ebbot_flutter_ui/v1/configuration/ebbot_configuration.dart';
import 'package:ebbot_flutter_ui/v1/configuration/ebbot_log_configuration.dart';
import 'package:logger/logger.dart';

class LogService {
  final EbbotConfiguration _configuration;
  final _logger = Logger(
    printer: PrettyPrinter(),
  );

  LogService(this._configuration) {
    Logger.level = _configuration.logConfiguration.logLevel.level;
  }

  Logger? get logger =>
      _configuration.logConfiguration.enabled ? _logger : null;
}
