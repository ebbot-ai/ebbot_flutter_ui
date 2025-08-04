# Ebbot Flutter UI

A Flutter UI library for integrating Ebbot chat functionality into Flutter applications. This library provides a complete chat interface with real-time messaging, image uploads, session management, and customizable themes.

## Features

- 🚀 **Real-time messaging** with WebSocket support
- 📱 **Cross-platform** support (iOS, Android, Web, Desktop)
- 📸 **Image upload** capabilities
- 🔄 **Session management** and recovery
- 🎨 **Customizable themes** and styling
- 👥 **Agent handover** support
- 📝 **Conversation transcripts**
- 🔧 **Programmatic API** for chat control
- 📋 **Context menu** with chat actions
- 🌐 **Multi-environment** support (staging, production)

## Installation

Add this library to your Flutter project by adding it to your `pubspec.yaml`:

```yaml
dependencies:
  ebbot_flutter_ui:
    git:
      url: https://github.com/ebbot-ai/ebbot-flutter-ui.git
      ref: main  # or specify a specific version tag
```

Then run:

```bash
flutter pub get
```

## Quick Start

### Basic Usage

```dart
import 'package:flutter/material.dart';
import 'package:ebbot_flutter_ui/ebbot_flutter_ui.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Ebbot Chat')),
        body: EbbotFlutterUi(
          botId: 'your-bot-id',
          configuration: EbbotConfigurationBuilder()
            .environment(Environment.production)
            .build(),
        ),
      ),
    );
  }
}
```

### Advanced Configuration

```dart
import 'package:ebbot_flutter_ui/ebbot_flutter_ui.dart';

class AdvancedChatExample extends StatelessWidget {
  final EbbotApiController _controller = EbbotApiController();

  @override
  Widget build(BuildContext context) {
    return EbbotFlutterUi(
      botId: 'your-bot-id',
      configuration: EbbotConfigurationBuilder()
        .environment(Environment.production)
        .apiController(_controller)
        .userConfiguration(
          EbbotUserConfigurationBuilder()
            .userAttributes({
              'userId': '123',
              'name': 'John Doe',
              'email': 'john@example.com',
              'membershipLevel': 'premium'
            })
            .build()
        )
        .behaviour(
          EbbotBehaviourBuilder()
            .showContextMenu(true)
            .build()
        )
        .callback(
          EbbotCallbackBuilder()
            .onLoad(() => print('Chat loaded'))
            .onMessage((message) => print('Message: $message'))
            .onBotMessage((message) => print('Bot: $message'))
            .onUserMessage((message) => print('User: $message'))
            .onStartConversation((message) => print('Started: $message'))
            .onEndConversation(() => print('Ended'))
            .build()
        )
        .logConfiguration(
          EbbotLogConfigurationBuilder()
            .enabled(true)
            .logLevel(EbbotLogLevel.debug)
            .build()
        )
        .build(),
    );
  }
}
```

### Programmatic Control

```dart
// Send a message programmatically
_controller.sendMessage('Hello from code!');

// Check if chat is initialized
if (_controller.isInitialized()) {
  // Restart the conversation
  _controller.restartConversation();
}

// Update user attributes
_controller.setUserAttributes({
  'userId': '456',
  'name': 'Jane Smith'
});

// Trigger a scenario
_controller.triggerScenario('550e8400-e29b-41d4-a716-446655440000');

// End the conversation
_controller.endConversation();
```

## Configuration Options

### Environment Configuration

```dart
EbbotConfigurationBuilder()
  .environment(Environment.production)  // or Environment.staging
  .build()
```

### User Configuration

```dart
EbbotUserConfigurationBuilder()
  .userAttributes({
    'userId': '123',
    'name': 'John Doe',
    'email': 'john@example.com',
    'customField': 'value'
  })
  .build()
```

### Behavior Configuration

```dart
EbbotBehaviourBuilder()
  .showContextMenu(true)          // Show context menu with actions
  .input(
    EbbotBehaviourInputBuilder()
      .enterPressed(EbbotBehaviourInputEnterPressed.sendMessage)
      .build()
  )
  .build()
```

### Session Management

```dart
EbbotSessionBuilder()
  .chatId('existing-chat-id-123')  // Resume existing conversation
  .build()
```

### Logging Configuration

```dart
EbbotLogConfigurationBuilder()
  .enabled(true)
  .logLevel(EbbotLogLevel.debug)  // debug, info, warning, error
  .build()
```

## Event Callbacks

Handle chat events with custom callbacks:

```dart
EbbotCallbackBuilder()
  .onLoad(() {
    print('Chat loaded successfully');
  })
  .onMessage((message) {
    print('New message: $message');
  })
  .onBotMessage((message) {
    print('Bot message: $message');
  })
  .onUserMessage((message) {
    print('User message: $message');
  })
  .onStartConversation((message) {
    print('Conversation started with: $message');
  })
  .onEndConversation(() {
    print('Conversation ended');
  })
  .onRestartConversation(() {
    print('Conversation restarted');
  })
  .onSessionData((chatId) {
    print('Session data received: $chatId');
  })
  .onLoadError((error) {
    print('Load error: $error');
  })
  .build()
```

## Multi-page Integration

The chat widget maintains its state across page navigation:

```dart
class MultiPageExample extends StatefulWidget {
  @override
  _MultiPageExampleState createState() => _MultiPageExampleState();
}

class _MultiPageExampleState extends State<MultiPageExample> {
  final PageController _pageController = PageController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: [
          // Other pages
          Container(child: Text('Page 1')),
          Container(child: Text('Page 2')),
          
          // Chat page with key for state preservation
          EbbotFlutterUi(
            key: PageStorageKey('chat-page'),
            botId: 'your-bot-id',
            configuration: yourConfiguration,
          ),
        ],
      ),
    );
  }
}
```

## Example Application

A complete example application demonstrating all features can be found in the `example/` directory. To run it:

```bash
cd example
flutter pub get
flutter run
```

## Technical Dependencies

- **flutter_chat_ui**: Provides the chat interface components
- **ebbot_dart_client**: Handles the business logic and API communication
- **flutter_chat_types**: Defines message types and structures

## Documentation

For more detailed documentation, please see:
- [Getting Started Guide](docs/getting-started.md)
- [Configuration Guide](docs/configuration.md)
- [API Reference](docs/index.md)

## Platform Support

- ✅ Android
- ✅ iOS  
- ✅ Web
- ✅ macOS
- ✅ Windows
- ✅ Linux

## License

This library is proprietary software. Please contact Ebbot for licensing information.

## Support

For support and questions:
- Create an issue on GitHub
- Contact the development team
- Check the documentation at [docs.ebbot.ai](https://docs.ebbot.ai)
