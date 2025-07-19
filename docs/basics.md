# Basic Configuration

This guide covers the fundamental configuration concepts for Ebbot Flutter UI.

## Configuration Overview

Ebbot Flutter UI uses a builder pattern for configuration, making it easy to customize the chat widget to your needs. All configuration is done through the `EbbotConfiguration` class and its associated builder.

## The Configuration Builder Pattern

The library uses a fluent builder pattern that allows you to chain configuration methods:

```dart
final configuration = EbbotConfigurationBuilder()
  .environment(Environment.production)
  .userConfiguration(/* ... */)
  .behaviour(/* ... */)
  .callback(/* ... */)
  .build();
```

## Minimal Configuration

The absolute minimum configuration requires only a bot ID:

```dart
EbbotFlutterUi(
  botId: 'your-bot-id',
)
```

This uses default configuration with:
- Staging environment
- No user attributes
- Default theme
- Standard behavior
- No callbacks

## Basic Configuration Example

Here's a basic configuration that covers common needs:

```dart
import 'package:ebbot_flutter_ui/ebbot_flutter_ui.dart';

final configuration = EbbotConfigurationBuilder()
  // Set the environment
  .environment(Environment.production)
  
  // Add basic user information
  .userConfiguration(
    EbbotUserConfigurationBuilder()
      .userAttributes({
        'userId': '12345',
        'name': 'John Doe',
      })
      .build()
  )
  
  // Configure basic behavior
  .behaviour(
    EbbotBehaviourBuilder()
      .showContextMenu(true)
      .build()
  )
  
  // Add a simple callback
  .callback(
    EbbotCallbackBuilder()
      .onLoad(() => print('Chat loaded'))
      .build()
  )
  
  .build();

// Use the configuration
EbbotFlutterUi(
  botId: 'your-bot-id',
  configuration: configuration,
)
```

## Configuration Categories

The configuration system is organized into several categories:

### 1. **Environment** ([Details](./environments.md))
Determines which Ebbot backend to connect to (staging, production, etc.)

### 2. **User Configuration** ([Details](./user-attributes.md))
Passes user-specific data to personalize conversations

### 3. **Behavior** ([Details](./behavior.md))
Controls UI elements and interaction patterns

### 4. **Styling** ([Details](./styling.md))
Customizes the visual appearance

### 5. **Callbacks** ([Details](./callbacks.md))
Handles chat events and lifecycle hooks

### 6. **Logging** ([Details](./logging.md))
Configures debug output and monitoring

### 7. **Session** ([Details](./advanced.md#session-management))
Manages chat session persistence and recovery

## Default Values

When you don't specify a configuration option, these defaults are used:

- **Environment**: `Environment.staging`
- **User Attributes**: Empty map
- **Show Context Menu**: `true`
- **Enter Key Behavior**: Send message
- **Logging**: Disabled
- **Theme**: Default light theme

## Configuration Best Practices

1. **Start Simple**: Begin with minimal configuration and add options as needed
2. **Environment-Specific Config**: Use different configurations for development and production
3. **Centralize Configuration**: Create a configuration service or constants file
4. **Null Safety**: The configuration builder handles null values gracefully

## Example: Configuration Service

```dart
class ChatConfiguration {
  static EbbotConfiguration get development => EbbotConfigurationBuilder()
    .environment(Environment.staging)
    .logConfiguration(
      EbbotLogConfigurationBuilder()
        .enabled(true)
        .logLevel(EbbotLogLevel.debug)
        .build()
    )
    .build();
    
  static EbbotConfiguration get production => EbbotConfigurationBuilder()
    .environment(Environment.production)
    .logConfiguration(
      EbbotLogConfigurationBuilder()
        .enabled(false)
        .build()
    )
    .build();
}

// Usage
EbbotFlutterUi(
  botId: 'your-bot-id',
  configuration: kDebugMode 
    ? ChatConfiguration.development 
    : ChatConfiguration.production,
)
```

## Next Steps

- Learn about [Styling and Theming](./styling.md)
- Configure [User Attributes](./user-attributes.md)
- Set up [Event Callbacks](./callbacks.md)
- Explore [Advanced Configuration](./advanced.md)

## Common Issues

If your configuration isn't working as expected:

1. Ensure you're calling `.build()` on all builders
2. Check that you're passing the configuration to the widget
3. Verify your bot ID is correct
4. Enable logging to debug issues

For more help, see the [Troubleshooting Guide](./troubleshooting.md).