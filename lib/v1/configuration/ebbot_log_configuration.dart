import 'package:logger/logger.dart';

class EbbotLogConfiguration {
  bool enabled;
  EbbotLogLevel logLevel;

  EbbotLogConfiguration._builder(EbbotLogConfigurationBuilder builder)
      : enabled = builder._enabled,
        logLevel = builder._logLevel;
}

class EbbotLogConfigurationBuilder {
  bool _enabled = false;
  EbbotLogLevel _logLevel = EbbotLogLevel.trace;

  EbbotLogConfigurationBuilder enabled(bool enabled) {
    _enabled = enabled;
    return this;
  }

  EbbotLogConfigurationBuilder logLevel(EbbotLogLevel logLevel) {
    _logLevel = logLevel;
    return this;
  }

  EbbotLogConfiguration build() {
    return EbbotLogConfiguration._builder(this);
  }
}

enum EbbotLogLevel {
  trace,
  debug,
  info,
  warning,
  error,
}

extension EbbotLogLevelExtension on EbbotLogLevel {
  Level get level {
    switch (this) {
      case EbbotLogLevel.trace:
        return Level.trace;
      case EbbotLogLevel.debug:
        return Level.debug;
      case EbbotLogLevel.info:
        return Level.info;
      case EbbotLogLevel.warning:
        return Level.warning;
      case EbbotLogLevel.error:
        return Level.error;
    }
  }
}