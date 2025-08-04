# Environment Configuration

Configure which Ebbot backend environment your chat widget connects to.

## Overview

Ebbot provides multiple environments for different purposes:
- **Staging** - For development and testing
- **Production** - For live applications
- **Regional deployments** - For optimal performance based on location

## Available Environments

| Environment | Purpose | Configuration Host | Chat API Host |
|------------|---------|-------------------|---------------|
| `Environment.staging` | Development/Testing | https://ebbot-staging.storage.googleapis.com | wss://staging.ebbot.app/api/asyngular |
| `Environment.release` | Pre-production | https://ebbot-release.storage.googleapis.com | wss://release.ebbot.app/api/asyngular |
| `Environment.googleCanadaProduction` | Production (Canada) | https://ebbot-ca.storage.googleapis.com | wss://ca.ebbot.app/api/asyngular |
| `Environment.googleEUProduction` | Production (EU) | https://ebbot-v2.storage.googleapis.com | wss://v2.ebbot.app/api/asyngular |
| `Environment.ovhEUProduction` | Production (EU - OVH) | https://storage.gra.cloud.ovh.net | wss://ebbot.eu/api/asyngular |

## Basic Configuration

Set the environment in your configuration:

```dart
import 'package:ebbot_flutter_ui/ebbot_flutter_ui.dart';

final configuration = EbbotConfigurationBuilder()
  .environment(Environment.production)  // or any other environment
  .build();

EbbotFlutterUi(
  botId: 'your-bot-id',
  configuration: configuration,
)
```

## Choosing the Right Environment

### Development Phase
Use `Environment.staging` during development:

```dart
final configuration = EbbotConfigurationBuilder()
  .environment(Environment.staging)
  .logConfiguration(
    EbbotLogConfigurationBuilder()
      .enabled(true)
      .logLevel(EbbotLogLevel.debug)
      .build()
  )
  .build();
```

### Production Deployment
Use the environment where your bot is configured. Your specific environment will be determined by your bot setup.

## Environment-Specific Configuration

Different configurations for different environments:

```dart
class ChatConfig {
  static EbbotConfiguration getConfiguration(bool isProduction) {
    if (isProduction) {
      return EbbotConfigurationBuilder()
        .environment(Environment.googleEUProduction)
        .logConfiguration(
          EbbotLogConfigurationBuilder()
            .enabled(false)  // Disable logs in production
            .build()
        )
        .build();
    } else {
      return EbbotConfigurationBuilder()
        .environment(Environment.staging)
        .logConfiguration(
          EbbotLogConfigurationBuilder()
            .enabled(true)
            .logLevel(EbbotLogLevel.debug)
            .build()
        )
        .build();
    }
  }
}
```

## Using Environment Variables

Load environment from configuration:

```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Environment _getEnvironment() {
    final envString = dotenv.env['EBBOT_ENVIRONMENT'] ?? 'staging';
    
    switch (envString) {
      case 'production_eu':
        return Environment.googleEUProduction;
      case 'production_ca':
        return Environment.googleCanadaProduction;
      case 'release':
        return Environment.release;
      default:
        return Environment.staging;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final configuration = EbbotConfigurationBuilder()
      .environment(_getEnvironment())
      .build();
    
    return MaterialApp(
      home: EbbotFlutterUi(
        botId: dotenv.env['EBBOT_BOT_ID']!,
        configuration: configuration,
      ),
    );
  }
}
```

## Build Flavors Integration

Configure different environments for different build flavors:

### Flutter Flavors Setup

```dart
// lib/config/app_config.dart
class AppConfig {
  final String appName;
  final Environment ebbotEnvironment;
  final String botId;
  
  AppConfig({
    required this.appName,
    required this.ebbotEnvironment,
    required this.botId,
  });
}

// lib/main_dev.dart
import 'main_common.dart';

void main() {
  final config = AppConfig(
    appName: 'MyApp Dev',
    ebbotEnvironment: Environment.staging,
    botId: 'dev-bot-id',
  );
  mainCommon(config);
}

// lib/main_prod.dart
import 'main_common.dart';

void main() {
  final config = AppConfig(
    appName: 'MyApp',
    ebbotEnvironment: Environment.googleEUProduction,
    botId: 'prod-bot-id',
  );
  mainCommon(config);
}
```

## Multi-Environment Setup

If you have bots in different environments (e.g., staging for development, production for live):

```dart
Environment getEnvironmentForMode(bool isProduction) {
  if (isProduction) {
    // Use your production bot's environment
    return Environment.googleEUProduction; // Replace with your actual environment
  } else {
    // Use staging for development
    return Environment.staging;
  }
}
```

## Testing Different Environments

Create a debug menu to switch environments:

```dart
class DebugEnvironmentSelector extends StatefulWidget {
  final Function(Environment) onEnvironmentChanged;
  
  const DebugEnvironmentSelector({
    Key? key,
    required this.onEnvironmentChanged,
  }) : super(key: key);
  
  @override
  _DebugEnvironmentSelectorState createState() => 
      _DebugEnvironmentSelectorState();
}

class _DebugEnvironmentSelectorState 
    extends State<DebugEnvironmentSelector> {
  Environment _selectedEnvironment = Environment.staging;
  
  @override
  Widget build(BuildContext context) {
    if (!kDebugMode) return SizedBox.shrink();
    
    return DropdownButton<Environment>(
      value: _selectedEnvironment,
      items: [
        DropdownMenuItem(
          value: Environment.staging,
          child: Text('Staging'),
        ),
        DropdownMenuItem(
          value: Environment.release,
          child: Text('Release'),
        ),
        DropdownMenuItem(
          value: Environment.googleEUProduction,
          child: Text('Production EU'),
        ),
        DropdownMenuItem(
          value: Environment.googleCanadaProduction,
          child: Text('Production CA'),
        ),
      ],
      onChanged: (Environment? newValue) {
        if (newValue != null) {
          setState(() {
            _selectedEnvironment = newValue;
          });
          widget.onEnvironmentChanged(newValue);
        }
      },
    );
  }
}
```

## Environment Selection

Use the environment where your bot is configured. This is determined by your bot setup and technical requirements.

## Security Notes

1. **Never expose production bot IDs in staging environments**
2. **Use different bot configurations for each environment**
3. **Monitor environment-specific logs separately**

## Common Issues

### Wrong Environment Symptoms
- Chat not connecting
- Configuration not loading
- Messages not being delivered
- Authentication failures

### Debugging Environment Issues

```dart
final configuration = EbbotConfigurationBuilder()
  .environment(Environment.staging)
  .logConfiguration(
    EbbotLogConfigurationBuilder()
      .enabled(true)
      .logLevel(EbbotLogLevel.debug)
      .build()
  )
  .callback(
    EbbotCallbackBuilder()
      .onLoadError((error) {
        print('Environment error: ${error.cause}');
      })
      .build()
  )
  .build();
```

## Next Steps

- Set up [Event Callbacks](./callbacks.md) for environment monitoring
- Configure [Logging](./logging.md) for different environments
- Implement [Chat Behavior](./behavior.md) configuration
- Review [Advanced Configuration](./advanced.md) for multi-environment setups

## Support

Start with staging for initial testing, then use the production environment specified for your bot.

For more help, see the [Troubleshooting Guide](./troubleshooting.md).