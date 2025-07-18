# Ebbot Flutter UI Example

This directory contains example applications demonstrating how to use the `ebbot_flutter_ui` library.

## Running the Example

1. Make sure you have Flutter installed and set up
2. Navigate to the example directory:
   ```bash
   cd example
   ```
3. Get dependencies:
   ```bash
   flutter pub get
   ```
4. Run the app:
   ```bash
   flutter run
   ```

## Examples Included

### Basic Chat Integration
The main example shows how to integrate the Ebbot chat widget into a Flutter application with:
- Multiple bot configurations for different environments
- User attribute passing
- Custom callbacks for chat events
- Session management
- Custom styling

### Features Demonstrated

- **Environment Configuration**: Switch between different Ebbot environments
- **User Attributes**: Pass user information to the chat
- **Event Callbacks**: Handle chat events like messages, session start/end
- **Session Recovery**: Resume existing chat sessions
- **Custom Styling**: Apply custom themes and colors
- **Multi-page Integration**: Shows how to preserve chat state across page navigation

## Configuration

The example demonstrates various configuration options:

```dart
var configuration = EbbotConfigurationBuilder()
    .environment(Environment.production)
    .userConfiguration(
      EbbotUserConfigurationBuilder()
        .userAttributes({'name': 'John Doe', 'email': 'john@doe.com'})
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
        .build()
    )
    .build();
```

## Bot Configuration

The example includes configurations for different clients:
- Husqvarna
- Forest
- Ebbot Test

Each configuration specifies the bot ID and environment to use.