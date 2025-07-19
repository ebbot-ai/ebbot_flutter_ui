# Logging Configuration

Configure debug logging to troubleshoot issues and monitor chat behavior.

## Overview

Logging helps you:
- Debug initialization and connection issues
- Monitor message flow
- Track user interactions
- Identify performance bottlenecks
- Diagnose configuration problems

## Basic Configuration

```dart
final configuration = EbbotConfigurationBuilder()
  .logConfiguration(
    EbbotLogConfigurationBuilder()
      .enabled(true)
      .logLevel(EbbotLogLevel.debug)
      .build()
  )
  .build();
```

## Log Levels

| Level | Description | Use Case |
|-------|-------------|----------|
| `EbbotLogLevel.trace` | Extremely detailed logs | Deep debugging |
| `EbbotLogLevel.debug` | Detailed debug information | Development |
| `EbbotLogLevel.info` | General information | Monitoring |
| `EbbotLogLevel.warning` | Warning messages | Issues detection |
| `EbbotLogLevel.error` | Error messages only | Production monitoring |

## Environment-Specific Logging

### Development Configuration
Verbose logging for debugging:

```dart
final devLogConfig = EbbotLogConfigurationBuilder()
  .enabled(true)
  .logLevel(EbbotLogLevel.debug)
  .build();
```

### Production Configuration
Minimal logging for performance:

```dart
final prodLogConfig = EbbotLogConfigurationBuilder()
  .enabled(false)  // Or only errors
  .logLevel(EbbotLogLevel.error)
  .build();
```

### Conditional Configuration
Based on build mode:

```dart
EbbotLogConfiguration getLogConfig() {
  if (kDebugMode) {
    return EbbotLogConfigurationBuilder()
      .enabled(true)
      .logLevel(EbbotLogLevel.debug)
      .build();
  } else {
    return EbbotLogConfigurationBuilder()
      .enabled(false)
      .build();
  }
}
```

## Complete Example

```dart
import 'package:flutter/foundation.dart';
import 'package:ebbot_flutter_ui/ebbot_flutter_ui.dart';

class LoggingExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final configuration = EbbotConfigurationBuilder()
      .environment(kDebugMode 
        ? Environment.staging 
        : Environment.production)
      .logConfiguration(
        EbbotLogConfigurationBuilder()
          .enabled(kDebugMode)
          .logLevel(kDebugMode 
            ? EbbotLogLevel.debug 
            : EbbotLogLevel.error)
          .build()
      )
      .callback(
        EbbotCallbackBuilder()
          .onLoad(() => debugPrint('Chat loaded successfully'))
          .onLoadError((error) => debugPrint('Load error: $error'))
          .build()
      )
      .build();
    
    return EbbotFlutterUi(
      botId: 'your-bot-id',
      configuration: configuration,
    );
  }
}
```


## Custom Log Handling

Integrate with your logging system:

```dart
class CustomLogHandler {
  static void setupLogging() {
    // Monitor chat widget logs
    if (kDebugMode) {
      // Log chat events for debugging
      debugPrint('Chat logging enabled for development');
    }
  }
}
```

## Performance Monitoring

Log performance metrics:

```dart
class PerformanceLogger {
  static Stopwatch? _initTimer;
  
  static void startInitTimer() {
    _initTimer = Stopwatch()..start();
  }
  
  static void logInitComplete() {
    if (_initTimer != null) {
      debugPrint('Chat init took: ${_initTimer!.elapsedMilliseconds}ms');
      _initTimer = null;
    }
  }
}

// Usage in configuration
.callback(
  EbbotCallbackBuilder()
    .onLoad(() {
      PerformanceLogger.logInitComplete();
    })
    .build()
)
```

## Debug-Only Logging

Conditionally log sensitive information:

```dart
void logUserAttributes(Map<String, dynamic> attributes) {
  if (kDebugMode) {
    debugPrint('User attributes: $attributes');
  } else {
    // Log only non-sensitive data in production
    debugPrint('User attributes updated (${attributes.length} items)');
  }
}
```

## Log Filtering

Filter logs by category:

```dart
class LogFilter {
  static final Set<String> _enabledCategories = {
    'init',
    'messages',
    'errors',
  };
  
  static void log(String category, String message) {
    if (kDebugMode && _enabledCategories.contains(category)) {
      debugPrint('[$category] $message');
    }
  }
}

// Usage
LogFilter.log('init', 'Chat widget initializing');
LogFilter.log('messages', 'New message received');
```




## Best Practices

1. **Disable in production** or use minimal levels
2. **Use appropriate log levels** for different information
3. **Consider performance impact** of verbose logging

## Next Steps

- Explore [Advanced Configuration](./advanced.md) examples
- Review [Troubleshooting Guide](./troubleshooting.md) for common issues
- Set up [Event Callbacks](./callbacks.md) for comprehensive monitoring
- Configure [Environment Settings](./environments.md) for different log levels

## Troubleshooting

If logging isn't working:

1. Check that logging is enabled
2. Verify the log level is appropriate
3. Ensure debug mode is active for debug logs
4. Check console output filters
5. Verify platform-specific logging setup

For more help, see the [Troubleshooting Guide](./troubleshooting.md).